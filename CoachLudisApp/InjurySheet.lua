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

local backgroundimg = display.newImageRect( "image/infoimage/backgroundInfo.jpg", screenW, screenH)
	backgroundimg.anchorX = 0
	backgroundimg.anchorY = 0

local title = display.newText("Your Health Bar", display.contentCenterX, 15 , native.systemFontBold, 20) 
--	title:setTextColor(0)

local title = display.newText("Click on the inuries and see how much health you will loose", display.contentCenterX, 90 , native.systemFontBold, 10) 
--	title:setTextColor(0)
----------------------------------------------------------------------------------------------
-- ALL EVENTS

local function selectFracture()
	local Healthbar20= display.newImageRect( "image/infoimage/Healthbar20.png", 350,20 )
		Healthbar20.x =  display.contentCenterX +10
		Healthbar20.y = display.contentCenterY -120
	audio.play(levelTrack)
end


local function selectTissue()
	local Healthbar10= display.newImageRect( "image/infoimage/Healthbar10.png", 350,20 )
		Healthbar10.x =  display.contentCenterX +10
		Healthbar10.y = display.contentCenterY -120
	audio.play(levelTrack)
end

local function selectHead()
	local Healthbar50= display.newImageRect( "image/infoimage/Healthbar50.png", 350,20 )
		Healthbar50.x =  display.contentCenterX +10
		Healthbar50.y = display.contentCenterY -120
	audio.play(levelTrack)
end

local function selectOpenwound()
	local Healthbar30= display.newImageRect( "image/infoimage/Healthbar30.png", 350,20 )
		Healthbar30.x =  display.contentCenterX +10
		Healthbar30.y = display.contentCenterY -120
	audio.play(levelTrack)
end

local function selectDislocation()
	local Healthbar40= display.newImageRect( "image/infoimage/Healthbar40.png", 350,20 )
		Healthbar40.x =  display.contentCenterX +10
		Healthbar40.y = display.contentCenterY -120
	audio.play(levelTrack)
end

local function selectOther()
	local Healthbar5= display.newImageRect( "image/infoimage/Healthbar5.png", 350,20 )
		Healthbar5.x =  display.contentCenterX +10
		Healthbar5.y = display.contentCenterY -120
	audio.play(levelTrack)
end


------------------------------------------------------------------------------------------------
-- 20
local fracture = display.newImageRect( "image/infoimage/fracture.png", 120,120 )
	fracture.x =  display.contentCenterX -185
	fracture.y = display.contentCenterY +3.5
fracture:addEventListener( "touch", selectFracture )



-- 10
local tissue= display.newImageRect( "image/infoimage/soft-tissue.png",  120,120 )
	tissue.x =  display.contentCenterX +65
	tissue.y = display.contentCenterY +105
tissue:addEventListener( "touch", selectTissue )

-- 50
local head = display.newImageRect( "image/infoimage/headstrike.png",  180,150 )
	head.x =  display.contentCenterX -20
	head.y = display.contentCenterY +2
head:addEventListener( "touch", selectHead )

-- 30
local openwound = display.newImageRect( "image/infoimage/open wound.png",  170,145 )
	openwound.x =  display.contentCenterX -100
	openwound.y = display.contentCenterY +107
openwound:addEventListener( "touch", selectOpenwound )

-- 40
local dislocation = display.newImageRect( "image/infoimage/dislocation.png",  130,135 )
	dislocation.x =  display.contentCenterX +160
	dislocation.y = display.contentCenterY +2
dislocation:addEventListener( "touch", selectDislocation )

-- 5
local other = display.newImageRect( "image/infoimage/other.png",  170,148 )
	other.x =  display.contentCenterX +235
	other.y = display.contentCenterY +105
other:addEventListener( "touch", selectOther )


local healthbar100 = display.newImageRect( "image/infoimage/Healthbar100.png",  350,20 )
	healthbar100.x =  display.contentCenterX +9
	healthbar100.y = display.contentCenterY -120

--------------------------------------------------------------------------------------------
function scene:create( event )
	print("hey!")
	local sceneGroup = self.view
	sceneGroup:insert(backgroundimg)
	sceneGroup:insert(fracture)
	sceneGroup:insert(tissue)
	sceneGroup:insert(head)
	sceneGroup:insert(openwound)
	sceneGroup:insert(dislocation)
	sceneGroup:insert(other)
	sceneGroup:insert(playButton)
	sceneGroup:insert(replayButton)
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

