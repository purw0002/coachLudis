----------------------------------------------------------------------------------------
--
-- level1.lua
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()

-- include Corona's "physics" library
local physics = require "physics"

--------------------------------------------
-- create a grey rectangle as the backdrop
	-- the physical screen will likely be a different shape than our defined content area
	-- since we are going to position the background from it's top, left corner, draw the
	-- background at the real top, left corner.
	local background = display.newRect( display.screenOriginX, display.screenOriginY, screenW, screenH )
	background.anchorX = 0 
	background.anchorY = 0
	background:setFillColor( .5 )

	-- create a arm object and add physics (with custom shape)
	arm = display.newImageRect( "ice_background.png", screenW, screenH )
	arm.anchorX = 0
	arm.anchorY = 1
	--  draw the arm at the very bottom of the screen
	arm.x, arm.y = display.screenOriginX, display.actualContentHeight + display.screenOriginY
	
	-- define a shape that's slightly shorter than image bounds (set draw mode to "hybrid" or "debug" to see)
	local armShape = { -halfW,-34, halfW,-34, halfW,34, -halfW,34 }
	physics.addBody( arm, "static", { friction=0.3, shape=armShape } )
	myCircle = display.newCircle( 440, 260, 70 )
	myCircle:setFillColor(1,0,0)
	ice_pack = display.newImageRect( "ice_pack.png", 100, 100 )
	ice_pack:translate( 100, 100 )
	hot_water_bag = display.newImageRect( "hot_water_bag.png", 100, 100 )
	hot_water_bag:translate(100,220)
	--bandage = display.newImageRect( "bandage.png", 100, 100 )