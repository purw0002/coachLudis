-----------------------------------------------------------------------------------------
-- InfoSheet
-----------------------------------------------------------------------------------------
-- Initializing Composer
local composer = require "composer"
local scene = composer.newScene()

-- include Corona's "physics" library

local physics = require "physics"
----------------------------------------------------------------------------------------
-- Loading music tracks

levelTrack = audio.loadSound( "sound/infosound/swipe.mp3")
----------------------------------------------------------------------------------------
-- Screen Display H&W

local screenW = display.actualContentWidth
local screenH = display.actualContentHeight

local backgroundimg = display.newImageRect( "images/infoimage/backgroundInfo.jpg", screenW, screenH)
	backgroundimg.anchorX = 0
	backgroundimg.anchorY = 0

local title = display.newText("Your Health Bar", display.contentCenterX, 15 , native.systemFontBold, 20) 
--	title:setTextColor(0)

local title1 = display.newText("Click on the inuries and see how much health you will loose", display.contentCenterX, 90 , native.systemFontBold, 10) 
--	title:setTextColor(0)
----------------------------------------------------------------------------------------------
-- ALL EVENTS
local Healthbar20 = display.newImageRect( "images/infoimage/Healthbar20.PNG", 350,20 )
Healthbar20.x =  display.contentCenterX +10
Healthbar20.y = display.contentCenterY -120

Healthbar20.isVisible = false


local Healthbar10 = display.newImageRect( "images/infoimage/Healthbar10.PNG", 350,20 )
Healthbar10.x =  display.contentCenterX +10
Healthbar10.y = display.contentCenterY -120

Healthbar10.isVisible =  false

local Healthbar50 = display.newImageRect( "images/infoimage/Healthbar50.PNG", 350,20 )
Healthbar50.x =  display.contentCenterX +10
Healthbar50.y = display.contentCenterY -120

Healthbar50.isVisible = false

local Healthbar30 = display.newImageRect( "images/infoimage/Healthbar30.PNG", 350,20 )
Healthbar30.x =  display.contentCenterX +10
Healthbar30.y = display.contentCenterY -120

Healthbar30.isVisible = false


local Healthbar40 = display.newImageRect( "images/infoimage/Healthbar40.PNG", 350,20 )
Healthbar40.x =  display.contentCenterX +10
Healthbar40.y = display.contentCenterY -120
Healthbar40.isVisible  =  false

local Healthbar5 = display.newImageRect( "images/infoimage/Healthbar5.PNG", 350,20 )
Healthbar5.x =  display.contentCenterX +10
Healthbar5.y = display.contentCenterY -120
--Healthbar5.isVisible  =  false

local Healthbar100 = display.newImageRect( "images/infoimage/Healthbar100.png",  350,20 )
	Healthbar100.x =  display.contentCenterX +9
	Healthbar100.y = display.contentCenterY -120
Healthbar100.isVisible =  true


local function selectFracture()
	Healthbar10.isVisible =  false
	Healthbar5.isVisible = false
	Healthbar20.isVisible =  true
	Healthbar30.isVisible = false
	Healthbar40.isVisible = false
	Healthbar50.isVisible = false
	Healthbar100.isVisible = false
	audio.play(levelTrack)
end
local function selectTissue()
	Healthbar10.isVisible =  true
	Healthbar5.isVisible = false
	Healthbar20.isVisible =  false
	Healthbar30.isVisible = false
	Healthbar40.isVisible = false
	Healthbar50.isVisible = false
	Healthbar100.isVisible = false
	audio.play(levelTrack)
end

local function selectHead()
	Healthbar10.isVisible =  false
	Healthbar5.isVisible = false
	Healthbar20.isVisible =  false
	Healthbar30.isVisible = false
	Healthbar40.isVisible = false
	Healthbar50.isVisible = true
	Healthbar100.isVisible = false
	audio.play(levelTrack)
end

