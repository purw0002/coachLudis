-----------------------------------------------------------------------------------------
--
-- level1.lua
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()


--------------------------------------------

-- forward declarations and other locals
local screenW, screenH, halfW = display.actualContentWidth, display.actualContentHeight, display.contentCenterX


function scene:create( event )

	-- Called when the scene's view does not exist.
	-- 
	-- INSERT code here to initialize the scene
	-- e.g. add display objects to 'sceneGroup', add touch listeners, etc.

	local sceneGroup = self.view
	local stars = composer.stars
	local background = display.newImageRect( "completeScreen.jpg", display.actualContentWidth, display.actualContentHeight )
	background.anchorX = 0
	background.anchorY = 0

	background.x = display.screenOriginX 
	background.y = display.screenOriginY

	local frame = display.newImageRect( "images/ratings/levelCompleteFrame.png", 500, 300 )

	frame.x = display.contentCenterX+30
	frame.y = display.contentCenterY

	local starsGp = display.newGroup()

	local star1 = display.newImageRect( "images/ratings/star.png", 85, 85)
	star1.x = display.contentCenterX-21
	star1.y = display.contentCenterY -35
	star1.isVisible = false

	local star2 = display.newImageRect( "images/ratings/star.png", 95, 95 )
	star2.x = display.contentCenterX+29 
	star2.y = display.contentCenterY - 44
	star2.isVisible = false

	local star3 = display.newImageRect( "images/ratings/star.png", 85, 85 )
	star3.x = display.contentCenterX+82 
	star3.y = display.contentCenterY -35
	star3.isVisible = false

	starsGp:insert(star1)
	starsGp:insert(star2)
	starsGp:insert(star3)

	local function showStars(num)
		if (stars > 0) then
			starsGp[num].isVisible = true
			stars = stars - 1
			timer.performWithDelay( 1000, showStars(num+1), 1)
		end
	end

	timer.performWithDelay( 1000, showStars(1), 1)

	local function goToSportSelect()
		print("goToSportSelect")
		composer.gotoScene( "select", "fade", 500 )
	end

	local function replayLevel()
		print("replayLevel")
		composer.gotoScene( "level2", "fade", 500 )
	end

	local function goToLevelSelect()
		print("goToLevelSelect")
		composer.gotoScene( "levelSelect", "fade", 500 )
	end

	local function goNext()
		print("goNext")
		composer.gotoScene( "select", "fade", 500 )
	end

	local levelUpButton = display.newImageRect( "images/ratings/home icon.png", 100, 100 )
	levelUpButton.x = display.contentCenterX-23
	levelUpButton.y = display.contentCenterY +105
	levelUpButton.touch = goToSportSelect
	levelUpButton:addEventListener( "touch", levelUpButton )

	local levelIconButton = display.newImageRect( "images/ratings/level icon.png", 100, 100 )
	levelIconButton.x = display.contentCenterX +12
	levelIconButton.y = display.contentCenterY +105
	--levelIconButton.touch = goToLevelSelect
	--levelIconButton:addEventListener( "touch", levelIconButton )

	local replayButton = display.newImageRect( "images/ratings/replay icon.png", 100, 100 )
	replayButton.x = display.contentCenterX+47
	replayButton.y = display.contentCenterY +105
	replayButton.touch = replayLevel
	replayButton:addEventListener( "touch", replayButton )


	local playIcon = display.newImageRect( "images/ratings/play icon.png", 100, 100 )
	playIcon.x = display.contentCenterX+82
	playIcon.y = display.contentCenterY +105
	playIcon.touch = goNext
	playIcon:addEventListener( "touch", playIcon )



	-- We need physics started to add bodies, but we don't want the simulaton
	-- running until the scene is on the screen.

	-- create a grey rectangle as the backdrop
	-- the physical screen will likely be a different shape than our defined content area
	-- since we are going to position the background from it's top, left corner, draw the
	-- background at the real top, left corner.

	-- all display objects must be inserted into group
	sceneGroup:insert( background )
	sceneGroup:insert( frame )
	sceneGroup:insert( starsGp )
	sceneGroup:insert( levelUpButton )
	sceneGroup:insert( replayButton )
	sceneGroup:insert( levelIconButton )
	sceneGroup:insert( playIcon )


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