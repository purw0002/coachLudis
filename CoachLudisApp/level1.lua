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

	
	local sceneGroup = self.view

	local sheetDataBlueGuyRunning = {
		width= 614,
		height= 564,
		numFrames= 15,
		sheetContentWidth= 9210,
		sheetContentHeight= 564
	}

	local sheetDataGirlMoving = {
		width= 614,
		height= 564,
		numFrames= 15,
		sheetContentWidth= 9210,
		sheetContentHeight= 564
	}

	local sheetTapData = {
		width= 300,
		height= 300,
		numFrames= 2,
		sheetContentWidth= 600,
		sheetContentHeight= 300}
	
	local timerText = display.newText( "", 100, 100, native.systemFont, 16)
	timerText:translate(150, -30)
	timerText:setTextColor( 255, 255, 255 )

	


	local countDown = 10
	pauseTime = false;
	resumeTime = true;
	gameComplete = false;
	
	local function gameOver()
		timerText.text = "Time:"..countDown
		countDown = countDown - 1
		if (countDown == 0) then
			gameComplete = true;
			composer.chance = 1
			composer.start = true
			composer.gotoScene("level2","fade",400)
		end

	end

	countDownTimer = timer.performWithDelay( 1000, gameOver, 11 )

	


	-- Health bar background
	physics.start()

	local healthValue = 0

	healthRectangeWhite = display.newRect( 130, 20, 500, 20 ) 
	healthRectangeWhite:setFillColor(208, 208, 57, 1)
	healthRectangeWhite.x = 300
	

	-- health bar
	healthRectangeRed = display.newRect( 130, 20, 0, 20 ) 
	healthRectangeRed:setFillColor(1, 0, 0, 1)
	healthRectangeRed.x = 300

	-- We need physics started to add bodies, but we don't want the simulaton
	-- running until the scene is on the screen.
	physics.start()
	physics.pause()
	-- Called when the scene's view does not exist.
	-- 
	-- INSERT code here to initialize the scene
	-- e.g. add display objects to 'sceneGroup', add touch listeners, etc.
	
	-- create a grey rectangle as the backdrop
	-- the physical screen will likely be a different shape than our defined content area
	-- since we are going to position the background from it's top, left corner, draw the
	-- background at the real top, left corner.
	background = display.newImageRect( "warm-up level background.png", screenW, screenH )
	background.anchorX = 0 
	background.anchorY = 0
	background:setFillColor( .5 )

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
		
	else
		blueSheet = graphics.newImageSheet("runGirlsprite.png",sheetDataGirlMoving )
		player = display.newSprite(blueSheet, blueSequenceData)
		player.x, player.y = 60,160
		player.name="player"
		player:setSequence("run")
		player:scale(0.12,0.12)
		player:play()
		
	end



	tapSheet = graphics.newImageSheet("spritesheet.png",sheetTapData )
	tapSheetData = {
			{ name = "tap", start = 1, count= 2, time=800}
	}

	
	
	local tap_button1 = display.newSprite(tapSheet, tapSheetData)
	tap_button1.x, tap_button1.y = 50,270
	tap_button1:setSequence("tap")
	tap_button1:scale(0.3,0.3)
	tap_button1:play()

	


	local function tapbutton (event)
		print("within tap")
		if(event.phase == "began") then
			player.x = player.x + 10
			healthValue = healthValue + 10.8	
			healthRectangeRed.width =  healthValue
			healthRectangeRed.x = 300
			healthRectangeRed.x = healthRectangeRed.x - 250 + (healthValue/2)


			if (player.x == 560) then
				composer.start = true
				composer.chance = 2
				timer.cancel(countDownTimer)
				composer.gotoScene("level2","fade",400)
			end
		end
	end 

	tap_button1:addEventListener( "touch", tapbutton )


	
	

	

	

	-- make a crate (off-screen), position it, and rotate slightly
	-- create a grass object and add physics (with custom shape)
	
	
	-- define a shape that's slightly shorter than image bounds (set draw mode to "hybrid" or "debug" to see)
	-- all display objects must be inserted into group


	sceneGroup:insert( background )
	sceneGroup:insert(player)
	sceneGroup:insert(tap_button1)
	sceneGroup:insert(healthRectangeWhite)
	sceneGroup:insert(healthRectangeRed)
	sceneGroup:insert(timerText)
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

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
-----------------------------------------------------------------------------------------

return scene