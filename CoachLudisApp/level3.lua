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

	local gameComplete = false
	local countDown = 10
	pauseTime = false;
	resumeTime = true;

	local timerText = display.newText( "", 100, 100, native.systemFont, 16)
	timerText:setTextColor( 255, 255, 255 )

	local timeBut = display.newRect( 100, 0, 150, 25 )
	timeBut:setFillColor( 255, 255, 255 )
	physics.addBody( timeBut, "static" )

	local buttonText = display.newText ( "", 150, 25, native.systemFont, 16)
	buttonText:setTextColor( 0, 0, 0 )
	buttonText.text = "Pause"

	function gameOver()
		if(gameComplete == false) then
			if countDown == 0  then
				countDown = 0
				currentTime = countDown
				local stage = display.getCurrentStage()
				buttonText:removeSelf()
				buttonText = nil
				timeBut:removeSelf()
				timeBut = nil
				timerText:removeSelf()
				timerText = nil
				ice_pack:removeSelf()
				arm:removeSelf()
				composer.stars = 0
				composer.gotoScene("rate","fade","100")
			else
				timerText.text = "Time:"..countDown
				currentTime = countDown
				countDown = countDown - 1
			end
		end
	end

	countDownTimer = timer.performWithDelay( 1000, gameOver, 11 )

	local function timeButton( event )
	if event.phase == "began" then
		if resumeTime == true then
			timer.pause( countDownTimer )
			pauseTime = true
			resumeTime = false
			buttonText.text = "Resume"
		elseif pauseTime == true then
			timer.resume( countDownTimer )
			pauseTime = false
			resumeTime = true
			buttonText.text = "Pause"
		end
	end

end
	timeBut:addEventListener( "touch", timeButton )

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
	local arm = display.newImageRect( "arm.png", screenW, screenH )
	arm.anchorX = 0
	arm.anchorY = 1
	--  draw the arm at the very bottom of the screen
	arm.x, arm.y = display.screenOriginX, display.actualContentHeight + display.screenOriginY
	
	-- define a shape that's slightly shorter than image bounds (set draw mode to "hybrid" or "debug" to see)
	local armShape = { -halfW,-34, halfW,-34, halfW,34, -halfW,34 }
	physics.addBody( arm, "static", { friction=0.3, shape=armShape } )
	myCircle = display.newCircle( 304, 224, 100 )
	myCircle:setFillColor( 1)
	ice_pack = display.newImageRect( "ice_pack.png", 100, 100 )
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
					myCircle = nil
					myCircle = display.newCircle(304, 224,radius)
					-- Remove reference from table
					if (radius == 10) then
						display.remove(myCircle)
						myCircle = nil
						buttonText:removeSelf()
						buttonText = nil
						timeBut:removeSelf()
						timeBut = nil
						timerText:removeSelf()
						timerText = nil
						ice_pack:removeSelf()
						arm:removeSelf()
						if countDown <= 3 then
							composer.stars = 3
						elseif countDown <= 6 then
							composer.stars = 2 
						elseif countDown <= 9 then
							composer.stars = 1
						else
							composer.stars = 0
						end
						gameComplete = true
						composer.gotoScene("rate","fade",100)
						break
					end	
					-- Handle other collision aspects like increasing score, etc.
				end
			end
		return true
	end
	Runtime:addEventListener( "enterFrame", gameLoop )
	ice_pack:addEventListener ("touch",ice_pack)

	-- all display objects must be inserted into group
	sceneGroup:insert( background )
	sceneGroup:insert( arm)
	sceneGroup:insert(ice_pack)
	sceneGroup:insert(myCircle)
end

function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase
	
	if phase == "will" then
		-- Called when the scene is still off screen and is about to move on screen
	elseif phase == "did" then
		-- Called when the scene is now on screen
		-- 
		-- INSERT code here to make the scene come alive
		-- e.g. start timers, begin animation, play audio, etc.
		physics.start()
	end
end

function scene:hide( event )
	local sceneGroup = self.view
	
	local phase = event.phase
	
	if event.phase == "will" then
		-- Called when the scene is on screen and is about to move off screen
		--
		-- INSERT code here to pause the scene
		-- e.g. stop timers, stop animation, unload sounds, etc.)
		physics.stop()
	elseif phase == "did" then
		-- Called when the scene is now off screen
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