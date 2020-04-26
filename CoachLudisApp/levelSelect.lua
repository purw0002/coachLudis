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


function scene:create( event )
	prevScreen = "select"




	musicButtonONLS = display.newImageRect( "images/background/app background/music button.png", 50, 50 )
	musicButtonOFFLS = display.newImageRect( "images/background/app background/no music icon.png", 50, 50 )

	local function stopAudio(event)
		if ( event.phase == "began" ) then
			audio.stop()
			sound = "OFF"
			musicButtonONLS.isVisible = false
			musicButtonOFFLS.isVisible = true
		end
	end

	local function startAudio(event)
		if ( event.phase == "began" ) then
			audio.play(musicTrack)
			sound = "ON"
			musicButtonONLS.isVisible = true
			musicButtonOFFLS.isVisible = false
		end
	end

	musicButtonONLS.x = 545
	musicButtonONLS.y = 20
	musicButtonONLS:addEventListener( "touch", stopAudio )
	musicButtonONLS.isVisible = true


	musicButtonOFFLS.x = 545
	musicButtonOFFLS.y = 20
	musicButtonOFFLS:addEventListener( "touch", startAudio )
	musicButtonOFFLS.isVisible = false


	-- Called when the scene's view does not exist.
	-- 
	-- INSERT code here to initialize the scene
	-- e.g. add display objects to 'sceneGroup', add touch listeners, etc.
	local function goBackToPrev(event)
		composer.prevScreen = event.target.prev
		if (prevScreen ~= "None") then
			composer.gotoScene( event.target.curScreen, "fade", 500 )
		end
	end
	local backButton = display.newImageRect( "images/commons/back button.png", 60, 60 )
	backButton.x = 20
	backButton.y = 20
	backButton.prev = "selectCharacter"
	backButton.curScreen = "select"
	backButton:addEventListener( "touch", goBackToPrev )

	local sceneGroup = self.view
	local background1 = display.newImageRect( "images/background/app background/appBack1.png", screenW, screenH )
	background1.anchorX = 0
	background1.anchorY = 0

	local background = display.newImageRect( "images/level select/level select.png", screenW, screenH )
	background.anchorX = 0
	background.anchorY = 0

	local locks = display.newGroup()
	local levels = display.newGroup()

	local totalLevels = composer.numOfLevels
	local unlockedLevels = composer.unlocked
	local game = composer.game

	local lockSymbol1 = display.newImageRect( "images/level select/locked level icon.png", 80, 80 )
	lockSymbol1.x = display.contentCenterX - 30
	lockSymbol1.y = display.contentCenterY -30

	local lockSymbol2 = display.newImageRect( "images/level select/locked level icon.png", 80, 80 )
	lockSymbol2.x = display.contentCenterX +50
	lockSymbol2.y = display.contentCenterY -30

	local lockSymbol3 = display.newImageRect( "images/level select/locked level icon.png", 80, 80 )
	lockSymbol3.x = display.contentCenterX +130
	lockSymbol3.y = display.contentCenterY -30

	local lockSymbol4 = display.newImageRect( "images/level select/locked level icon.png", 80, 80 )
	lockSymbol4.x = display.contentCenterX +10
	lockSymbol4.y = display.contentCenterY +30

	local lockSymbol5 = display.newImageRect( "images/level select/locked level icon.png", 80, 80 )
	lockSymbol5.x = display.contentCenterX +90
	lockSymbol5.y = display.contentCenterY +30

	locks:insert(lockSymbol1)
	locks:insert(lockSymbol2)
	locks:insert(lockSymbol3)
	locks:insert(lockSymbol4)
	locks:insert(lockSymbol5)

	local function goToLevel2()
		if (game == "soccer") then
			composer.levelPlaying = 'level2'
			composer.nextLevel = 'level3'
			composer.removeScene('level2')
			composer.gotoScene( "level2", "fade", 1 )
		end
	end

	local function goToLevel3()
		if (game == "soccer") then
			composer.levelPlaying = 'level3'
			composer.nextLevel = 'none'
			composer.gotoScene( "level3", "fade", 1 )
		end
	end

	local levelSymbol1 = display.newImageRect( "images/level select/level 1 icon.png", 80, 80 )
	levelSymbol1.x = display.contentCenterX - 30
	levelSymbol1.y = display.contentCenterY -30
	levelSymbol1.isVisible = false
	levelSymbol1.touch = goToLevel2
	levelSymbol1:addEventListener( "touch", levelSymbol1 )

	local levelSymbol2 = display.newImageRect( "images/level select/level 2 icon.png", 80, 80 )
	levelSymbol2.x = display.contentCenterX +50
	levelSymbol2.y = display.contentCenterY -30
	levelSymbol2.isVisible = false
	levelSymbol2.touch = goToLevel3
	levelSymbol2:addEventListener( "touch", levelSymbol2 )

	local levelSymbol3 = display.newImageRect( "images/level select/level 3 icon.png", 80, 80 )
	levelSymbol3.x = display.contentCenterX +130
	levelSymbol3.y = display.contentCenterY -30
	levelSymbol3.isVisible = false

	local levelSymbol4 = display.newImageRect( "images/level select/level 4 icon.png", 80, 80 )
	levelSymbol4.x = display.contentCenterX +10
	levelSymbol4.y = display.contentCenterY +30
	levelSymbol4.isVisible = false

	local levelSymbol5 = display.newImageRect( "images/level select/level 5 icon.png", 80, 80 )
	levelSymbol5.x = display.contentCenterX +90
	levelSymbol5.y = display.contentCenterY +30
	levelSymbol5.isVisible = false

	levels:insert(levelSymbol1)
	levels:insert(levelSymbol2)
	levels:insert(levelSymbol3)
	levels:insert(levelSymbol4)
	levels:insert(levelSymbol5)

	local function showAvailableLevels(num)
		if (unlockedLevels > 0) then
			levels[num].isVisible = true
			unlockedLevels = unlockedLevels - 1
			timer.performWithDelay( 1000, showAvailableLevels(num+1), 1)
		end
	end

	timer.performWithDelay( 1000, showAvailableLevels(1), 1)


	-- We need physics started to add bodies, but we don't want the simulaton
	-- running until the scene is on the screen.

	-- create a grey rectangle as the backdrop
	-- the physical screen will likely be a different shape than our defined content area
	-- since we are going to position the background from it's top, left corner, draw the
	-- background at the real top, left corner.
	sceneGroup:insert( background1 )
	sceneGroup:insert( background )
	sceneGroup:insert( locks )
	sceneGroup:insert( levels )
	sceneGroup:insert( backButton )
	sceneGroup:insert( musicButtonOFFLS )
	sceneGroup:insert( musicButtonONLS )


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
	end
end

function scene:hide( event )
	local sceneGroup = self.view
	
	local phase = event.phase
	
	if event.phase == "will" then
		-- Called when the scene is on screen and is about to move off screen
		--
		if (sound == "ON") then
			if audio.isChannelPlaying( 1 ) then
			else
				audio.stop()
				audio.play(musicTrack, {  channel=1, loops=-1 })
			end
			musicButtonONLS.isVisible = true
			musicButtonOFFLS.isVisible = false
		else
			musicButtonONLS.isVisible = false
			musicButtonOFFLS.isVisible = true
			audio.stop()
		end
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