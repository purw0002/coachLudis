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
-- Load all backgrounds
local background1

if (composer.playerGender == "boy") then
	background1 = display.newImageRect( "images/openwound/open wound page background.png", screenW, screenH )
	background1.anchorX = 0
	background1.anchorY = 0
else
	background1 = display.newImageRect( "images/openwound/open wound page background(girl).png", screenW, screenH )
	background1.anchorX = 0
	background1.anchorY = 0
end


local rightAnswers = 0

local title = display.newText("Click on the correct item", display.contentCenterX, 15 , native.systemFontBold, 20) 
	title:setTextColor(0)

local toothpaste
local iodine
local wipe
local napkin
local youwin1
--------------------------------------------------------------------------------------------------------------------
-- Create images

local youwin= display.newImageRect( "images/openwound/correct.png", 150 , 150 )
	youwin.x =  display.contentCenterX +235
	youwin.y = display.contentCenterY -70
youwin.isVisible = false

local redcross = display.newImageRect( "images/openwound/wrong.png", 150, 150 )
	redcross.x =  display.contentCenterX +230
	redcross.y = display.contentCenterY +75

youwin1= display.newImageRect( "images/openwound/correct.png", 150 , 150 )
	youwin1.x =  display.contentCenterX +230
	youwin1.y = display.contentCenterY +75

youwin1.isVisible = false

local redcross1 = display.newImageRect( "images/openwound/wrong.png", 150, 150 )
	redcross1.x =  display.contentCenterX +235
	redcross1.y = display.contentCenterY -70

redcross.isVisible = false
redcross1.isVisible = false

---------------------------------------------------------------------------------------------------------------------
-- Event Listeners

local function makeWinDissapear()
	youwin.isVisible = false
	print(rightAnswers)
end


local function makeWin1Dissapear()
	youwin1.isVisible = false
end

local function makeLooseDissapear()
	redcross.isVisible = false
end

local function goBackToPlay(e)
	if e.phase  ==  "began"  then
		e.target:removeSelf()
		if(composer.game == "soccer") then
			composer.gotoScene( "level2", "fade", 500 )
		else
			composer.hideOverlay( "fade", 400 )
		end
	end
end
local function selectBandaid (e)
	if e.phase  ==  "began"  then
		e.target:removeSelf()
		e.target.tapeObj:removeSelf()
		local youwin= display.newImageRect( "images/openwound/correct.png", 150 , 150 )
		youwin.x =  display.contentCenterX +235
		youwin.y = display.contentCenterY -70
		function destroyWin()
			youwin:removeSelf()
			composer.rightAnswers = rightAnswers
			if(composer.game == "soccer") then
				if(rightAnswers >= 3) then
					composer.healthIncrease = 50
					local fiftyBackground = display.newImageRect( "images/precaution level decrease screen/50 health.png", screenW, screenH )
					fiftyBackground.anchorX = 0
					fiftyBackground.anchorY = 0
					fiftyBackground:addEventListener( "touch", goBackToPlay )
				else
					composer.healthIncrease = 0
					local zeroBackground = display.newImageRect( "images/precaution level decrease screen/0 health.png", screenW, screenH )
					zeroBackground.anchorX = 0
					zeroBackground.anchorY = 0
					zeroBackground:addEventListener( "touch", goBackToPlay )
				end

			else
				if(rightAnswers >= 3) then
					composer.success = true
					local fiftyBackground = display.newImageRect( "images/precaution level decrease screen/50 health.png", screenW, screenH )
					fiftyBackground.anchorX = 0
					fiftyBackground.anchorY = 0
					fiftyBackground:addEventListener( "touch", goBackToPlay )
				else
					composer.success = false
					local zeroBackground = display.newImageRect( "images/precaution level decrease screen/0 health.png", screenW, screenH )
					zeroBackground.anchorX = 0
					zeroBackground.anchorY = 0
					zeroBackground:addEventListener( "touch", goBackToPlay )
				end
			end
		end
		timer.performWithDelay( 2000, destroyWin, 1)
		rightAnswers = rightAnswers + 1
		audio.stop()
		audio.play(winningSound)
	end
end



