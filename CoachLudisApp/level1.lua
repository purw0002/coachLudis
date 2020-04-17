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

	healthValue = 3
	local sceneGroup = self.view

	-- We need physics started to add bodies, but we don't want the simulaton
	-- running until the scene is on the screen.
	physics.start()
	physics.pause()
	-- Called when the scene's view does not exist.
	-- 
	-- INSERT code here to initialize the scene
	-- e.g. add display objects to 'sceneGroup', add touch listeners, etc.
	local healths = display.newGroup()
	local function onCollision(event)

		if(event.phase == "began") then
			if(event.object1.name == "player" or event.object2.name == "player") then
				event.object2:removeSelf()
				if (healthValue == 1) then
					healths[1].alpha = 0
					physics.pause()
				elseif (healthValue == 3) then
					healths[3].alpha = 0
				elseif (healthValue == 2) then
					healths[2].alpha = 0
				end
				healthValue = healthValue - 1
			end
		end
	end
	-- create a grey rectangle as the backdrop
	-- the physical screen will likely be a different shape than our defined content area
	-- since we are going to position the background from it's top, left corner, draw the
	-- background at the real top, left corner.
	local background = display.newRect( display.screenOriginX, display.screenOriginY, screenW, screenH )
	background.anchorX = 0 
	background.anchorY = 0
	background:setFillColor( .5 )
	dist = 5
	for i= 1,3,1 
	do 
		health = display.newImageRect( "crate.png", 20, 20) 
		health.x, health.y = dist,20
		health.name  = i
		dist = dist + 30
		healths:insert(health)
	end


	local crates = display.newGroup()

	local function randomizeLane()

		local lanes = {1, 2, 3, 4, 5 }
		local idx = math.random(#lanes)
		local selectedLane = lanes[idx]
		if(selectedLane == 1) then
			return 100
		elseif (selectedLane == 2) then
			return 160
		elseif (selectedLane == 3) then
			return 220
		elseif (selectedLane == 4) then
			return 280
		elseif (selectedLane == 5) then
			return 340
		end
	end
	initialObstacle = -500
	crate_id = 0
	local function createCrate()
    	crate = display.newImageRect( "crate.png", 50, 50 )
    	crate.x = randomizeLane()
    	crate_id = crate_id + 1
    	crate.name = "crate" .. tostring(crate_id)
    	crate.y = initialObstacle
		physics.addBody( crate )
    	crate.gravityScale = 0.25

    	crates:insert(crate)
    end

	timer.performWithDelay( 1000, createCrate,13 )


	local player = display.newImageRect( "soccer.png", 50, 50)

	player.name = "player"
	player.x, player.y = 160,220
	physics.addBody( player, "static" )



	local function moveLeft(event)
		if (event.phase == "ended") then
			if(player.x > 100) then
				player.x = player.x - 60
			end
		end
		return true
	end

	local function moveRight( event )
		if (event.phase == "ended") then
			if(player.x < 340) then
				player.x = player.x + 60
			end
		end
		return true
	end

	local leftArrow = display.newImageRect( "Icon-hdpi.png", 50, 50 )
	leftArrow.x, leftArrow.y = 0,110
	leftArrow:addEventListener( "touch", moveLeft )

	local rightArrow = display.newImageRect( "Icon-hdpi.png", 50, 50 )
	rightArrow.x, rightArrow.y = 480,110
	rightArrow:addEventListener( "touch", moveRight )



	-- make a crate (off-screen), position it, and rotate slightly
	-- create a grass object and add physics (with custom shape)
	local grass = display.newImageRect( "grass.png", screenW, 82 )
	grass.anchorX = 0
	grass.anchorY = 1
	--  draw the grass at the very bottom of the screen
	grass.x, grass.y = display.screenOriginX, display.actualContentHeight + display.screenOriginY
	
	-- define a shape that's slightly shorter than image bounds (set draw mode to "hybrid" or "debug" to see)
	local grassShape = { -halfW,-34, halfW,-34, halfW,34, -halfW,34 }
	-- all display objects must be inserted into group


	sceneGroup:insert( background )
	sceneGroup:insert( grass)
	sceneGroup:insert( crates )
	sceneGroup:insert(player)
	sceneGroup:insert(leftArrow)
	sceneGroup:insert(rightArrow)
	sceneGroup:insert(healths)

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