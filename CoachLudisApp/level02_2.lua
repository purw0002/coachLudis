local composer = require( "composer" )
local scene = composer.newScene()

local startCycling = display.newImageRect( "images/cyclinglevel1/play icon.png", 120, 120)
   startCycling.x = display.contentCenterX+45
   startCycling.y = 270

local function startCyclingTapListener()
    composer.removeScene( "level02_2" )
    composer.gotoScene( "instructionCycle", "fade", 500 )
    return true
end

function scene:create( event )
   local sceneGroup = self.view
	 display.setStatusBar(display.HiddenStatusBar)

   local background = display.newImageRect(sceneGroup, "images/cyclinglevel1/Bicycle preparation game page 2.png", 570, 320)
       background.x = display.contentCenterX+45
       background.y = display.contentCenterY

   local caliper = display.newImageRect("images/cyclinglevel1/caliper.png", 80, 80)
   caliper.x = 100
   caliper.y = 73

   local helmet = display.newImageRect("images/cyclinglevel1/helmet.png", 80, 80)
   helmet.x = 225
   helmet.y = 73

   local taillight = display.newImageRect("images/cyclinglevel1/taillight.png", 80, 80)
   taillight.x = 350
   taillight.y = 72

   local wheel = display.newImageRect("images/cyclinglevel1/wheel.png", 80, 80)
   wheel.x = 470
   wheel.y = 75

   local caliperContent =
   {
    text = "Always remember use brake reduce your speed!",
    x = 103,
    y = 170,
    width = 100,
    font = native.systemFont,
    fontSize = 12,
    align = "left"
   }

  local caliperMessage = display.newText(caliperContent)
  caliperMessage:setFillColor(black)
  caliperMessage.isVisible = true

  local helmetContent = 
  {
    text = "Always remember wear your helmet before cycling, it can prevent head injury!",
    x = 228,
    y = 170,
    width = 100,
    font = native.systemFont,
    fontSize = 12,
    align = "left"
  }

  local helmetMessage = display.newText(helmetContent)
  helmetMessage:setFillColor(black)
  helmetMessage.isVisible = true

  local taillightContent = 
  {
    text = "Taillight can reminder vehicles behind you to prevent crushing!",
    x = 353,
    y = 171,
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
   text = "Make sure your tyres are not worn and have engough pressure to prevent bike out of control!",
   x = 473,
   y = 170,
   width = 100,
   font = native.systemFont,
   fontSize = 11.5,
   align = "left"
  }

  local wheelMessage = display.newText(wheelContent)
  wheelMessage:setFillColor(black) 
  wheelMessage.isVisible = true
    
  startCycling:addEventListener("tap", startCyclingTapListener)

    
  sceneGroup:insert(background)
  sceneGroup:insert(startCycling)
  sceneGroup:insert(caliper)
  sceneGroup:insert(helmet)
  sceneGroup:insert(taillight)
  sceneGroup:insert(wheel)
  sceneGroup:insert(caliperMessage)
  sceneGroup:insert(helmetMessage)
  sceneGroup:insert(taillightMessage)
  sceneGroup:insert(wheelMessage)

end

function scene:show( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is still off screen (but is about to come on screen)
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

    elseif ( phase == "did" ) then
        -- Code here runs immediately after the scene goes entirely off screen
        
    end
end

scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )

return scene