local function selecttape (e)
	if e.phase  ==  "began"  then
		e.target:removeSelf()
		e.target.bandaidObj:removeSelf()
		redcross.isVisible =true
		local redcross = display.newImageRect( "images/openwound/wrong.png", 150, 150 )
		redcross.x =  display.contentCenterX +230
		redcross.y = display.contentCenterY +75
		function destroyLoose()
			redcross:removeSelf()
			composer.rightAnswers = rightAnswers
			if(composer.game == "soccer") then
				if(rightAnswers >= 3) then
					composer.healthIncrease = 50
					local fiftyBackground = display.newImageRect( "images/precaution level decrease screen/50 health.png", screenW, screenH )
					fiftyBackground.anchorX = 0
					fiftyBackground.anchorY = 0
					fiftyBackground:addEventListener( "touch", goBackToPlay )
				else
					composer.healthIncrease = 0
					local zeroBackground = display.newImageRect( "images/precaution level decrease screen/0 health.png", screenW, screenH )
					zeroBackground.anchorX = 0
					zeroBackground.anchorY = 0
					zeroBackground:addEventListener( "touch", goBackToPlay )
				end
			else
				if(rightAnswers >= 3) then
					composer.success = true
					local fiftyBackground = display.newImageRect( "images/precaution level decrease screen/50 health.png", screenW, screenH )
					fiftyBackground.anchorX = 0
					fiftyBackground.anchorY = 0
					fiftyBackground:addEventListener( "touch", goBackToPlay )
				else
					composer.success = false
					local zeroBackground = display.newImageRect( "images/precaution level decrease screen/0 health.png", screenW, screenH )
					zeroBackground.anchorX = 0
					zeroBackground.anchorY = 0
					zeroBackground:addEventListener( "touch", goBackToPlay )
				end
			end
		end
		timer.performWithDelay( 2000, destroyLoose, 1)
		audio.stop()
		audio.play(wrongbuzzerSound)
	end
end


local function question3()
	audio.stop()
	audio.play(levelTrack, { channel=2, loops=-1})
	redcross.isVisible = false
	youwin.isVisible = false
	redcross1.isVisible = false
	youwin1.isVisible = false

	bandaid = display.newImageRect( "images/openwound/band-aid.png", 100,45  )
		bandaid.x =  display.contentCenterX +235
		bandaid.y = display.contentCenterY -70
	
	tape = display.newImageRect( "images/openwound/tape.png", 100 , 45 )
		tape.x =  display.contentCenterX +230
		tape.y = display.contentCenterY +75
	bandaid.tapeObj = tape
	tape.bandaidObj = bandaid
	bandaid:addEventListener( "touch", selectBandaid )
	tape:addEventListener( "touch", selecttape )
end




local function selectIodine (e)
	if e.phase  ==  "began"  then
		iodine:removeSelf()
		toothpaste:removeSelf()
		youwin1.isVisible = true
		rightAnswers = rightAnswers + 1
		audio.stop()
		audio.play(winningSound)
		timer.performWithDelay(2000, question3, 1)
	end
end

	
local function selectToothpaste (e)
	if e.phase  ==  "began"  then
		toothpaste:removeSelf()
		iodine:removeSelf()
		redcross1.isVisible =true

		audio.stop()
		audio.play(wrongbuzzerSound)
		timer.performWithDelay(2000, question3, 1)
	end
end


local function question2()
	audio.stop()
	audio.play(levelTrack, { channel=2, loops=-1})

	redcross.isVisible = false
	youwin.isVisible = false
	
	toothpaste = display.newImageRect( "images/openwound/toothpaste.png", 200,95  )
		toothpaste.x =  display.contentCenterX +235
		toothpaste.y = display.contentCenterY -70
	toothpaste:addEventListener( "touch", selectToothpaste )

	iodine = display.newImageRect( "images/openwound/iodine.png", 150 ,75 )
		iodine.x =  display.contentCenterX +230
		iodine.y = display.contentCenterY +75
	iodine:addEventListener( "touch", selectIodine )
end



local function selectWipe (e)
	wipe:removeSelf()
	rightAnswers = rightAnswers + 1
	napkin:removeSelf()
	youwin.isVisible = true
	audio.stop()
	audio.play(winningSound)
	timer.performWithDelay(2000, question2, 1)
end


local function selectNapkin (e)
	napkin:removeSelf()
	wipe:removeSelf()
	redcross.isVisible =true
	audio.stop()
	audio.play(wrongbuzzerSound)
	timer.performWithDelay(2000, question2, 1)
end

----------------------------------------------------------------------------------------
-- Load all events


	
local function question1()

	wipe = display.newImageRect( "images/openwound/wipe.png", 150,120  )
		wipe.x =  display.contentCenterX +235
		wipe.y = display.contentCenterY -70
	wipe:addEventListener( "touch", selectWipe )

	napkin = display.newImageRect( "images/openwound/napkin.png", 300 ,140 )
		napkin.x =  display.contentCenterX +230
		napkin.y = display.contentCenterY +75
	napkin:addEventListener( "touch", selectNapkin )
end



question1()

-------------------------------------------------------------------------------------------------------------
function scene:create( event )
	local sceneGroup = self.view
	sceneGroup:insert(background1)
	sceneGroup:insert(youwin)
	sceneGroup:insert(youwin1)	
	sceneGroup:insert(redcross)
	sceneGroup:insert(redcross1)
	sceneGroup:insert(title)
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
        if (composer.game ==  'cycle') then
        	local parent = event.parent
        	parent:resumeGame()
        end
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



return scene
----------------------------------------------------------------------------------------
-- Set timmer

-- local timerText = display.newText( " ", 100, 100, native.systemFont, 16)
--  	timerText:translate(55,-40)
-- 	timerText:setTextColor( 255, 255, 255 )
