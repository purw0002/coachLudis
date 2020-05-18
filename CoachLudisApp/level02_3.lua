local composer = require( "composer" )
local scene = composer.newScene()

local backLevel1 = display.newImageRect("images/cyclinglevel1/restart button.png", 100, 100)
   backLevel1.x = display.contentCenterX+45
   backLevel1.y = 270

local function backLevelTapListener()
	composer.removeScene( "level02_3" )
    composer.gotoScene( "level02_1", "fade", 500 )
    return true
end

function scene:create( event )
	local sceneGroup = self.view
	display.setStatusBar(display.HiddenStatusBar)

    local background = display.newImageRect(sceneGroup, "images/cyclinglevel1/level complete page background.png", 570, 320)
       background.x = display.contentCenterX+45
       background.y = display.contentCenterY

    local helmet = display.newImageRect("images/cyclinglevel1/helmet.png", 130, 130)
       helmet.x = display.contentCenterX+50
       helmet.y = 80

    local helmetText = display.newText("You must wear your helmet before you go to cycling!", display.contentCenterX+35, 165, native.systemFont, 20)
    helmetText:setFillColor(black)

    backLevel1:addEventListener("tap", backLevelTapListener)

    sceneGroup:insert(background)
    sceneGroup:insert(helmet)
    sceneGroup:insert(helmetText)
    sceneGroup:insert(backLevel1)
    

end

function scene:show( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is still off screen (but is about to come on screen)
        backLevel1.isVisible = true
       
        

    elseif ( phase == "did" ) then
        -- Code here runs when the scene is entirely on screen
        --backLevel1.isVisible = true
    end
end

function scene:hide( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is on screen (but is about to go off screen)
        
    elseif ( phase == "did" ) then
        -- Code here runs immediately after the scene goes entirely off screen
        
    end
end

scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )

return scene