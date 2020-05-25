
-----------------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()

-- include Corona's "physics" library

--------------------------------------------

-- forward declarations and other locals
local screenW, screenH, halfW = display.actualContentWidth, display.actualContentHeight, display.contentCenterX

local physics = require "physics"

-- Loading music tracks
levelTrack = audio.loadSound( "sound/levels/bensound-rumble.mp3")

collisionSound = audio.loadSound( "sound/injury/Concussive_Hit_Guitar_Boing.mp3")

winningSound = audio.loadSound( "sound/clapping/Tomlija_-_Small_Crowd_Cheering_and_Clapping_3_Biberche_Belgrade_Serbia.mp3")

lostTrack = audio.loadSound( "sound/lost/Male_Laugh.mp3")


local injuriesOccured  = {}

local nwb, nhb
local injuryBoard
local healthRectangeRed
--local healthRectangeGreen
local deadPlayers
local boom
local createObstacles
-- Sheet data for graphics
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

local sheetDataBlueGuyRunning = {
	width= 614,
	height= 564,
	numFrames= 15,
	sheetContentWidth= 9210,
	sheetContentHeight= 564
}

local sheetDataBlueGuyDying = {
	width= 614,
	height= 564,
	numFrames= 15,
	sheetContentWidth= 9210,
	sheetContentHeight= 564
}

local function goToRate()
	composer.stars = 0
	composer.chance = 1
	composer.deadPlayers = 0
	Runtime:removeEventListener("collision", onCollision)
	composer.removeScene('rate')
	composer.gotoScene('rate','fade', 500)
end

local background
local background1
local win

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

local loss

local ballSheet = graphics.newImageSheet( "soccer-sprite.png", sheetDataBall) 
local ballSequenceData = {
	{ name = "spin", start = 1, count= 11,time=1500}
}

local ball
local blueSheet
local blueSequenceData
local player
local deadBlueSheetGuy
local 	deadSequenceDataGuy = {
	{ name = "die", start = 1, count= 15,time=800, loopCount=1}
}

local blueSequenceData = {
	{ name = "run", start = 1, count= 20,time=800}
}

local playerDead

local deadGirlSheet

local deadSequenceData = {
	{ name = "die", start = 1, count= 30,time=800, loopCount=1}
}

local detector

	-- Touch handler for swiping up/down
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
				playerDead.y = playerDead.y-100
			end
       	elseif (event.y > event.yStart and swipeLength > 5) then
			if(player.y < 240) then
				player.y = player.y + 100
				ball.y = ball.y + 100
				boom.y = boom.y + 100
				playerDead.y = playerDead.y+100
			end
       	end
   	end
end

	-- This function is used to show the win screen
local function showWin()
	win.isVisible = true
	settingsButton.isVisible = false
	if(sound == "ON") then
		audio.stop()
		audio.play(winningSound)
	end
end

	-- Once the player wins the game we show an animation where the player scores the goal
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
	-- Just to make the boom visible on collision
local function boomVisible(event)
	boom.isVisible = false
end

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
local initialObstacle = 1500
local crate_id = 0

local orangeSheet
local orangeSequenceData
local localOrangeGirlSheet
local orangeOpponentSequenceData
local stones = display.newGroup()

