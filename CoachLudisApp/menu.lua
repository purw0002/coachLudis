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
local background
musicTrack = audio.loadSound( "sound/bensound-hey.mp3")
totalRequests = 0
sound = "ON"

--choice = {}
--injuryData = {}
-- We first make sure that we receive data from the backend and we insert that to a table on the app
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
		totalRequests = totalRequests + 1
		if(totalRequests == 2) then
			playBtn.isVisible =  true
			background:addEventListener( "touch", background )
		end
    end
end

local function networkListener1( event )
 
    if ( event.isError ) then
        print( "Network error: ", event.response )
    else
    	injuryData1 = json.decode(event.response)
    	print(event.response)

    	choices1 = injuryData1
		weights1 = {}
		for k,v in pairs(choices1) do
			table.insert(weights1, v["Count"])
		end
		totalRequests = totalRequests + 1
		if(totalRequests == 2) then
			playBtn.isVisible =  true
			background:addEventListener( "touch", background )
		end
    end
end


-- Used for encoding the url
function string.urlEncode( str )
 
    if ( str ) then
        str = string.gsub( str, "\n", "\r\n" )
        str = string.gsub( str, "([^%w ])",
            function( c )
                return string.format( "%%%02X", string.byte(c) )
            end
        )
        str = string.gsub( str, " ", "+" )
    end
    return str
end
local url = "https://coachludis.herokuapp.com/"
network.request( url .. string.urlEncode('getsoccerinjury'), "GET", networkListener)
network.request( url .. string.urlEncode('getcyclinginjury'), "GET", networkListener1)



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
	background = display.newImageRect( "images/logo/starting screen.jpg", display.actualContentWidth, display.actualContentHeight )
	background.anchorX = 0
	background.anchorY = 0

	background.x = display.screenOriginX 
	background.y = display.screenOriginY
	background.touch = onPlayBtnRelease

	-- create a widget button (which will loads level1.lua on release)
	playBtn = display.newImageRect( "images/logo/starting screen.png", display.actualContentWidth, display.actualContentHeight )
	playBtn.anchorX = 0
	playBtn.anchorY = 0
	playBtn.isVisible = false
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
	background:removeEventListener( "touch", background )
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