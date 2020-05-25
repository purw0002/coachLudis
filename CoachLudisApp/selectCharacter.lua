-----------------------------------------------------------------------------------------
--
-- menu.lua
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()

-- include Corona's "widget" library
local widget = require "widget"

--------------------------------------------
local screenW, screenH, halfW = display.actualContentWidth, display.actualContentHeight, display.contentCenterX



function scene:create( event )
	local sceneGroup = self.view

	-- Called when the scene's view does not exist.
	-- 
	-- INSERT code here to initialize the scene
	-- e.g. add display objects to 'sceneGroup', add touch listeners, etc.


	musicButtonONSC = display.newImageRect( "images/background/app background/music button.png", 50, 50 )
	musicButtonOFFSC = display.newImageRect( "images/background/app background/no music icon.png", 50, 50 )

	local function stopAudio(event)
		if ( event.phase == "began" ) then
			audio.stop()
			sound = "OFF"
			musicButtonONSC.isVisible = false
			musicButtonOFFSC.isVisible = true
		end
	end

	local function startAudio(event)
		if ( event.phase == "began" ) then
			audio.play(musicTrack)
			sound = "ON"
			musicButtonONSC.isVisible = true
			musicButtonOFFSC.isVisible = false
		end
	end


	musicButtonONSC.x = 545
	musicButtonONSC.y = 20
	musicButtonONSC:addEventListener( "touch", stopAudio )

	musicButtonOFFSC.x = 545
	musicButtonOFFSC.y = 20
	musicButtonOFFSC:addEventListener( "touch", startAudio )

	local background = display.newImageRect( "images/background/app background/character select background.png", screenW, screenH )
	background.anchorX = 0
	background.anchorY = 0



	local function selectBoy()
		composer.playerGender = 'boy'
		composer.prevScreen = "selectCharacter"
		composer.gotoScene( "select", "fade", 500 )
	end

	local function selectGirl()
		composer.playerGender = 'girl'
		composer.gotoScene( "select", "fade", 500 )
	end
	local window = display.newImageRect( "images/character select/characterWindow.png", 150, 230 )
	window.x =  display.contentCenterX - 70
	window.y = display.contentCenterY +15
	window:addEventListener( "touch", selectBoy )

	local window1 = display.newImageRect( "images/character select/characterWindow.png", 150, 230 )
	window1.x =  display.contentCenterX + 170
	window1.y = display.contentCenterY +15
	window1:addEventListener( "touch", selectGirl )

	local sheetData1 = {
		width= 614,
		height= 564,
		numFrames= 15,
		sheetContentWidth= 9210,
		sheetContentHeight= 564
	}

	local sheetData2 = {
		width= 416,
		height= 454,
		numFrames= 15,
		sheetContentWidth= 6654,
		sheetContentHeight= 454
	}


	local blueSheet = graphics.newImageSheet("idleBlueGuy.png",sheetData1 )
	local blueSequenceData = {
		{ name = "idle", start = 1, count= 15,time=800}
	}
	local player = display.newSprite(blueSheet, blueSequenceData)
	player.x, player.y = 220,180
	player.name="player"
	player:setSequence("idle")
	player:scale(0.3,0.3)
	player:play()

	local girlSheet = graphics.newImageSheet("player-girl-sprite.png",sheetData2 )
	local girlSequenceData = {
		{ name = "idle", start = 1, count= 15,time=800}
	}
	local player1 = display.newSprite(girlSheet, girlSequenceData)
	player1.x, player1.y = 405,180
	player1.name="player1"
	player1:setSequence("idle")
	player1:scale(0.3,0.3)
	player1:play()

	sceneGroup:insert( background )
	sceneGroup:insert( window )
	sceneGroup:insert( window1 )
	sceneGroup:insert( player )
	sceneGroup:insert( player1 )
	sceneGroup:insert( musicButtonONSC )
	sceneGroup:insert( musicButtonOFFSC )



end

function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase
	
	if phase == "will" then
		-- Called when the scene is still off screen and is about to move on screen
	elseif phase == "did" then
		-- Called when the scene is now on screen
		-- 

		if (sound == "ON") then
			if audio.isChannelPlaying( 1 ) then
			else
				audio.stop()
				audio.play(musicTrack, {  channel=1, loops=-1 })
			end
			musicButtonONSC.isVisible = true
			musicButtonOFFSC.isVisible = false
		else
			audio.stop()
			musicButtonONSC.isVisible = false
			musicButtonOFFSC.isVisible = true
		end

		-- INSERT code here to make the scene come alive
		-- e.g. start timers, begin animation, play audio, etc.
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
	elseif phase == "did" then
		-- Called when the scene is now off screen
	end	
end

function scene:destroy( event )
	local sceneGroup = self.view
	
	-- Called prior to the removal of scene's "view" (sceneGroup)
	-- 
	-- INSERT code here to cleanup the scene
	-- e.g. remove display objects, remove touch listeners, save state, etc.
	
	if playBtn then
		playBtn:removeSelf()	-- widgets must be manually removed
		playBtn = nil
	end
end

---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

-----------------------------------------------------------------------------------------

return scene