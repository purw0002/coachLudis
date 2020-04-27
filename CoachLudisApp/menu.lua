-----------------------------------------------------------------------------------------
--
-- menu.lua
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()
local json = require( "json" )
-- include Corona's "widget" library
local widget = require "widget"

--------------------------------------------

-- forward declarations and other locals
local playBtn

musicTrack = audio.loadSound( "sound/bensound-hey.mp3")

sound = "ON"

--choice = {}
--injuryData = {}

local function networkListener( event )
 
    if ( event.isError ) then
        print( "Network error: ", event.response )
    else
    	injuryData = json.decode(event.response)
    	print(event.response)
    	choices = injuryData
		weights = {}
		for k,v in pairs(choices) do
			table.insert(weights, v["Soccer_Percentage"])
		end
    end
end


network.request( "http://localhost:3000/getsoccerinjury", "GET", networkListener)



-- 'onRelease' event listener for playBtn
local function onPlayBtnRelease()
	
	-- go to level1.lua scene
	--composer.gotoScene( "select", "fade", 500 )
	composer.prevScreen = "None"
	composer.gotoScene( "selectCharacter", "fade", 500 )
	return true	-- indicates successful touch
end

function scene:create( event )
	local sceneGroup = self.view

	-- Called when the scene's view does not exist.
	-- 
	-- INSERT code here to initialize the scene
	-- e.g. add display objects to 'sceneGroup', add touch listeners, etc.

	-- display a background image
	local background = display.newImageRect( "images/logo/starting screen.jpg", display.actualContentWidth, display.actualContentHeight )
	background.anchorX = 0
	background.anchorY = 0

	background.x = display.screenOriginX 
	background.y = display.screenOriginY
	background.touch = onPlayBtnRelease
	background:addEventListener( "touch", background )

	-- create a widget button (which will loads level1.lua on release)
	playBtn = widget.newButton{
		label="Tap to Start Game",
		labelColor = { default={0.175,0.335,0.351} },
		default="button.png",
		over="button-over.png",
		width=154, height=40,
	}
	playBtn.x = display.contentCenterX +50
	playBtn.y = display.contentHeight - 25
	
	-- all display objects must be inserted into group
	sceneGroup:insert( background )
	sceneGroup:insert( playBtn )
end

function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase
	
	if phase == "will" then
		-- Called when the scene is still off screen and is about to move on screen
		if(sound == "ON") then
			audio.play(musicTrack, { channel=1, loops=-1 })
		end
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
	local sceneGroup = self.view
	
	-- Called prior to the removal of scene's "view" (sceneGroup)
	-- 
	-- INSERT code here to cleanup the scene
	-- e.g. remove display objects, remove touch listeners, save state, etc.
	
	if playBtn then
		playBtn:removeSelf()	-- widgets must be manually removed
		playBtn = nil
	end
end

---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

-----------------------------------------------------------------------------------------

return scene