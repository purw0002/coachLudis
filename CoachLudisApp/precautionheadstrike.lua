-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------


local composer = require "composer"
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

local background1 = display.newImageRect( "headstrike/head injury page background.png", screenW, screenH )
	background1.anchorX = 0.08
	background1.anchorY = 0

local title = display.newText("Where would you call?", display.contentCenterX, 15 , native.systemFontBold, 20) 
	title:setTextColor(0)
------------------------------------------------------------------------------------------

local function selectHospital ()
	audio.stop()
	local youwin= display.newImageRect( "headstrike/Yes.png", 300 , 300 )
		youwin.x =  display.contentCenterX +190
		youwin.y = display.contentCenterY -70
	audio.play(winningSound,{ channel=2, loops=-1})
end

local function selectSchool ()
	audio.stop()
	local redcross = display.newImageRect( "headstrike/No.png", 500, 250 )
		redcross.x =  display.contentCenterX +195
		redcross.y = display.contentCenterY +75
	-- audio.play(ADD WRONG BUZZER SOUND{ channel=2, loops=-1})
end



local hospital= display.newImageRect( "headstrike/hospital.png", 140,120  )
	hospital.x =  display.contentCenterX +190
	hospital.y = display.contentCenterY -70
hospital:addEventListener( "touch", selectHospital )


local school= display.newImageRect( "headstrike/school.png", 140, 130)
	school.x =  display.contentCenterX +190
	school.y = display.contentCenterY +75
school:addEventListener( "touch", selectSchool )
