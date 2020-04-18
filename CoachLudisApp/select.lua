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

local function onGame1BtnRelease()
	
	-- go to level1.lua scene
	composer.gotoScene( "level2", "fade", 500 )
	
	return true	-- indicates successful touch
end


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

	-- create a grey rectangle as the backdrop
	-- the physical screen will likely be a different shape than our defined content area
	-- since we are going to position the background from it's top, left corner, draw the
	-- background at the real top, left corner.
	local background = display.newRect( display.screenOriginX, display.screenOriginY, screenW, screenH )
	background.anchorX = 0 
	background.anchorY = 0
	background:setFillColor( 1 )
	local game1 = display.newImageRect( "images/logo/game1.jpeg", 100, 100 )
	game1.x = game1.contentHeight + 10
	game1.y = game1.contentHeight
	game1.touch = onGame1BtnRelease
	game1:addEventListener( "touch", game1 )
	
	local game2 = display.newImageRect( "images/logo/game2.jpeg", 100, 100 )
	game2.x = game2.contentHeight +  180 
	game2.y = game2.contentHeight

	local game3 = display.newImageRect( "images/logo/game3.jpeg", 100, 100 )
	game3.x = game3.contentHeight +  350
	game3.y = game3.contentHeight

	local game4 = display.newImageRect( "images/logo/game4.jpeg", 100, 100 )
	game4.x = game4.contentHeight +90 
	game4.y = game4.contentHeight + 140

	local game5 = display.newImageRect( "images/logo/game5.jpeg", 100, 100 )
	game5.x = game5.contentHeight +  270 
	game5.y = game5.contentHeight + 140


	-- all display objects must be inserted into group
	sceneGroup:insert( background )
	sceneGroup:insert( game1 )
	sceneGroup:insert( game2 )
	sceneGroup:insert( game3 )
	sceneGroup:insert( game4 )
	sceneGroup:insert( game5 )

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