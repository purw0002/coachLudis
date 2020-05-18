-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- Your code here
local composer = require( "composer" )
local scene = composer.newScene()

local startCycling = display.newImageRect( "images/cyclinglevel1/play icon.png", 100, 100)
  startCycling.x = 453
  startCycling.y = 150

local function startCyclingTapListener()
   startCycling.isVisible = false
   composer.gotoScene( "level02_2", "fade", 500 )
   return true
end

function scene:create( event )
  local sceneGroup = self.view

  

  local background = display.newImageRect("images/cyclinglevel1/bicycle_level_1_background.jpg", 570, 320)
  background.x = display.contentCenterX
  background.y = display.contentCenterY

  local instruction = display.newText("What do you need to check before cycling? Click items above~", display.contentCenterX, 125, native.systemFont, 12)
  instruction:setFillColor(black)	

  local ending = display.newText("Are you ready for cycling? Click the button on right side now!", display.contentCenterX, 145, native.systemFont, 12)
  ending:setFillColor(black)
  ending.isVisible = false

  local character = display.newImageRect("images/cyclinglevel1/Idle (15).png", 210, 210)
  character.x = 70
  character.y = 230

  local caliper = display.newImageRect("images/cyclinglevel1/caliper.png", 95, 95)
  caliper.x = 28
  caliper.y = 60

  local helmet = display.newImageRect("images/cyclinglevel1/helmet.png", 95, 95)
  helmet.x = 170
  helmet.y = 60

  local taillight = display.newImageRect("images/cyclinglevel1/taillight.png", 95, 95)
  taillight.x = 310
  taillight.y = 57

  local wheel = display.newImageRect("images/cyclinglevel1/wheel.png", 95, 95)
  wheel.x = 453
  wheel.y = 60

  local caliperContent =
  {
    text = "Caliper has been checked! Always remember use brake reduce your speed!",
    x = 28,
    y = 60,
    width = 100,
    font = native.systemFont,
    fontSize = 13,
    align = "left"
  }

  local caliperMessage = display.newText(caliperContent)
  caliperMessage:setFillColor(black)
  caliperMessage.isVisible = false

  local helmetContent = 
  {
    text = "Helmet has been checked! Always remember wear your helmet before cycling, it can prevent head injury!",
    x = 170,
    y = 60,
    width = 100,
    font = native.systemFont,
    fontSize = 11,
    align = "left"
  }

  local helmetMessage = display.newText(helmetContent)
  helmetMessage:setFillColor(black)
  helmetMessage.isVisible = false

  local taillightContent = 
  {
    text = "Taillight has been checked! Taillight can reminder vehicles behind you to prevent crushing!",
    x = 315,
    y = 60,
    width = 100,
    font = native.systemFont,
    fontSize = 12,
    align = "left"
  }

  local taillightMessage = display.newText(taillightContent)
  taillightMessage:setFillColor(black)
  taillightMessage.isVisible = false

  local wheelContent = 
  {
   text = 	"Wheels have been checked! Make sure your tyres are not worn and have engough pressure to prevent bike out of control!",
   x = 453,
   y = 60,
   width = 100,
   font = native.systemFont,
   fontSize = 11,
   align = "left"
 }

 local wheelMessage = display.newText(wheelContent)
 wheelMessage:setFillColor(black) 
 wheelMessage.isVisible = false

 local function helmetTapListener()

  -- Code executed when the button is tapped
  helmet.isVisible = false
  helmetMessage.isVisible = true
  instruction.isVisible = false
  ending.isVisible = true
end

helmet:addEventListener("tap", helmetTapListener)

local function caliperTapListener()

  -- Code executed when the button is tapped
  caliper.isVisible = false
  caliperMessage.isVisible = true
  instruction.isVisible = false
  ending.isVisible = true
end

caliper:addEventListener("tap", caliperTapListener)

local function taillightTapListener()

  -- Code executed when the button is tapped
  taillight.isVisible = false
  taillightMessage.isVisible = true
  instruction.isVisible = false
  ending.isVisible = true
end

taillight:addEventListener("tap", taillightTapListener)

local function wheelTapListener()

  -- Code executed when the button is tapped
  wheel.isVisible = false
  wheelMessage.isVisible = true
  instruction.isVisible = false
  ending.isVisible = true
end

wheel:addEventListener("tap", wheelTapListener)




startCycling:addEventListener("tap", startCyclingTapListener)

sceneGroup:insert(background)
sceneGroup:insert(instruction)
sceneGroup:insert(ending)
sceneGroup:insert(character)
sceneGroup:insert(caliper)
sceneGroup:insert(helmet)
sceneGroup:insert(taillight)
sceneGroup:insert(wheel)
sceneGroup:insert(helmetMessage)
sceneGroup:insert(caliperMessage)
sceneGroup:insert(taillightMessage)
sceneGroup:insert(wheelMessage)


end

function scene:destroy( event )
  local sceneGroup = self.view
  
  -- Called prior to the removal of scene's "view" (sceneGroup)
  -- 
  -- INSERT code here to cleanup the scene
  -- e.g. remove display objects, remove touch listeners, save state, etc.
  
    startCycling:removeSelf()  -- widgets must be manually removed
    startCycling = nil
  
end

scene:addEventListener( "create", scene )
scene:addEventListener( "destroy", scene )

return scene
--local function chooseItem(event)
--   if (event.phase == "began") then

  --end

