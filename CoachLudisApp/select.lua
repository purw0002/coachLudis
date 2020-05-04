-----------------------------------------------------------------------------------------
--
-- level1.lua
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()
-- include Corona's "physics" library

--------------------------------------------


local function onGame4BtnRelease()
	
	-- go to level1.lua scene
	composer.numOfLevels = 5
	composer.unlocked = 2
	composer.game = 'soccer'
	composer.levelSelectLink = 'levelSelect'
	composer.prevScreen = "select"
	composer.gotoScene( "levelSelect", "fade", 500 )
	
	return true	-- indicates successful touch
end


-- forward declarations and other locals
local screenW, screenH, halfW = display.actualContentWidth, display.actualContentHeight, display.contentCenterX



function scene:create( event )
	-- Called when the scene's view does not exist.
	-- 
	-- INSERT code here to initialize the scene
	-- e.g. add display objects to 'sceneGroup', add touch listeners, etc.
	musicButtonON = display.newImageRect( "images/background/app background/music button.png", 50, 50 )
	musicButtonOFF = display.newImageRect( "images/background/app background/no music icon.png", 50, 50 )

	local function stopAudio(event)
		if ( event.phase == "began" ) then
			audio.stop()
			sound = "OFF"
			musicButtonON.isVisible = false
			musicButtonOFF.isVisible = true
		end
	end

	local function startAudio(event)
		if ( event.phase == "began" ) then
			audio.play(musicTrack)
			sound = "ON"
			musicButtonON.isVisible = true
			musicButtonOFF.isVisible = false
		end
	end

	musicButtonON.x = 545
	musicButtonON.y = 20
	musicButtonON:addEventListener( "touch", stopAudio )


	musicButtonOFF.x = 545
	musicButtonOFF.y = 20
	musicButtonOFF:addEventListener( "touch", startAudio )

	-- Go to chaaracter select screen
	local function goBackToPrev(event)
		composer.prevScreen = event.target.prev
		if (prevScreen ~= "None") then
			composer.gotoScene( event.target.curScreen, "fade", 500 )
		end
	end
	local backButton = display.newImageRect( "images/commons/back button.png", 60, 60 )
	backButton.x = 20
	backButton.y = 20
	backButton.prev = "None"
	backButton.curScreen = "selectCharacter"
	backButton:addEventListener( "touch", goBackToPrev )


	local sceneGroup = self.view

	-- We need physics started to add bodies, but we don't want the simulaton
	-- running until the scene is on the screen.

	-- create a grey rectangle as the backdrop
	-- the physical screen will likely be a different shape than our defined content area
	-- since we are going to position the background from it's top, left corner, draw the
	-- background at the real top, left corner.


	local background = display.newImageRect( "images/background/app background/appBack.png", screenW, screenH )
	background.anchorX = 0
	background.anchorY = 0
	local game1 = display.newImageRect( "images/logo/locked football.png", 100, 100 )
	game1.x = game1.contentHeight + 10
	game1.y = game1.contentHeight
	game1:addEventListener( "touch", game1 )

	local game2 = display.newImageRect( "images/logo/locked basketball.png", 100, 100 )
	game2.x = game2.contentHeight +  180 
	game2.y = game2.contentHeight

	local game3 = display.newImageRect( "images/logo/locked netball.png", 100, 100 )
	game3.x = game3.contentHeight +  350
	game3.y = game3.contentHeight

	local game4 = display.newImageRect( "images/logo/game4.jpeg", 100, 100 )
	game4.x = game4.contentHeight +90 
	game4.y = game4.contentHeight + 140
	game4.touch = onGame4BtnRelease
	game4:addEventListener( "touch", game4 )

	local game5 = display.newImageRect( "images/logo/locked cycling.png", 100, 100 )
	game5.x = game5.contentHeight +  270 
	game5.y = game5.contentHeight + 140


	-- all display objects must be inserted into group
	sceneGroup:insert( background )
	sceneGroup:insert( game1 )
	sceneGroup:insert( game2 )
	sceneGroup:insert( game3 )
	sceneGroup:insert( game4 )
	sceneGroup:insert( game5 )
	sceneGroup:insert( backButton )
	sceneGroup:insert(musicButtonOFF)
	sceneGroup:insert(musicButtonON)
end


function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase
	
	if phase == "will" then
		-- Called when the scene is still off screen and is about to move on screen
	elseif phase == "did" then
		-- Called when the scene is now on screen
		-- 
		physics.start()
		if (sound == "ON") then

			if audio.isChannelPlaying( 1 ) then
			else
				audio.stop()
				audio.play(musicTrack, {  channel=1, loops=-1 })
			end

			musicButtonON.isVisible = true
			musicButtonOFF.isVisible = false
		else
			audio.stop()
			musicButtonON.isVisible = false
			musicButtonOFF.isVisible = true
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

	-- Called prior to the removal of scene's "view" (sceneGroup)
	-- 
	-- INSERT code here to cleanup the scene
	-- e.g. remove display objects, remove touch listeners, save state, etc.
	local sceneGroup = self.view
	
end

---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

-----------------------------------------------------------------------------------------

return scene