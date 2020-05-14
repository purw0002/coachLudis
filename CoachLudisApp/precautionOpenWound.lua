-----------------------------------------------------------------------------------------
-- main.lua
---------------------------------------------------------------------------------------
-- Initializing Composer

local composer = require "composer"
----------------------------------------------------------------------------------------
-- Screen Display H&W

local screenW = display.actualContentWidth
local screenH = display.actualContentHeight
----------------------------------------------------------------------------------------
-- Loading music tracks

levelTrack = audio.loadSound( "sound/play.mp3")
winningSound = audio.loadSound( "sound/win.mp3")
-- collisionSound = audio.loadSound( "sound/injury/Concussive_Hit_Guitar_Boing.mp3")
----------------------------------------------------------------------------------------
-- Play background music

audio.play(levelTrack, { channel=2, loops=-1})
----------------------------------------------------------------------------------------
-- Load all titles



----------------------------------------------------------------------------------------
-- Load all backgrounds

local background1 = display.newImageRect( "openwound/open wound page background.png", screenW, screenH )
	background1.anchorX = 0.08
	background1.anchorY = 0

local title = display.newText("Click on the correct item", display.contentCenterX, 15 , native.systemFontBold, 20) 
	title:setTextColor(0)


local function selectBandaid ()
	audio.stop()
	local youwin= display.newImageRect( "openwound/Yes.png", 250 , 250 )
		youwin.x =  display.contentCenterX +190
		youwin.y = display.contentCenterY -70
	audio.play(winningSound,{ channel=2, loops=-1})	
end


local function selecttape ()
	audio.stop()
	local redcross = display.newImageRect( "openwound/No.png", 250, 250 )
		redcross.x =  display.contentCenterX +195
		redcross.y = display.contentCenterY +75
	-- audio.play(ADD WRONG BUZZER SOUND{ channel=2, loops=-1})
end

----------------------------------------------------------------------------------------
-- Load all events

local bandaid = display.newImageRect( "openwound/band-aid.png", 100,45  )
	bandaid.x =  display.contentCenterX +190
	bandaid.y = display.contentCenterY -70
bandaid:addEventListener( "touch", selectBandaid )




local tape = display.newImageRect( "openwound/tape icon.png", 100 , 45 )
	tape.x =  display.contentCenterX +195
	tape.y = display.contentCenterY +75
tape:addEventListener( "touch", selecttape )


----------------------------------------------------------------------------------------
-- Set timmer

local timerText = display.newText( " ", 100, 100, native.systemFont, 16)
	timerText:translate(55,-40)
	timerText:setTextColor( 255, 255, 255 )