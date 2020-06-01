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
	-- Called when the scene's view does not exist.
	-- 
	-- INSERT code here to initialize the scene
	-- e.g. add display objects to 'sceneGroup', add touch listeners, etc.

	local loadingGif = {
		width= 72,
		height= 72,
		numFrames= 6,
		sheetContentWidth= 432,
		sheetContentHeight= 72
	}
	local sceneGroup = self.view

	-- We need physics started to add bodies, but we don't want the simulaton
	-- running until the scene is on the screen.

	-- create a grey rectangle as the backdrop
	-- the physical screen will likely be a different shape than our defined content area
	-- since we are going to position the background from it's top, left corner, draw the
	-- background at the real top, left corner.


	local background = display.newImageRect( "images/loading/loading screen background.png", screenW, screenH )
	background.anchorX = 0
	background.anchorY = 0

	local loadingSheet = graphics.newImageSheet("images/loading/loding gifs/loadingSprite.png",loadingGif )
	local 	loadingGifC = {
		{ name = "turn", start = 1, count= 6,time=1000}
	}
	local loadGif = display.newSprite(loadingSheet, loadingGifC)
	-- all display objects must be inserted into group

	loadGif.x, loadGif.y = display.contentCenterX+30,display.contentCenterY-10
	loadGif.name="loadGif"
	loadGif:setSequence("turn")
	loadGif:scale(0.5,0.5)
	loadGif:play()

	sceneGroup:insert( background )
	sceneGroup:insert( loadGif )
end


function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase
	
	if phase == "will" then
		-- Called when the scene is still off screen and is about to move on screen
	elseif phase == "did" then
		-- Called when the scene is now on screen
		-- 
		if(composer.game == "soccer") then
			composer.removeScene('level2')
			composer.gotoScene( "level2", "fade", 100 )
		else
			composer.removeScene('cycleLevel2')
			composer.gotoScene( "cycleLevel2", "fade", 100 )
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