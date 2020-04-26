-----------------------------------------------------------------------------------------
--
-- level1.lua
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()

-- include Corona's "physics" library

--------------------------------------------

-- forward declarations and other locals
local screenW, screenH, halfW = display.actualContentWidth, display.actualContentHeight, display.contentCenterX

local physics = require "physics"
levelTrack = audio.loadSound( "sound/levels/bensound-rumble.mp3")

collisionSound = audio.loadSound( "sound/injury/Concussive_Hit_Guitar_Boing.mp3")

winningSound = audio.loadSound( "sound/clapping/Tomlija_-_Small_Crowd_Cheering_and_Clapping_3_Biberche_Belgrade_Serbia.mp3")

lostTrack = audio.loadSound( "sound/lost/Male_Laugh.mp3")

function scene:create( event )
	physics = require "physics"
	healthValue = 100
	local sceneGroup = self.view
	local injuryBoard
	-- We need physics started to add bodies, but we don't want the simulaton
	-- running until the scene is on the screen.
	physics.start()
	physics.pause()
	-- Called when the scene's view does not exist.
	-- INSERT code here to initialize the scene
	-- e.g. add display objects to 'sceneGroup', add touch listeners, etc.
	
	local healthRectangeRed = display.newRect( 130, 20, healthValue*2, 20 ) 
	healthRectangeRed:setFillColor(1, 0, 0, 1)

	local healthRectangeGreen = display.newRect( 130, 20, healthValue*2, 20 ) 
	healthRectangeGreen:setFillColor(0, 1, 0, 1)

	local deadPlayers = 0
	local boom = display.newImageRect("boom.png", 40,40)
	boom.x, boom.y = 80,175
	boom.name =  "boom"
	boom.isVisible = false
	local sheetData = {
		width= 614,
		height= 564,
		numFrames= 15,
		sheetContentWidth= 9210,
		sheetContentHeight= 564
	}

	local sheetData1 = {
		width= 614,
		height= 564,
		numFrames= 75,
		sheetContentWidth= 46050,
		sheetContentHeight= 564
	}

	local sheetDataBall = {
		width= 714,
		height= 1000,
		numFrames= 11,
		sheetContentWidt= 7854,
		sheetContentHeight= 1000
	}

	local sheetDataGirlMoving  = {
		width= 416,
		height= 454,
		numFrames= 20,
		sheetContentWidth= 8320,
		sheetContentHeight= 454
	}

	local sheetDataGirlDying = {
		width= 601,
		height= 502,
		numFrames= 30,
		sheetContentWidth= 18030,
		sheetContentHeight= 502
	}

	local sheetOponentGirlRunning = {
		width= 416,
		height= 454,
		numFrames= 20,
		sheetContentWidth= 8320,
		sheetContentHeight= 454
	}

	local function goToRate()
		composer.stars = 0
		composer.gotoScene('rate','fade', 500)
	end

	local background = display.newImageRect( "ground.jpg", screenW, screenH )
	background.anchorX = 0
	background.anchorY = 0

	local background1 = display.newImageRect( "ground1.jpg", screenW/3, screenH )
	
	background1.x =  (screenW/2)*3
	background1.y = screenH/2

	local win = display.newImageRect( "celebration.png", screenW, screenH )
	
	local function showRatings()
		if(healthValue >= 80) then
			composer.stars = 3
		elseif(healthValue >=60) then
			composer.stars = 2
		else
			composer.stars = 1
		end
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
	loss:addEventListener('touch', goToRate)

	local ballSheet = graphics.newImageSheet( "soccer-sprite.png", sheetDataBall) 
	local ballSequenceData = {
		{ name = "spin", start = 1, count= 11,time=1500}
	}
	local ball = display.newSprite(ballSheet, ballSequenceData)
	ball.x, ball.y = 90,180
	ball.name =  "ball"
	ball:setSequence("spin")
	ball:scale(0.02,0.02)
	ball:play()
	local nw, nh = ball.width*0.02*0.5, ball.height*0.02*0.5;
	physics.addBody(ball, "static", {shape={-nw,-nh,nw,-nh,nw,nh,-nw,nh} });

	local blueSheet
	local blueSequenceData
	local player
	if (composer.playerGender == "boy") then
		blueSheet = graphics.newImageSheet("blueSpriteAllActions.png",sheetData1 )
		blueSequenceData = {
			{ name = "run", start = 46, count= 15,time=800},
			{name = "dead", start = 1, count= 15,time=800, loopCount=1}
		}
		player = display.newSprite(blueSheet, blueSequenceData)
		player.x, player.y = 80,160
		player.name="player"
		player:setSequence("run")
		player:scale(0.12,0.12)
		player:play()
	else
		blueSheet = graphics.newImageSheet("runGirlsprite.png",sheetDataGirlMoving )
		blueSequenceData = {
			{ name = "run", start = 1, count= 20,time=800}
		}
		player = display.newSprite(blueSheet, blueSequenceData)
		player.x, player.y = 60,160
		player.name="player"
		player:setSequence("run")
		player:scale(0.12,0.12)
		player:play()
		deadGirlSheet = graphics.newImageSheet("deadGirl-sprite.png",sheetDataGirlDying )
		deadSequenceData = {
			{ name = "die", start = 1, count= 30,time=800, loopCount=1}
		}
		playerDead = display.newSprite(deadGirlSheet, deadSequenceData)
		playerDead.x, playerDead.y = 60,160
		playerDead.name="playerDead"
		playerDead:setSequence("die")
		playerDead:scale(0.12,0.12)
		playerDead.isVisible = false
		
	end
	

	local detector = display.newImageRect("ball.png", 500,500)
	detector.x, detector.y = -500,180
	detector.name =  "detector"
	physics.addBody( detector , "static")



	local function globalTouchHandler(event)

    	local swipeLength = math.abs(event.y - event.yStart) 

    	local t = event.target
    	local phase = event.phase

    	if (phase == "began") then

    	elseif (phase == "moved") then

    	elseif (phase == "ended" or phase == "cancelled") then
        	if (event.y < event.yStart and swipeLength > 5) then
				if(player.y > 120) then
					player.y = player.y - 100
					ball.y = ball.y - 100
					boom.y = boom.y - 100
					if (composer.playerGender == "girl") then
						playerDead.y = playerDead.y-100
					end
				end
        	elseif (event.y > event.yStart and swipeLength > 5) then
				if(player.y < 240) then
					player.y = player.y + 100
					ball.y = ball.y + 100
					boom.y = boom.y + 100
					if (composer.playerGender == "girl") then
						playerDead.y = playerDead.y+100
					end
				end
        	end
    	end
	end

	local function showWin()
		win.isVisible = true
		if(sound == "ON") then
			audio.stop()
			audio.play(winningSound)
		end
	end

	local function moveBackground()
		if(background1.x < 360) then
			Runtime:removeEventListener( "enterFrame", moveBackground );
			transition.to(ball,{x=450,y=screenH/2,time=2000, onComplete=showWin})
			Runtime:removeEventListener("touch",globalTouchHandler)
			Runtime:removeEventListener("collision", onCollision)
			ball:pause()
			player:pause()
		else
			background1.x = background1.x-3
		end
	end

	local function boomVisible(event)
		boom.isVisible = false
	end

	-- create a grey rectangle as the backdrop
	-- the physical screen will likely be a different shape than our defined content area
	-- since we are going to position the background from it's top, left corner, draw the
	-- background at the real top, left corner.


	local player2s = display.newGroup()


	local function randomizeLane()

		local lanes = {1, 2, 3}
		local idx = math.random(#lanes)
		local selectedLane = lanes[idx]
		if(selectedLane == 1) then
			return 60
		elseif (selectedLane == 2) then
			return 160
		elseif (selectedLane == 3) then
			return 260
		end
	end
	initialObstacle = 1500
	crate_id = 0
	local orangeSheet = graphics.newImageSheet("orangeSpritesheet.png",sheetData )
	local orangeSequenceData = {
		{ name = "run", start = 1, count= 15, time=800}
	}

	local localOrangeGirlSheet = graphics.newImageSheet("girlRunnerOpponentSprite.png",sheetOponentGirlRunning )
	local orangeOpponentSequenceData = {
		{ name = "run", start = 1, count= 20, time=800}
	}


	local function createCrate()
		local obs = {'stone','player'}
		local idx = math.random(#obs)
		local selectedObs = obs[idx]
    	physics.setGravity(-2,0)
    	if(selectedObs == 'stone') then
    		local stone = display.newImageRect("images/objects/soccer/stone2.png", 30,30)
			stone.x, stone.y = initialObstacle,randomizeLane()
			stone.name =  "stone"
			physics.addBody( stone)
		else
			if (composer.playerGender == "boy") then
	    		local player2 = display.newSprite(orangeSheet, orangeSequenceData)
				player2.x, player2.y = initialObstacle,randomizeLane()
				player2.name="player2" .. tostring(crate_id)
				player2:setSequence("run")
				player2:scale(0.12,0.12)
				player2:play()
				local nw, nh = player2.width*0.12*0.5, player2.height*0.12*0.5;
				physics.addBody(player2, {shape={-nw,-nh,nw,-nh,nw,nh,-nw,nh} });
				player2s:insert(player2)
			else
	    		local player2 = display.newSprite(localOrangeGirlSheet, orangeOpponentSequenceData)
				player2.x, player2.y = initialObstacle,randomizeLane()
				player2.name="player2" .. tostring(crate_id)
				player2:setSequence("run")
				player2:scale(0.12,0.12)
				player2:play()
				local nw, nh = player2.width*0.12*0.5, player2.height*0.12*0.5;
				physics.addBody(player2, {shape={-nw,-nh,nw,-nh,nw,nh,-nw,nh} });
				player2s:insert(player2)
			end
		end
    end

	local createObstacles = timer.performWithDelay( 1500, createCrate, 13)


	local function boardDissapear(event)
		event.target:removeSelf()

		local function showGameOver(loss)
			player:pause()
			if(sound == "ON") then
				audio.stop()
				audio.play(lostTrack)
			end
			loss.isVisible = true
			healthRectangeGreen.isVisible = false
			healthRectangeRed.isVisible = false
		end

		if injuryBoard.param1 == nil then
			timer.resume(event.target.params)
			physics.start()
		else
			timer.performWithDelay( 1000, showGameOver(injuryBoard.param1), 1)
		end
		
	end

	local function showInjuryBoard()
		injuryBoard = display.newImageRect("images/injury window/fracture.png", 250,200)
		injuryBoard.x = display.contentCenterX
		injuryBoard.y = display.contentCenterY
		injuryBoard.params = createObstacles
		if (healthValue<= 0) then
			injuryBoard.param1 = loss
		end
		injuryBoard:addEventListener("tap", boardDissapear)
	end

	local function onCollision(event)
		if(event.phase == "began") then

			if(event.object1.name == "ball" or event.object2.name == "ball") then
				print(event.object1.name)
				print(event.object2.name)
				if(sound == "ON") then
					audio.play(collisionSound)
				end
				event.object2:removeSelf()
				boom.isVisible = true
				timer.performWithDelay( 800, boomVisible, 1 )
				deadPlayers = deadPlayers + 1
				physics.pause()
				timer.pause(createObstacles)
				healthValue = healthValue - 30
				showInjuryBoard()
				if (healthValue <= 0) then
					physics.pause()
					player:pause()
					healthRectangeGreen.width =  0
					if (composer.playerGender == "boy") then
						player:setSequence("dead")
						player:play()
					else
						player.isVisible = false
						playerDead.isVisible = true
						playerDead:play()
					end
					Runtime:removeEventListener("touch",globalTouchHandler)
					Runtime:removeEventListener("collision", onCollision)

				else
					healthRectangeGreen.width =  healthValue*2
					healthRectangeGreen.x = healthRectangeGreen.x - 30
					healthRectangeGreen:setFillColor(0, 1, 0, 1)
				end
				
			elseif(event.object1.name == "detector" or event.object2.name == "detector") then
				event.object2:removeSelf()
				deadPlayers = deadPlayers + 1
				if(deadPlayers == 13) then
					Runtime:addEventListener("enterFrame", moveBackground)
				end
			end
		end
	end


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
		physics.start()
		timer.resume(createObstacles)
	end

	playButton:addEventListener( "touch", startPlaying )



	local function selectSetting()
		settingBackground.isVisible = true
		settingWindow.isVisible = true
		playButton.isVisible = true
		replayButton.isVisible = true
		physics.pause()
		timer.pause(createObstacles)
	end

	local function replayButtonEvent()
		composer.removeScene( composer.levelPlaying)
		composer.gotoScene( composer.levelPlaying, "fade", 500 )

	end

	
	local settingsButton = display.newImageRect( "images/commons/setting button.png", 50, 50 )
	settingsButton.x =  display.contentCenterX + 300
	settingsButton.y = display.contentCenterY - 140
	settingsButton:addEventListener( "touch", selectSetting )

	replayButton.x =  display.contentCenterX + 65
	replayButton.y = display.contentCenterY - 10
	replayButton.isVisible = false
	replayButton:addEventListener( "touch", replayButtonEvent )


	-- make a crate (off-screen), position it, and rotate slightly
	-- create a grass object and add physics (with custom shape)

	sceneGroup:insert( background )
	sceneGroup:insert( background1 )
	sceneGroup:insert(ball)
	sceneGroup:insert(player2s)
	sceneGroup:insert(player)
	if (composer.playerGender == "girl") then
		sceneGroup:insert(playerDead)
	end
	sceneGroup:insert(boom)
	sceneGroup:insert(healthRectangeRed)
	sceneGroup:insert(healthRectangeGreen)
	sceneGroup:insert(loss)
	sceneGroup:insert(win)
	sceneGroup:insert(settingBackground)
	sceneGroup:insert(settingsButton)
	sceneGroup:insert(settingWindow)
	sceneGroup:insert(playButton)
	sceneGroup:insert(replayButton)

	Runtime:addEventListener("touch",globalTouchHandler)
	Runtime:addEventListener("collision", onCollision)

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
			audio.play(levelTrack, { channel=2, loops=-1})
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

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
-----------------------------------------------------------------------------------------

return scene