local function createCrate()
	local obs = {'stone','player'}
	local idx = math.random(#obs)
	local selectedObs = obs[idx]
   	physics.setGravity(-2,0)
   	if(selectedObs == 'stone') then
   		local stone = display.newImageRect("images/objects/soccer/stone2.png", 20,20)
		stone.x, stone.y = initialObstacle,randomizeLane()+20
		stone.name =  "stone"
		physics.addBody( stone)
		stones:insert(stone)
	else
		if (composer.playerGender == "boy") then
    		local player2 = display.newSprite(orangeSheet, orangeSequenceData)
			player2.x, player2.y = initialObstacle,randomizeLane()
			player2.name="player2" .. tostring(crate_id)
			player2:setSequence("run")
			player2:scale(0.12,0.12)
			player2:play()
			nw, nh = player2.width*0.12*0.5, player2.height*0.12*0.5;
			physics.addBody(player2, {shape={-nw,-nh,nw,-nh,nw,nh,-nw,nh} });
			player2s:insert(player2)
		else
    		local player2 = display.newSprite(localOrangeGirlSheet, orangeOpponentSequenceData)
			player2.x, player2.y = initialObstacle,randomizeLane()
			player2.name="player2" .. tostring(crate_id)
			player2:setSequence("run")
			player2:scale(0.12,0.12)
			player2:play()
			nw, nh = player2.width*0.12*0.5, player2.height*0.12*0.5;
			physics.addBody(player2, {shape={-nw,-nh,nw,-nh,nw,nh,-nw,nh} });
			player2s:insert(player2)
		end
	end
end

local function boardDissapear(event)
	event.target:removeSelf()
	local function showGameOver(loss)
		player:pause()
		if(sound == "ON") then
			audio.stop()
			audio.play(lostTrack)
		end
		loss.isVisible = true
		settingsButton.isVisible = false
		healthRectangeGreen.isVisible = false
		healthRectangeRed.isVisible = false
	end

	if(healthValue <= 20 and composer.chance >= 1) then
		local idx = math.random(#injuriesOccured)
		local selectedLevel = injuriesOccured[idx]

		composer.chance = composer.chance - 1
		print("Composer dead")
		print(composer.chance)
		-- By some method such as a "pause" button, show the overlay
		print("go to next scene")
		composer.deadPlayers = deadPlayers
		while stones.numChildren > 0 do
        	local child = stones[1]
        	if child then 
        		child:removeSelf() 
        	end
    	end
		while player2s.numChildren > 0 do
        	local child = player2s[1]
        	if child then 
        		child:removeSelf() 
        	end
    	end
    	timer.cancel(createObstacles)
		composer.removeScene( selectedLevel)
		composer.gotoScene( selectedLevel, "fade", 100 )
	elseif(injuryBoard.param1 == nil) then
		print("starting on collide start & resume timer and ophysics")
		timer.resume(event.target.params)
		if(deadPlayers == 13) then
			Runtime:addEventListener("enterFrame", moveBackground)
		end
		physics.start()

	else
		timer.performWithDelay( 1000, showGameOver(injuryBoard.param1), 1)
	end
end

local function showInjuryBoard()

	local totalWeight = 0
	for _, weight in pairs(weights) do
   		totalWeight = totalWeight + weight
	end

	rand = math.random() * totalWeight
	choice = nil

	for i, weight in pairs(weights) do
   		if rand < weight then
       		choice = choices[i]
       		break
   		else
       		rand = rand - weight
   		end
	end
	injuryBoard = display.newImageRect("images/Image board main/" .. choice["Image_name"], 250,200)
	injuryBoard.x = display.contentCenterX
	injuryBoard.y = display.contentCenterY
	injuryBoard.params = createObstacles
	if(choice["Image_name"] == 'leg fracture.png' or choice["Image_name"] == 'soft-tissue injury(leg).png' or choice["Image_name"] == 'shoulder dislocation (text).png') then
		injuriesOccured[#injuriesOccured+1] = 'level3'
	elseif(choice["Image_name"] == 'intracranial injury.png') then
		injuriesOccured[#injuriesOccured+1] = 'precautionheadstrike'
	else
		injuriesOccured[#injuriesOccured+1] = 'precautionOpenWound'
	end

	if( healthValue - choice["Severity"] > 0) then
		healthValue = healthValue - choice["Severity"]
	else
		healthValue = 0
	end

	if (healthValue<= 0 and composer.chance == 0) then
		injuryBoard.param1 = loss
		print("physics pause when u die")

		physics.pause()
		player:pause()
		healthRectangeGreen.width =  0
		if (composer.playerGender == "boy") then
			player.isVisible = false
			playerDead.isVisible = true
			playerDead:play()
		else
			player.isVisible = false
			playerDead.isVisible = true
			playerDead:play()
		end
		Runtime:removeEventListener("touch",globalTouchHandler)
		Runtime:removeEventListener("collision", onCollision)
	else
		healthRectangeGreen.width =  healthValue*2
		healthRectangeGreen.x = healthRectangeGreen.x - choice["Severity"]
	end
	injuryBoard:addEventListener("tap", boardDissapear)
end


local function onCollision(event)
	if(event.phase == "began") then
		print("Collided with ")
		print(event.object1.name)
		print(event.object2.name)
		print(deadPlayers)

		if(event.object1.name == "ball" or event.object2.name == "ball") then
			print(event.object1.name)
			print(event.object2.name)
			print(healthValue)
			if(sound == "ON") then
				audio.play(collisionSound)
			end
			event.object2:removeSelf()
			boom.isVisible = true
			timer.performWithDelay( 800, boomVisible, 1 )
			deadPlayers = deadPlayers + 1
			print("on collision pausing timer and physics")
			physics.pause()
			timer.pause(createObstacles)
			showInjuryBoard()
				
		elseif(event.object1.name == "detector" or event.object2.name == "detector") then
			event.object2:removeSelf()
			deadPlayers = deadPlayers + 1
			if(deadPlayers == 13) then
				Runtime:addEventListener("enterFrame", moveBackground)
			end
		end
	end
end

local settingBackground
local settingWindow
local playButton
local replayButton

local function startPlaying(event )


	local phase = event.phase
    if (phase == "began") then

    elseif (phase == "moved") then

    elseif (phase == "ended" or phase == "cancelled") then
		settingBackground.isVisible = false
		settingWindow.isVisible = false
		playButton.isVisible = false
		replayButton.isVisible = false
		physics.start()
		timer.resume(createObstacles)
   	end
end

local function selectSetting(event)

	local phase = event.phase
    if (phase == "began") then

    elseif (phase == "moved") then

    elseif (phase == "ended" or phase == "cancelled") then
       	settingBackground.isVisible = true
		settingWindow.isVisible = true
		playButton.isVisible = true
		replayButton.isVisible = true
		physics.pause()
		timer.pause(createObstacles)
   	end

end
	-- This would occur when you click the replay button
local function replayButtonEvent()
	composer.start = true
	composer.sport = 'soccer'
	composer.removeScene( "InjurySheet")
	composer.gotoScene( "InjurySheet", "fade", 500 )
end



function scene:create( event )
	-- Adding physics to the game engine
	healthValue = 100
	local sceneGroup = self.view
	-- We need physics started to add bodies, but we don't want the simulaton
	-- running until the scene is on the screen.
	-- Called when the scene's view does not exist.
	-- INSERT code here to initialize the scene
	-- e.g. add display objects to 'sceneGroup', add touch listeners, etc.

	-- Health bar background
	physics.start()
	healthRectangeRed = display.newRect( 130, 20, healthValue*2, 20 ) 
	healthRectangeRed:setFillColor(208, 208, 57, 1)

	-- health bar
	healthRectangeGreen = display.newRect( 130, 20, healthValue*2, 20 ) 
	healthRectangeGreen:setFillColor(1, 0, 0, 1)

	-- Keeps track of players that crossed the scene
	deadPlayers = 0
	-- Displayed  on collision
	boom = display.newImageRect("boom.png", 40,40)
	boom.x, boom.y = 80,175
	boom.name =  "boom"
	boom.isVisible = false


	-- On fail stars allocated will be 0
	-- Loading In game assets 
	background = display.newImageRect( "ground.jpg", screenW, screenH )
	background.anchorX = 0
	background.anchorY = 0

	background1 = display.newImageRect( "ground1.jpg", screenW/3, screenH )
	
	background1.x =  (screenW/2)*3
	background1.y = screenH/2

	win = display.newImageRect( "celebration.png", screenW, screenH )
	
	-- Once you win the game, the stars are displayed based  on your health bar
	win.anchorX = 0
	win.anchorY = 0
	win.isVisible = false
	win.touch = showRatings
	win:addEventListener( "touch", win )

	loss = display.newImageRect( "gameOver.png", screenW, screenH )
	
	loss.anchorX = 0
	loss.anchorY = 0
	loss.isVisible = false
	loss:addEventListener('touch', goToRate)

	-- Animating sprites
	ball = display.newSprite(ballSheet, ballSequenceData)
	ball.x, ball.y = 90,180
	ball.name =  "ball"
	ball:setSequence("spin")
	ball:scale(0.02,0.02)
	ball:play()
	nwb, nhb = ball.width*0.02*0.5, ball.height*0.02*0.5;
	physics.addBody(ball, "static", {shape={-nwb,-nhb,nwb,-nhb,nwb,nhb,-nwb,nhb} });

	-- Animation is loaded based on gender
	if (composer.playerGender == "boy") then
		blueSheet = graphics.newImageSheet("runBlueGuy.png",sheetDataBlueGuyRunning )
		blueSequenceData = {
			{ name = "run", start = 1, count= 15,time=800},
		}
		player = display.newSprite(blueSheet, blueSequenceData)
		player.x, player.y = 80,160
		player.name="player"
		player:setSequence("run")
		player:scale(0.12,0.12)
		player:play()
		deadBlueSheetGuy = graphics.newImageSheet("deadBlueGuy.png",sheetDataBlueGuyDying )
		playerDead = display.newSprite(deadBlueSheetGuy, deadSequenceDataGuy)
		playerDead.x, playerDead.y = 60,160
		playerDead.name="playerDead"
		playerDead:setSequence("die")
		playerDead:scale(0.12,0.12)
		playerDead.isVisible = false
	else
		blueSheet = graphics.newImageSheet("runGirlsprite.png",sheetDataGirlMoving )
		player = display.newSprite(blueSheet, blueSequenceData)
		player.x, player.y = 60,160
		player.name="player"
		player:setSequence("run")
		player:scale(0.12,0.12)
		player:play()
		deadGirlSheet = graphics.newImageSheet("deadGirl-sprite.png",sheetDataGirlDying )
		playerDead = display.newSprite(deadGirlSheet, deadSequenceData)
		playerDead.x, playerDead.y = 60,160
		playerDead.name="playerDead"
		playerDead:setSequence("die")
		playerDead:scale(0.12,0.12)
		playerDead.isVisible = false
	end
	
	-- Exists in the end of the screen, Used for detecting dead players
	detector = display.newImageRect("ball.png", 500,500)
	detector.x, detector.y = -500,180
	detector.name =  "detector"
	physics.addBody( detector , "static")



	-- create a grey rectangle as the backdrop
	-- the physical screen will likely be a different shape than our defined content area
	-- since we are going to position the background from it's top, left corner, draw the
	-- background at the real top, left corner.



	-- This would make the players/stones pop up randomply in the lanes
	orangeSheet = graphics.newImageSheet("orangeSpritesheet.png",sheetData )
	orangeSequenceData = {
		{ name = "run", start = 1, count= 15, time=800}
	}

	localOrangeGirlSheet = graphics.newImageSheet("girlRunnerOpponentSprite.png",sheetOponentGirlRunning )
	orangeOpponentSequenceData = {
		{ name = "run", start = 1, count= 20, time=800}
	}

	-- To create obstacles


	-- TODO- 1

	

	--On touch of the injury we make the injury pop up dissapear

	-- On collision we show the injury board.
	-- The events that occur during collision
	-- On click of the settings button these buttons r used
	settingBackground = display.newImageRect( "images/background/app background/appBack.png", screenW, screenH )
	settingBackground.anchorX = 0 
	settingBackground.anchorY = 0
	settingBackground:setFillColor( 0.8 )
	settingBackground.isVisible = false


	settingWindow = display.newImageRect( "images/background/app background/paused window.png", 150, 200 )
	settingWindow.x = display.contentCenterX + 45
	settingWindow.y = display.contentCenterY
	settingWindow.isVisible = false

	playButton = display.newImageRect( "images/background/app background/play button.png", 50, 50 )
	playButton.x =  display.contentCenterX + 25
	playButton.y = display.contentCenterY - 10
	playButton.isVisible = false


	replayButton = display.newImageRect( "images/background/app background/restart button.png", 50, 50 )
	-- On click of resume in settings

	-- TO DO 2
	playButton:addEventListener( "touch", startPlaying )


	-- On click of settings button
	
	settingsButton = display.newImageRect( "images/commons/setting button.png", 50, 50 )
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
	sceneGroup:insert(stones)
	sceneGroup:insert(player)
	sceneGroup:insert(playerDead)
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


	-- TO DO 3

	Runtime:addEventListener("touch",globalTouchHandler)
	Runtime:addEventListener("collision", onCollision)
	physics.pause()

end


function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase
	if phase == "will" then
		-- Called when the scene is still off screen and is about to move on screen
	elseif phase == "did" then
		-- Called when the scene is now on screen
		-- 
		-- Sound is played based on the global sound indicator
		if(sound == "ON") then

			audio.stop()
			audio.play(levelTrack, { channel=2, loops=-1})
		else
			audio.stop()
		end

		if(composer.start == true) then
			local title
			if(composer.suceeded == true) then
				title = display.newText("Warmup level Successful - extra prevention level!", display.contentCenterX, 250 , native.systemFontBold, 20) 
			else
				title = display.newText("Warmup level Failed - no extra prevention level!", display.contentCenterX, 250 , native.systemFontBold, 20) 
			end

			local function hideText()
				title.isVisible =  false
			end

			timer.performWithDelay( 3000, hideText, 13)
			composer.start =  false
			physics.start()
			createObstacles = timer.performWithDelay( 1500, createCrate, 13)
		else
			print("physics starting again along eith timer")

			physics.start()
			physics.setGravity(-2,0)

			physics.addBody(ball, "static", {shape={-nw,-nh,nw,-nh,nw,nh,-nw,nh} });
			physics.addBody( detector , "static")
			healthValue = healthValue +composer.healthIncrease
			healthRectangeGreen.width =  healthValue*2
			healthRectangeGreen.x = healthRectangeGreen.x + composer.healthIncrease
			createObstacles = timer.performWithDelay( 1500, createCrate, 13-composer.deadPlayers)
			timer.resume(createObstacles)
		end

		
	end
end

function scene:hide( event )
	local sceneGroup = self.view
	
	local phase = event.phase
	if event.phase == "will" then
		-- Called when the scene is on screen and is about to move off screen
		--
		physics.stop()
		-- INSERT code here to pause the scene
		-- e.g. stop timers, stop animation, unload sounds, etc.)
	elseif phase == "did" then
		-- Called when the scene is now off screen
		--physics.pause()
		--timer.pause(createObstacles)
	end	
	
end

function scene:destroy( event )

	-- Called prior to the removal of scene's "view" (sceneGroup)
	-- 
	-- INSERT code here to cleanup the scene
	-- e.g. remove display objects, remove touch listeners, save state, etc.
	local sceneGroup = self.view
	Runtime:removeEventListener("touch",globalTouchHandler)
	Runtime:removeEventListener("collision", onCollision)

	--package.loaded[physics] = nil
	--physics = nil
end

-- Custom function for resuming the game (from pause state)
---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
-----------------------------------------------------------------------------------------

return scene