local composer = require( "composer" )
local scene = composer.newScene()

local startCycling = display.newImageRect( "images/cyclinglevel1/play icon.png", 100, 100)
   startCycling.x = display.contentCenterX
   startCycling.y = display.contentCenterY

local function startCyclingTapListener()
    startCycling.isVisible = false
    composer.gotoScene( "cycleLevel2", "fade", 500 )
    return true
end

function scene:create( event )
	local sceneGroup = self.view
	display.setStatusBar(display.HiddenStatusBar)

    local background = display.newImageRect(sceneGroup, "images/cyclinglevel1/level complete page background.png", 480, 320)
       background.x = display.contentCenterX
       background.y = display.contentCenterY

    
    

    startCycling:addEventListener("tap", startCyclingTapListener)

    sceneGroup:insert(background)
    sceneGroup:insert(startCycling)
end

scene:addEventListener("create", scene )

return scene