local function selectOpenwound()

	Healthbar10.isVisible =  false
	Healthbar5.isVisible = false
	Healthbar20.isVisible =  false
	Healthbar30.isVisible = true
	Healthbar40.isVisible = false
	Healthbar50.isVisible = false
	Healthbar100.isVisible = false
	audio.play(levelTrack)
end

local function selectDislocation()
	Healthbar10.isVisible =  false
	Healthbar5.isVisible = false
	Healthbar20.isVisible =  false
	Healthbar30.isVisible = false
	Healthbar40.isVisible = true
	Healthbar50.isVisible = false
	Healthbar100.isVisible = false
	audio.play(levelTrack)
end

local function selectOther()
	Healthbar10.isVisible =  false
	Healthbar5.isVisible = true
	Healthbar20.isVisible =  false
	Healthbar30.isVisible = false
	Healthbar40.isVisible = false
	Healthbar50.isVisible = false
	Healthbar100.isVisible = false
	audio.play(levelTrack)
end


------------------------------------------------------------------------------------------------
-- 20
local fracture = display.newImageRect( "images/infoimage/fracture.png", 120,120 )
	fracture.x =  display.contentCenterX -185
	fracture.y = display.contentCenterY +3.5
fracture:addEventListener( "touch", selectFracture )



-- 10
local tissue= display.newImageRect( "images/infoimage/soft-tissue.png",  120,120 )
	tissue.x =  display.contentCenterX +65
	tissue.y = display.contentCenterY +105
tissue:addEventListener( "touch", selectTissue )

-- 50
local head = display.newImageRect( "images/infoimage/headstrike.png",  180,150 )
	head.x =  display.contentCenterX -20
	head.y = display.contentCenterY +2
head:addEventListener( "touch", selectHead )

-- 30
local openwound = display.newImageRect( "images/infoimage/open wound.png",  170,145 )
	openwound.x =  display.contentCenterX -100
	openwound.y = display.contentCenterY +107
openwound:addEventListener( "touch", selectOpenwound )

-- 40
local dislocation = display.newImageRect( "images/infoimage/dislocation.png",  130,135 )
	dislocation.x =  display.contentCenterX +160
	dislocation.y = display.contentCenterY +2
dislocation:addEventListener( "touch", selectDislocation )

-- 5
local other = display.newImageRect( "images/infoimage/other.png",  170,148 )
	other.x =  display.contentCenterX +235
	other.y = display.contentCenterY +105
other:addEventListener( "touch", selectOther )


--------------------------------------------------------------------------------------------
function scene:create( event )
	local sceneGroup = self.view
	sceneGroup:insert(backgroundimg)
	sceneGroup:insert(fracture)
	sceneGroup:insert(tissue)
	sceneGroup:insert(head)
	sceneGroup:insert(openwound)
	sceneGroup:insert(dislocation)
	sceneGroup:insert(other)
	sceneGroup:insert(Healthbar5)
	sceneGroup:insert(Healthbar10)
	sceneGroup:insert(Healthbar20)
	sceneGroup:insert(Healthbar30)
	sceneGroup:insert(Healthbar40)
	sceneGroup:insert(Healthbar50)
	sceneGroup:insert(Healthbar100)
	sceneGroup:insert(title)
	sceneGroup:insert(title1)
end

local function goToLevel()
	if(composer.game ==  "soccer") then
		composer.removeScene("instructionSoccer")
		composer.gotoScene( "instructionSoccer", "fade", 500 )
	else
		composer.removeScene("instructionCycle")
		composer.gotoScene( "instructionCycle", "fade", 500 )
	end
end

function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase
	
	if phase == "will" then
		timer.performWithDelay( 10000, goToLevel, 1)
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
 
    if ( phase == "will" ) then
        -- Call the "resumeGame()" function in the parent scene
        --composer.chance = 0
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

---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )




----------------------------------------------------------------------------------------
-- Set timmer

-- local timerText = display.newText( " ", 100, 100, native.systemFont, 16)
--  	timerText:translate(55,-40)
-- 	timerText:setTextColor( 255, 255, 255 )

return scene