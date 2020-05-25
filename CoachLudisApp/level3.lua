-----------------------------------------------------------------------------------------
--
-- level1.lua
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()

-- include Corona's "physics" library
local physics = require "physics"

--------------------------------------------
clockTicking = audio.loadSound( "sound/clock_ticking.mp3")

-- forward declarations and other locals
local screenW, screenH, halfW = display.actualContentWidth, display.actualContentHeight, display.contentCenterX

function scene:create( event )
	-- Called when the scene's view does not exist.
	-- 
	-- INSERT code here to initialize the scene
	-- e.g. add display objects to 'sceneGroup', add touch listeners, etc.

	local sceneGroup = self.view

	-- We need physics started to add bodies, but we don't want the simulaton
	-- running until the scene is on the screen.
	physics.start()
	physics.pause()

	--Video code
	-- indicator whether the game is complete or not
	local gameComplete = false
	local countDown = 10
	pauseTime = false;
	resumeTime = true;

	timerText = display.newText( "", 100, 100, native.systemFont, 16)
	timerText:translate(55,-40)
	timerText:setTextColor( 255, 255, 255 )

	function goBackToPlay(e)
		if(e.phase == "began") then
			e.target:removeSelf()
			if composer.game == 'soccer' then
				composer.gotoScene("level2","fade",500)
			else
				composer.hideOverlay( "fade", 500 )
			end
		end
	end

	function gameOver()
		if(gameComplete == false) then
			if countDown == 0  then
				countDown = 0
				gameComplete = true
				currentTime = countDown
				local stage = display.getCurrentStage()
				timerText:removeSelf()
				timerText = nil
				ice_pack:removeSelf()
				arm:removeSelf()
				composer.healthIncrease = 0
				composer.success = false

				local zeroBackground = display.newImageRect( "images/precaution level decrease screen/0 health.png", screenW, screenH )
				zeroBackground.anchorX = 0
				zeroBackground.anchorY = 0
				zeroBackground:addEventListener( "touch", goBackToPlay )
			else

				timerText.text = "Time:"..countDown
				currentTime = countDown
				countDown = countDown - 1
			end
		end
	end

	countDownTimer = timer.performWithDelay( 1000, gameOver, 11 )



	local win = display.newImageRect( "celebration.png", screenW, screenH )
	
	local function showRatings()
		composer.stars = countDown
		composer.gotoScene( "rate", "fade", 500 )
	end
	win.anchorX = 0
	win.anchorY = 0
	win.isVisible = false
	win.touch = showRatings
	win:addEventListener( "touch", win )

	local loss = display.newImageRect( "gameOver.png", screenW, screenH )
	
	loss.anchorX = 0
	loss.anchorY = 0
	loss.isVisible = false	

	local function showWin()
		win.isVisible = true
	end

	local function showGameOver(event)
		loss.isVisible = true
	end

