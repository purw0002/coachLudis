local composer = require( "composer" )
local scene = composer.newScene()

local startCycling = display.newImageRect( "images/cyclinglevel1/play icon.png", 100, 100)
   startCycling.x = 300
   startCycling.y = 200

local backLevel1 = display.newImageRect("images/cyclinglevel1/back button.png", 75, 75)
   backLevel1.x = 350
   backLevel1.y = 200

local function backLevelTapListener()
   composer.gotoScene( "level02_1", "fade", 500 )
   return true
end

backLevel1:addEventListener("tap", backLevelTapListener)

local function startCyclingTapListener()
    composer.gotoScene( "cycleLevel2", "fade", 500 )
    return true
end

    local caliperContent =
  {
    text = "Caliper has been checked! Always remember use brake reduce your speed!",
    x = 73,
    y = 60,
    width = 100,
    font = native.systemFont,
    fontSize = 13,
    align = "left"
  }

  local caliperMessage = display.newText(caliperContent)
  caliperMessage:setFillColor(black)
  caliperMessage.isVisible = true

  local helmetContent = 
  {
    text = "Helmet has been checked! Always remember wear your helmet before cycling, it can prevent head injury!",
    x = 215,
    y = 60,
    width = 100,
    font = native.systemFont,
    fontSize = 11,
    align = "left"
  }

  local helmetMessage = display.newText(helmetContent)
  helmetMessage:setFillColor(black)
  helmetMessage.isVisible = true

  local taillightContent = 
  {
    text = "Taillight has been checked! Taillight can reminder vehicles behind you to prevent crushing!",
    x = 360,
    y = 60,
    width = 100,
    font = native.systemFont,
    fontSize = 12,
    align = "left"
  }

  local taillightMessage = display.newText(taillightContent)
  taillightMessage:setFillColor(black)
  taillightMessage.isVisible = true

  local wheelContent = 
  {
   text =   "Wheels have been checked! Make sure your tyres are not worn and have engough pressure to prevent bike out of control!",
   x = 498,
   y = 60,
   width = 100,
   font = native.systemFont,
   fontSize = 11,
   align = "left"
 }

 local wheelMessage = display.newText(wheelContent)
 wheelMessage:setFillColor(black) 
 wheelMessage.isVisible = true

function scene:create( event )
	local sceneGroup = self.view
	display.setStatusBar(display.HiddenStatusBar)

    local background = display.newImageRect(sceneGroup, "images/cyclinglevel1/level complete page background.png", 570, 320)
       background.x = display.contentCenterX+45
       background.y = display.contentCenterY


    
    
    startCycling:addEventListener("tap", startCyclingTapListener)

    
    sceneGroup:insert(background)
    sceneGroup:insert(startCycling)
end

function scene:show( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is still off screen (but is about to come on screen)
        backLevel1.isVisible = true
        startCycling.isVisible = true
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
         caliperMessage.isVisible = false
         wheelMessage.isVisible = false
         helmetMessage.isVisible = false
         taillightMessage.isVisible = false
         backLevel1.isVisible = false
    elseif ( phase == "did" ) then
        -- Code here runs immediately after the scene goes entirely off screen
        
    end
end

scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )

return scene