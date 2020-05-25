---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- main.lua
-- HeadStrike
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Initializing Composer

local composer = require "composer"

local scene = composer.newScene()

-- include Corona's "physics" library
local physics = require "physics"
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Screen Display H&W

local screenW = display.actualContentWidth

local screenH = display.actualContentHeight
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Loading music tracks

levelTrack = audio.loadSound( "sound/headsound/play.mp3")
winningSound = audio.loadSound( "sound/headsound/win.mp3")
wrongbuzzerSound = audio.loadSound( "sound/headsound/wrong.mp3")
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Play background music

audio.play(levelTrack, { channel=2, loops=-1})
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

local background1

if (composer.playerGender == "boy") then
	background1 = display.newImageRect( "images/headstrike/head injury page background.png", screenW, screenH )
	background1.anchorX = 0
	background1.anchorY = 0
else
	background1 = display.newImageRect( "images/headstrike/head injury page background(girl).png", screenW, screenH )
	background1.anchorX = 0
	background1.anchorY = 0
end

local title = display.newText("Whom would you call?", display.contentCenterX, 15 , native.systemFontBold, 20) 
	title:setTextColor(0)

local correctNumber
local nineOne
local hospital
local school
local parents
local friends
local rightAnswers = 0
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Create images

local youwin= display.newImageRect( "images/headstrike/correct.png", 150 , 150 )
	youwin.x =  display.contentCenterX +230
	youwin.y = display.contentCenterY -70
youwin.isVisible = false

local redcross = display.newImageRect( "images/headstrike/wrong.png", 150, 150 )
	redcross.x =  display.contentCenterX +235
	redcross.y = display.contentCenterY +75

local youwin1= display.newImageRect( "images/headstrike/correct.png", 150 , 150 )
	youwin1.x =  display.contentCenterX +235
	youwin1.y = display.contentCenterY +75
youwin1.isVisible = false

local redcross1 = display.newImageRect( "images/headstrike/wrong.png", 150, 150 )
	redcross1.x =  display.contentCenterX +230
	redcross1.y = display.contentCenterY -70

redcross.isVisible = false
redcross1.isVisible = false

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Event Listeners


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

local function makeWinDissapear()
	youwin.isVisible = false
	print(rightAnswers)
end


local function makeWin1Dissapear()
	print("diassdjkd")
	youwin1.isVisible = false
end

local function makeLooseDissapear()
	redcross.isVisible = false
end





local function selectParents (e)
	if e.phase == "began" then
		e.target:removeSelf()
		e.target.friendsObj:removeSelf()
		local youwin= display.newImageRect( "images/headstrike/correct.png", 150 , 150 )
		youwin.x =  display.contentCenterX +235
		youwin.y = display.contentCenterY +75
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



local function selectFriends (e)
	if e.phase == "began" then
		e.target:removeSelf()
		e.target.parentObj:removeSelf()
		local redcross = display.newImageRect( "images/headstrike/wrong.png", 150, 150 )
		redcross.x =  display.contentCenterX +235
		redcross.y = display.contentCenterY -70
		function destroyLoose()
			redcross:removeSelf()
			composer.rightAnswers = rightAnswers
			if(composer.game == "soccer") then
				if(rightAnswers >= 3) then
					composer.healthIncrease = 50
				else
					composer.healthIncrease = 0
				end
				composer.gotoScene( "level2", "fade", 500 )
			else
				if(rightAnswers >= 3) then
					composer.success = true
				else
					composer.success = false
				end
				composer.hideOverlay( "fade", 400 )
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
	
	friends = display.newImageRect( "images/headstrike/friend.png", 400,250  )
		friends.x =  display.contentCenterX +230
		friends.y = display.contentCenterY -80

	parents = display.newImageRect( "images/headstrike/parents.png", 350 ,180 )
		parents.x =  display.contentCenterX +235
		parents.y = display.contentCenterY +75
	
	friends.parentObj = parents
	parents.friendsObj = friends
	
	friends:addEventListener( "touch", selectFriends)
	parents:addEventListener( "touch", selectParents )
end




local function selectCorrectNumber ()
	correctNumber:removeSelf()
	rightAnswers = rightAnswers + 1
	nineOne:removeSelf()
	youwin.isVisible = true
	audio.stop()
	audio.play(winningSound)
	timer.performWithDelay(2000, question3, 1)
end


local function selectNine ()
	correctNumber:removeSelf()
	nineOne:removeSelf()
	redcross.isVisible =true
	audio.stop()
	audio.play(wrongbuzzerSound)
	timer.performWithDelay(2000, question3, 1)
end



local function question2()
	audio.stop()
	audio.play(levelTrack, { channel=2, loops=-1})
	redcross.isVisible = false
	youwin.isVisible = false
	redcross1.isVisible = false
	youwin1.isVisible = false
	
	correctNumber = display.newImageRect( "images/headstrike/000.png", 100,45  )
		correctNumber.x =  display.contentCenterX +230
		correctNumber.y = display.contentCenterY -70
	correctNumber:addEventListener("touch", selectCorrectNumber)

	nineOne = display.newImageRect( "images/headstrike/911.png", 100 , 45 )
		nineOne.x =  display.contentCenterX +235
		nineOne.y = display.contentCenterY +75
	nineOne:addEventListener("touch", selectNine)
end





local function selectHospital ()
	hospital:removeSelf()
	hospital = nil
	rightAnswers = rightAnswers + 1
	school:removeSelf()
	school = nil
	youwin.isVisible = true
	audio.stop()
	audio.play(winningSound)
	timer.performWithDelay(2000, question2, 1)
end


local function selectSchool ()
	school:removeSelf()
	hospital:removeSelf()
	redcross.isVisible =true
	audio.stop()
	audio.play(wrongbuzzerSound)
	timer.performWithDelay(2000, question2, 1)
end

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Load all events

local function question1()	
	
	hospital= display.newImageRect( "images/headstrike/hospital.png", 140,120  )
		hospital.x =  display.contentCenterX +230
		hospital.y = display.contentCenterY -70
	hospital:addEventListener( "touch", selectHospital )


	school= display.newImageRect( "images/headstrike/school.png", 140, 130)
		school.x =  display.contentCenterX +230
		school.y = display.contentCenterY +75
	school:addEventListener( "touch", selectSchool )
end



question1()


------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
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
