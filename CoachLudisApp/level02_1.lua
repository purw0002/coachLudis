-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- Your code here
local composer = require( "composer" )
local scene = composer.newScene()

composer.recycleOnSceneChange = true

local startCycling = display.newImageRect( "images/cyclinglevel1/let's go button.png", 180, 140)
  startCycling.x = 498
  startCycling.y = 150

function scene:create( event )
  local sceneGroup = self.view

  local background = display.newImageRect("images/cyclinglevel1/bicycle_level_1_background.jpg", 570, 320)
  background.x = display.contentCenterX+45
  background.y = display.contentCenterY

  local instruction = display.newText("What do you need to check before cycling? Click items above~", display.contentCenterX+45, 125, native.systemFont, 12)
  instruction:setFillColor(black)	

  local ending = display.newText("Are you ready for cycling?", display.contentCenterX+45, 145, native.systemFont, 12)
  ending:setFillColor(black)
  ending.isVisible = false

  local character
  if (composer.playerGender == "boy") then
    character = display.newImageRect("images/cyclinglevel1/Idle (15).png", 210, 210)
    character.x = 115
    character.y = 230
  else
    character = display.newImageRect("images/characters/player-girl/Idle (1).png", 130, 130)

    character.x = 60
    character.y = 230
  end



  local caliper = display.newImageRect("images/cyclinglevel1/caliper.png", 95, 95)
  caliper.x = 73
  caliper.y = 60
  caliper.alpha = 0.3

  local helmet = display.newImageRect("images/cyclinglevel1/helmet.png", 95, 95)
  helmet.x = 215
  helmet.y = 60
  helmet.alpha = 0.3

  local taillight = display.newImageRect("images/cyclinglevel1/taillight.png", 95, 95)
  taillight.x = 355
  taillight.y = 57
  taillight.alpha = 0.3

  local wheel = display.newImageRect("images/cyclinglevel1/wheel.png", 95, 95)
  wheel.x = 498
  wheel.y = 60
  wheel.alpha = 0.3
  
  local caliperPopup = display.newImageRect("images/cyclinglevel1/Caliper checked.png", 270, 210)
  caliperPopup.x = 325
  caliperPopup.y = 210
  caliperPopup.isVisible = false

  local helmetPopup = display.newImageRect("images/cyclinglevel1/helmet checked.png", 270, 210)
  helmetPopup.x = 190
  helmetPopup.y = 160
  helmetPopup.isVisible = false

  local taillightPopup = display.newImageRect("images/cyclinglevel1/taillight checked.png", 270, 210)
  taillightPopup.x = 335
  taillightPopup.y = 160
  taillightPopup.isVisible = false

  local wheelPopup = display.newImageRect("images/cyclinglevel1/wheels checked.png", 270, 210)
  wheelPopup.x = 485
  wheelPopup.y = 205
  wheelPopup.isVisible = false

  local function startCyclingTapListener(e)
    print(e.phase)
    if e.phase == "began" then
     if (helmet.alpha < 1 ) then
        startCycling.isVisible = false
        composer.removeScene( "level02_1" )
        composer.gotoScene( "level02_3", "fade", 500 )
     else
        startCycling.isVisible = false
        composer.removeScene( "level02_1" )
        composer.gotoScene( "level02_2", "fade", 500 )
     end
   end
  end

  local function helmetTapListener()

  -- Code executed when the button is tapped
     if (helmet.alpha < 1) then
        helmetPopup.isVisible = true
     end
     helmet.alpha = 1
     instruction.isVisible = false
     ending.isVisible = true
  end

  local function helmetPopupTapListener()
     helmetPopup.isVisible = false 
  end

  helmet:addEventListener("tap", helmetTapListener)
  helmetPopup:addEventListener("tap", helmetPopupTapListener)

  local function caliperTapListener()

  -- Code executed when the button is tapped
    if (caliper.alpha < 1) then
       caliperPopup.isVisible = true
    end
    caliper.alpha = 1
    instruction.isVisible = false
    ending.isVisible = true
  end

  local function caliperPopupTapListener()
    caliperPopup.isVisible = false
  end

  caliper:addEventListener("tap", caliperTapListener)
  caliperPopup:addEventListener("tap", caliperPopupTapListener)

  local function taillightTapListener()

  -- Code executed when the button is tapped
    if (taillight.alpha < 1) then
       taillightPopup.isVisible = true
    end
    taillight.alpha = 1
    instruction.isVisible = false
    ending.isVisible = true
  end

  local function taillightPopupListener() 
    -- body
    taillightPopup.isVisible = false
  end

  taillight:addEventListener("tap", taillightTapListener)
  taillightPopup:addEventListener("tap", taillightPopupListener)

  local function wheelTapListener()

  -- Code executed when the button is tapped
    if (wheel.alpha < 1) then
       wheelPopup.isVisible = true
    end
    wheel.alpha = 1
    instruction.isVisible = false
    ending.isVisible = true
  end

  local function wheelPopupTapListener()
    wheelPopup.isVisible = false
  end

  wheel:addEventListener("tap", wheelTapListener)
  wheelPopup:addEventListener("tap", wheelPopupTapListener)



startCycling:addEventListener("touch", startCyclingTapListener)

sceneGroup:insert(background)
sceneGroup:insert(instruction)
sceneGroup:insert(ending)
sceneGroup:insert(character)
sceneGroup:insert(caliper)
sceneGroup:insert(helmet)
sceneGroup:insert(taillight)
sceneGroup:insert(wheel)
sceneGroup:insert(caliperPopup)
sceneGroup:insert(helmetPopup)
sceneGroup:insert(taillightPopup)
sceneGroup:insert(wheelPopup)
sceneGroup:insert(startCycling)


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

function scene:show( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is still off screen (but is about to come on screen)
        

    elseif ( phase == "did" ) then
        -- Code here runs when the scene is entirely on screen
        --backLevel1.isVisible = true

    end
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
scene:addEventListener( "hide", scene )
scene:addEventListener( "show", scene)

return scene
--local function chooseItem(event)
--   if (event.phase == "began") then

  --end

