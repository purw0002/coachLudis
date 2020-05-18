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

local background1 = display.newImageRect( "images/headstrike/head injury page background.png", screenW, screenH )
	background1.anchorX = 0.08
	background1.anchorY = 0

local title = display.newText("Whom would you call?", display.contentCenterX, 15 , native.systemFontBold, 20) 
	title:setTextColor(0)

local correctNumber
local nineOne
local hospital
local school
local parents
local friends
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Create images

local youwin= display.newImageRect( "images/headstrike/correct.png", 150 , 150 )
	youwin.x =  display.contentCenterX +190
	youwin.y = display.contentCenterY -70
youwin.isVisible = false

local redcross = display.newImageRect( "images/headstrike/wrong.png", 150, 150 )
	redcross.x =  display.contentCenterX +195
	redcross.y = display.contentCenterY +75

local youwin1= display.newImageRect( "images/headstrike/correct.png", 150 , 150 )
	youwin1.x =  display.contentCenterX +195
	youwin1.y = display.contentCenterY +75
youwin1.isVisible = false

local redcross1 = display.newImageRect( "images/headstrike/wrong.png", 150, 150 )
	redcross1.x =  display.contentCenterX +190
	redcross1.y = display.contentCenterY -70

redcross.isVisible = false
redcross1.isVisible = false

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Event Listeners

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




local function selectHospital ()
	hospital:removeSelf()
	rightAnswers = rightAnswers + 1
	nineOne:removeSelf()
	youwin.isVisible = true
	audio.stop()
	audio.play(winningSound)
end


local function selectSchool ()
	nineOne:removeSelf()
	hospital:removeSelf()
	redcross.isVisible =true
	audio.stop()
	audio.play(wrongbuzzerSound)
end



local function selectCorrectNumber ()
	correctNumber:removeSelf()
	rightAnswers = rightAnswers + 1
	napkin:removeSelf()
	youwin.isVisible = true
	audio.stop()
	audio.play(winningSound)
end


local function selectNine ()
	wipe:removeSelf()
	correctNumber:removeSelf()
	redcross.isVisible =true
	audio.stop()
	audio.play(wrongbuzzerSound)
end




local function selectParents ()
	parents:removeSelf()
	friends:removeSelf()
	youwin.isVisible = true
	local youwin= display.newImageRect( "images/openwound/correct.png", 150 , 150 )
	youwin.x =  display.contentCenterX +190
	youwin.y = display.contentCenterY -70
	function destroyWin()
		youwin:removeSelf()
		composer.rightAnswers = rightAnswers
		composer.gotoScene( "cycleLevel2", "fade", 500 )
	end
	timer.performWithDelay( 2000, destroyWin, 1)

	rightAnswers = rightAnswers + 1
	audio.stop()
	audio.play(winningSound)
	audio.stop()
	audio.play(winningSound)
end



local function selectFriends ()
	friends:removeSelf()
	parents:removeSelf()
	redcross.isVisible =true
	local redcross = display.newImageRect( "images/openwound/wrong.png", 150, 150 )
	redcross.x =  display.contentCenterX +195
	redcross.y = display.contentCenterY +75
	function destroyLoose()
		redcross:removeSelf()
		composer.rightAnswers = rightAnswers
		composer.gotoScene( "cycleLevel2", "fade", 500 )
	end
	timer.performWithDelay( 2000, destroyLoose, 1)
	audio.stop()
	audio.play(wrongbuzzerSound)
	audio.stop()
	audio.play(wrongbuzzerSound)
end

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Load all events

local function question1()	
	
	hospital= display.newImageRect( "images/headstrike/hospital.png", 140,120  )
		hospital.x =  display.contentCenterX +190
		hospital.y = display.contentCenterY -70
	hospital:addEventListener( "touch", selectHospital )


	school= display.newImageRect( "images/headstrike/school.png", 140, 130)
		school.x =  display.contentCenterX +190
		school.y = display.contentCenterY +75
	school:addEventListener( "touch", selectSchool )
end


local function question2()
	audio.stop()
	audio.play(levelTrack, { channel=2, loops=-1})
	hospital:removeSelf()
	school:removeSelf()
	redcross.isVisible = false
	youwin.isVisible = false
	redcross1.isVisible = false
	youwin1.isVisible = false
	
	correctNumber = display.newImageRect( "headstrike/000.png", 100,45  )
		correctNumber.x =  display.contentCenterX +190
		correctNumber.y = display.contentCenterY -70
	correctNumber:addEventListener("touch", selectCorrectNumber)

	nineOne = display.newImageRect( "headstrike/911.png", 100 , 45 )
		nineOne.x =  display.contentCenterX +195
		nineOne.y = display.contentCenterY +75
	nineOne:addEventListener("touch", selectNine)
end


local function question3()
	audio.stop()
	audio.play(levelTrack, { channel=2, loops=-1})

	correctNumber:removeSelf()
	nineOne:removeSelf()
		
	redcross.isVisible = false
	youwin.isVisible = false
	redcross1.isVisible = false
	youwin1.isVisible = false
	
	friends = display.newImageRect( "images/headstrike/friend.png", 400,250  )
		friends.x =  display.contentCenterX +190
		friends.y = display.contentCenterY -80
	friends:addEventListener( "touch", selectFriends)

	parents = display.newImageRect( "images/headstrike/parents.png", 350 ,180 )
		parents.x =  display.contentCenterX +195
		parents.y = display.contentCenterY +75
	parents:addEventListener( "touch", selectParents )
end


question1()

timer.performWithDelay( 10000, question2, 1)

timer.performWithDelay( 20000, question3, 1)


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
