------------------------------------------------------------------------------------------
-- Open wound Level
---------------------------------------------------------------------------------------
-- Initializing Composer
local composer = require "composer"
local scene = composer.newScene()

-- include Corona's "physics" library

local physics = require "physics"


----------------------------------------------------------------------------------------
-- Screen Display H&W

local screenW = display.actualContentWidth
local screenH = display.actualContentHeight
----------------------------------------------------------------------------------------
-- Loading music tracks

levelTrack = audio.loadSound( "sound/openwound/play.mp3")
winningSound = audio.loadSound( "sound/openwound/win.mp3")
wrongbuzzerSound = audio.loadSound( "sound/openwound/wrong.mp3")
----------------------------------------------------------------------------------------
-- Play background music

audio.play(levelTrack, { channel=2, loops=-1})
----------------------------------------------------------------------------------------
-- Load all titles

local timerText = display.newText( " ", 100, 100, native.systemFont, 16)
	timerText:translate(55,-40)
	timerText:setTextColor( 255, 255, 255 )

----------------------------------------------------------------------------------------
-- Load all backgrounds

local background1 = display.newImageRect( "images/openwound/open wound page background.png", screenW, screenH )
	background1.anchorX = 0.08
	background1.anchorY = 0



local title = display.newText("Click on the correct item", display.contentCenterX, 15 , native.systemFontBold, 20) 
	title:setTextColor(0)

local toothpaste
local iodine
--------------------------------------------------------------------------------------------------------------------
-- Create images

local youwin= display.newImageRect( "images/openwound/correct.png", 150 , 150 )
	youwin.x =  display.contentCenterX +190
	youwin.y = display.contentCenterY -70
youwin.isVisible = false

local redcross = display.newImageRect( "images/openwound/wrong.png", 150, 150 )
	redcross.x =  display.contentCenterX +195
	redcross.y = display.contentCenterY +75

local youwin1= display.newImageRect( "images/openwound/correct.png", 150 , 150 )
	youwin1.x =  display.contentCenterX +195
	youwin1.y = display.contentCenterY +75

youwin1.isVisible = false

local redcross1 = display.newImageRect( "images/openwound/wrong.png", 150, 150 )
	redcross1.x =  display.contentCenterX +190
	redcross1.y = display.contentCenterY -70

redcross.isVisible = false
redcross1.isVisible = false

---------------------------------------------------------------------------------------------------------------------
-- Event Listeners

local function selectBandaid ()
	youwin.isVisible = true
	audio.stop()
	audio.play(winningSound)
end


local function selecttape ()
	redcross.isVisible =true
	audio.stop()
	audio.play(wrongbuzzerSound)
end


local function selectWipe ()
	youwin.isVisible = true
	audio.stop()
	audio.play(winningSound)
end


local function selectNapkin ()
	redcross.isVisible =true
	audio.stop()
	audio.play(wrongbuzzerSound)
end


local function selectIodine ()
	youwin1.isVisible = true
	audio.stop()
	audio.play(winningSound)
end

	
local function selectToothpaste ()
	redcross1.isVisible =true
	audio.stop()
	audio.play(wrongbuzzerSound)
end

----------------------------------------------------------------------------------------
-- Load all events


	
local function question1()
	wipe = display.newImageRect( "images/openwound/wipe.png", 150,120  )
		wipe.x =  display.contentCenterX +190
		wipe.y = display.contentCenterY -70
	wipe:addEventListener( "touch", selectWipe )

	napkin = display.newImageRect( "images/openwound/napkin.png", 300 ,140 )
		napkin.x =  display.contentCenterX +195
		napkin.y = display.contentCenterY +75
	napkin:addEventListener( "touch", selectNapkin )
end

	
local function question2()
	audio.stop()
	audio.play(levelTrack, { channel=2, loops=-1})

	wipe:removeSelf()
	napkin:removeSelf()
		
	redcross.isVisible = false
	youwin.isVisible = false
	
	toothpaste = display.newImageRect( "images/openwound/toothpaste.png", 200,95  )
		toothpaste.x =  display.contentCenterX +190
		toothpaste.y = display.contentCenterY -70
	toothpaste:addEventListener( "touch", selectToothpaste )

	iodine = display.newImageRect( "images/openwound/iodine.png", 150 ,75 )
		iodine.x =  display.contentCenterX +195
		iodine.y = display.contentCenterY +75
	iodine:addEventListener( "touch", selectIodine )
end

local function question3()
	audio.stop()
	audio.play(levelTrack, { channel=2, loops=-1})

	toothpaste:removeSelf()
	iodine:removeSelf()

	redcross.isVisible = false
	youwin.isVisible = false
	
	local bandaid = display.newImageRect( "images/openwound/band-aid.png", 100,45  )
		bandaid.x =  display.contentCenterX +190
		bandaid.y = display.contentCenterY -70
	bandaid:addEventListener( "touch", selectBandaid )
	
	local tape = display.newImageRect( "images/openwound/tape.png", 100 , 45 )
		tape.x =  display.contentCenterX +195
		tape.y = display.contentCenterY +75
	tape:addEventListener( "touch", selecttape )
end

timer.performWithDelay( 0000, question1, 1)

timer.performWithDelay( 10000, question2, 1)

timer.performWithDelay( 20000, question3, 1)

-------------------------------------------------------------------------------------------------------------
function scene:create( event )
	print("hey!")
	local sceneGroup = self.view
	sceneGroup:insert(background1)
	sceneGroup:insert(napkin)
	sceneGroup:insert(wipe)
	sceneGroup:insert(toothpaste)
	sceneGroup:insert(iodine)
	sceneGroup:insert(bandaid)
	sceneGroup:insert(tape)
	sceneGroup:insert(youwin)
	sceneGroup:insert(youwin1)	
	sceneGroup:insert(redcross)
	sceneGroup:insert(redcross1)
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