-- create a grey rectangle as the backdrop
	-- the physical screen will likely be a different shape than our defined content area
	-- since we are going to position the background from it's top, left corner, draw the
	-- background at the real top, left corner.
	local background = display.newRect( display.screenOriginX, display.screenOriginY, screenW, screenH )
	background.anchorX = 0 
	background.anchorY = 0
	background:setFillColor( .5 )

	-- create a arm object and add physics (with custom shape)
	arm = display.newImageRect( "ice_background.png", screenW, screenH )
	arm.anchorX = 0
	arm.anchorY = 1
	--  draw the arm at the very bottom of the screen
	arm.x, arm.y = display.screenOriginX, display.actualContentHeight + display.screenOriginY
	
	-- define a shape that's slightly shorter than image bounds (set draw mode to "hybrid" or "debug" to see)
	local armShape = { -halfW,-34, halfW,-34, halfW,34, -halfW,34 }
	physics.addBody( arm, "static", { friction=0.3, shape=armShape } )
	myCircle = display.newCircle( 440, 260, 70 )
	myCircle:setFillColor(1,0,0)
	ice_pack = display.newImageRect( "ice_pack.png", 100, 100 )
	ice_pack:translate( 100, 100 )
	hot_water_bag = display.newImageRect( "hot_water_bag.png", 100, 100 )
	hot_water_bag:translate(100,220)
	--bandage = display.newImageRect( "bandage.png", 100, 100 )
	function ice_pack:touch( event)
		if event.phase == "began" then
			self.markX = self.x
			self.markY = self.y
		elseif event.phase == "moved" then
			local x = (event.x - event.xStart) + self.markX
			local y = (event.y - event.yStart) + self.markY
			self.x,self.y = x,y
		end
		return true
	end

	
	local function onObjectTouch( event )
		if ( event.phase == "began" ) then
			gameComplete = true
			countDown = 0
			composer.healthIncrease = 0
			composer.success = false
			display.remove(myCircle)
			myCircle = nil
			timerText:removeSelf()
			timerText = nil
			ice_pack:removeSelf()
			arm:removeSelf()
			hot_water_bag:removeSelf()
			local zeroBackground = display.newImageRect( "images/precaution level decrease screen/0 health.png", screenW, screenH )
			zeroBackground.anchorX = 0
			zeroBackground.anchorY = 0
			zeroBackground:addEventListener( "touch", goBackToPlay )
		end
		return true
	end
	hot_water_bag:addEventListener( "touch", onObjectTouch )
	
	




	local function hasCollidedCircle( obj1, obj2, radius )
 		if(gameComplete == false) then
			if ( obj1 == nil ) then  -- Make sure the first object exists
				return false
			end
			if ( obj2 == nil ) then  -- Make sure the other object exists
				return false
			end
	 
			if ((obj1.x - obj2.x) * (obj1.x - obj2.x) + (obj1.y - obj2.y) * (obj1.y - obj2.y) < radius * radius) then
				return true; 
			else
				return false; 
			end
		end
	end
	
	function gameLoop( event )
			-- Check for collision between player and this coin instance
			for radius = 100,0,-2 do
				if ( hasCollidedCircle( ice_pack, myCircle, radius ) ) then
				-- Remove the coin from the screen
					display.remove(myCircle)
					--myCircle = nil
					myCircle = display.newCircle(440, 260,radius)
					myCircle:setFillColor(1,0,0)
					-- Remove reference from table
					if (radius == 10) then
						display.remove(myCircle)
						myCircle = nil
						timerText:removeSelf()
						timerText = nil
						ice_pack:removeSelf()
						arm:removeSelf()
						if countDown <= 3 then
							composer.healthIncrease = 20
							local twentyBackground = display.newImageRect( "images/precaution level decrease screen/20 health.png", screenW, screenH )
							twentyBackground.anchorX = 0
							twentyBackground.anchorY = 0
							twentyBackground:addEventListener( "touch", goBackToPlay )
						elseif countDown <= 6 then
							composer.healthIncrease = 40 
							local fortyBackground = display.newImageRect( "images/precaution level decrease screen/40 health.png", screenW, screenH )
							fortyBackground.anchorX = 0
							fortyBackground.anchorY = 0
							fortyBackground:addEventListener( "touch", goBackToPlay )
						elseif countDown <= 9 then
							composer.healthIncrease = 60
							local sixtyBackground = display.newImageRect( "images/precaution level decrease screen/60 health.png", screenW, screenH )
							sixtyBackground.anchorX = 0
							sixtyBackground.anchorY = 0
							sixtyBackground:addEventListener( "touch", goBackToPlay )
						else
							composer.healthIncrease = 0
							local zeroBackground = display.newImageRect( "images/precaution level decrease screen/0 health.png", screenW, screenH )
							zeroBackground.anchorX = 0
							zeroBackground.anchorY = 0
							zeroBackground:addEventListener( "touch", goBackToPlay )
						end
						gameComplete = true
						timer.cancel(countDownTimer)
						composer.success =  true

						break
					end	
					-- Handle other collision aspects like increasing score, etc.
				end
			end
		return true
	end
	Runtime:addEventListener( "enterFrame", gameLoop )
	ice_pack:addEventListener ("touch",ice_pack)



	local settingBackground = display.newImageRect( "images/background/app background/appBack.png", screenW, screenH )
	settingBackground.anchorX = 0 
	settingBackground.anchorY = 0
	settingBackground:setFillColor( 0.8 )
	settingBackground.isVisible = false


	local settingWindow = display.newImageRect( "images/background/app background/paused window.png", 150, 200 )
	settingWindow.x = display.contentCenterX + 45
	settingWindow.y = display.contentCenterY
	settingWindow.isVisible = false

	local playButton = display.newImageRect( "images/background/app background/play button.png", 50, 50 )
	playButton.x =  display.contentCenterX + 25
	playButton.y = display.contentCenterY - 10
	playButton.isVisible = false


	local replayButton = display.newImageRect( "images/background/app background/restart button.png", 50, 50 )

	local function startPlaying( )
		settingBackground.isVisible = false
		settingWindow.isVisible = false
		playButton.isVisible = false
		replayButton.isVisible = false
		timer.resume( countDownTimer )
		pauseTime = false
		resumeTime = true
	end

	playButton:addEventListener( "touch", startPlaying )



	local function selectSetting()
		settingBackground.isVisible = true
		settingWindow.isVisible = true
		playButton.isVisible = true
		replayButton.isVisible = true
		timer.pause( countDownTimer )
		pauseTime = true
		resumeTime = false
	end

	local function replayButtonEvent()
		composer.removeScene( composer.levelPlaying)
		composer.gotoScene( composer.levelPlaying, "fade", 500 )

	end

	
	settingsButton = display.newImageRect( "images/commons/setting button.png", 50, 50 )
	settingsButton.x =  display.contentCenterX + 300
	settingsButton.y = display.contentCenterY - 140
	settingsButton:addEventListener( "touch", selectSetting )

	replayButton.x =  display.contentCenterX + 65
	replayButton.y = display.contentCenterY - 10
	replayButton.isVisible = false
	replayButton:addEventListener( "touch", replayButtonEvent )



	-- all display objects must be inserted into group
	sceneGroup:insert( background )
	sceneGroup:insert( arm)
	sceneGroup:insert(ice_pack)
	sceneGroup:insert(myCircle)
	sceneGroup:insert(timerText)
	sceneGroup:insert(hot_water_bag)
	sceneGroup:insert(settingBackground)
	sceneGroup:insert(settingsButton)
	sceneGroup:insert(settingWindow)
	sceneGroup:insert(playButton)
	sceneGroup:insert(replayButton)
end

function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase
	
	if phase == "will" then
		-- Called when the scene is still off screen and is about to move on screen
	elseif phase == "did" then
		-- Called when the scene is now on screen
		-- 
		if(sound == "ON") then

			audio.stop()
			audio.play(clockTicking, { channel=2, loops=-1})
		else
			audio.stop()
		end

		-- INSERT code here to make the scene come alive
		-- e.g. start timers, begin animation, play audio, etc.
		physics.start()
	end
end

function scene:hide( event )
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Call the "resumeGame()" function in the parent scene
        --composer.chance = 0
    	if (composer.game ==  'cycle') then
        	local parent = event.parent
        	parent:resumeGame()
        end
    end

end

function scene:destroy( event )

	-- Called prior to the removal of scene's "view" (sceneGroup)
	-- 
	-- INSERT code here to cleanup the scene
	-- e.g. remove display objects, remove touch listeners, save state, etc.
	local sceneGroup = self.view
	
	package.loaded[physics] = nil
	physics = nil
end

---------------------------------------------------------------------------------

---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

-----------------------------------------------------------------------------------------

return scene