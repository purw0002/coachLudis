-----------------------------------------------------------------------------------------
-- main.lua
---------------------------------------------------------------------------------------
-- Initializing Composer

local composer = require "composer"
----------------------------------------------------------------------------------------
-- Screen Display H&W
local scene = composer.newScene()

local screenW = display.actualContentWidth
local screenH = display.actualContentHeight
----------------------------------------------------------------------------------------
-- Loading music tracks

levelTrack = audio.loadSound( "sound/openwoundsound/play.mp3")
winningSound = audio.loadSound( "sound/openwoundsound/win.mp3")
-- collisionSound = audio.loadSound( "sound/injury/Concussive_Hit_Guitar_Boing.mp3")
----------------------------------------------------------------------------------------
-- Play background music

--audio.play(levelTrack, { channel=2, loops=-1})
----------------------------------------------------------------------------------------
-- Load all titles



----------------------------------------------------------------------------------------
-- Load all backgrounds
local redcross
local youwin

local function endLevel()
	audio.stop()

	composer.chance = 0
	bandaid = nil
	tape = nil
	--redcross = nil
	--youwin = nil
	title = nil
	background1 = nil
	composer.gotoScene("cycleLevel2",'fade', 500)
end

function scene:create( event )
	local sceneGroup = self.view


	local background1 = display.newImageRect( "images/openwound/open wound page background.png", screenW, screenH )
		background1.anchorX = 0.08
		background1.anchorY = 0

	local title = display.newText("Click on the correct item", display.contentCenterX, 15 , native.systemFontBold, 20) 
		title:setTextColor(0)


	local function selectBandaid (event)
		if(event.phase == "began") then
			audio.stop()
		--youwin= display.newImageRect( "images/openwound/Yes.png", 250 , 250 )
		--	youwin.x =  display.contentCenterX +190
		--	youwin.y = display.contentCenterY -70
	-- destroy
			audio.play(winningSound,{ channel=2, loops=-1})
			timer.performWithDelay( 2000, endLevel, 1)
		end
	end


	local function selecttape ()
		if(event.phase == "began") then
			audio.stop()
		--redcross = display.newImageRect( "images/openwound/No.png", 250, 250 )
		--	redcross.x =  display.contentCenterX +195
		--	redcross.y = display.contentCenterY +75
			timer.performWithDelay( 4000, endLevel, 1)
	-- audio.play(ADD WRONG BUZZER SOUND{ channel=2, loops=-1})
		end
	end

----------------------------------------------------------------------------------------
-- Load all events

	local bandaid = display.newImageRect( "images/openwound/band-aid.png", 100,45  )
		bandaid.x =  display.contentCenterX +190
		bandaid.y = display.contentCenterY -70
	bandaid:addEventListener( "touch", selectBandaid )




	local tape = display.newImageRect( "images/openwound/tape icon.png", 100 , 45 )
		tape.x =  display.contentCenterX +195
		tape.y = display.contentCenterY +75
	tape:addEventListener( "touch", selecttape )


----------------------------------------------------------------------------------------
-- Set timmer

	local timerText = display.newText( " ", 100, 100, native.systemFont, 16)
		timerText:translate(55,-40)
		timerText:setTextColor( 255, 255, 255 )




	--sceneGroup:insert(redcross)
	--sceneGroup:insert(youwin)
	sceneGroup:insert(title)	
	sceneGroup:insert(background1)
	sceneGroup:insert(bandaid)
	sceneGroup:insert(tape)
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
	end
end

function scene:hide( event )
	local sceneGroup = self.view
	
	local phase = event.phase
	
	if event.phase == "will" then
		-- Called when the scene is on screen and is about to move off screen
		--
		-- INSERT code here to pause the scene
		-- e.g. stop timers, stop animation, unload sounds, etc.)
	elseif phase == "did" then
		-- Called when the scene is now off screen
	end	
	
end

function scene:destroy( event )

	-- Called prior to the removal of scene's "view" (sceneGroup)
	-- 
	-- INSERT code here to cleanup the scene
	-- e.g. remove display objects, remove touch listeners, save state, etc.
	local sceneGroup = self.view
end

scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )


return scene