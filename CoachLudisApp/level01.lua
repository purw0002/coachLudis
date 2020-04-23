-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- Your code here

local composer = require "composer"
local scene = composer.newScene()
local injury
local physics = require "physics" 


function scene:create(event)

  local sceneGroup = self.view

display.setStatusBar(display.HiddenStatusBar)



--physics.setDrawMode("normal")

local text = display.newText(sceneGroup, "Tap the blue boy", 100, 120, native.systemFont, 16)
text:setFillColor(1, 0.2, 0.2)

local background = display.newImageRect(sceneGroup, "soccer field.jpg", 480, 320)
   background.x = display.contentCenterX
   background.y = display.contentCenterY

local platform = display.newImageRect(sceneGroup, "grass ground.png", 480, 40)
   platform.x = display.contentCenterX
   platform.y = display.contentHeight-10
   physics.addBody(platform, "static")

local soccer = display.newImageRect(sceneGroup, "soccer1.png", 32, 32 )
   soccer.myName = "football"
   soccer.x = display.contentCenterX
   soccer.y = display.contentCenterY-50
   --soccer.alpha = 1
   --soccer:scale(0.3, 0.3)
   physics.addBody(soccer, "static")

local player1 = display.newImageRect(sceneGroup, "jump(boy1).png", 68, 110)
   player1.myName = "player1"
   player1.x = display.contentCenterX
   player1.y = platform.y-40
   --player:scale(0.75, 0.75)
   physics.addBody(player1, "dynamic")

local player2 = display.newImageRect(sceneGroup, "jump(boy2).png", 68, 110)
   player2.myName = "player2"
   player2.x = display.contentCenterX
   player2.y = platform.y-40
   physics.addBody(player2, "dynamic")

local function displayGameOver()
	-- body
    local gameOver = display.newImageRect("game over.png", 800, 800)  
      gameOver.x = display.contentCenterX
      gameOver.y = display.contentCenterY
end

--ocal function winTheLevel()
   -- local levelCompleted = display.newImageRect("level complete.png", 189, 141)
     -- levelCompleted.x = display.contentCenterX
      --levelCompleted.y = display.contentCenterY
--end

--local win = display.newImageRect( "celebration.png", display.actualContentWidth, display.actualContentHeight )

--local function showRatings()
    --composer.stars = 3
    --composer.gotoScene( "rate", "fade", 500 )
--end

--win.anchorX = 0
--win.anchorY = 0
--win.isVisible = false
--win.touch = showRatings
--win:addEventListener( "touch", win )

local function showWin()
    win.isVisible = true
  end

local function onJump( event )
	-- body
	if (event.phase == "began") then
		player1:setLinearVelocity(0, -200)
    player2:setLinearVelocity(0, -100)
	end
end


local function crash()
	if (secondsLeft == 0) then
    injury = display.newImageRect("boom.png")
    injury.x = player.x-5
    injury.y = player.y-5
    end
end

player1:addEventListener("touch", onJump)

local secondsLeft = 10  
 
local sheetOptions = {
    frames = {
        { x=0, y=0, width=24, height=48 },    -- 1
        { x=24, y=0, width=34, height=48 },   -- 2
        { x=58, y=0, width=28, height=48 },   -- 3
        { x=86, y=0, width=36, height=48 },   -- 4
        { x=122, y=0, width=30, height=48 },  -- 5
        { x=152, y=0, width=38, height=48 },  -- 6
        { x=190, y=0, width=34, height=48 },  -- 7
        { x=224, y=0, width=36, height=48 },  -- 8
        { x=260, y=0, width=38, height=48 },  -- 9
        { x=298, y=0, width=40, height=48 },  -- 0
        { x=338, y=0, width=22, height=48 }   -- :
    },
    sheetContentWidth = 360,
    sheetContentHeight = 48
}
local sheet = graphics.newImageSheet("timer-digits.png", sheetOptions )

local digitSequence = { name="digits", start=1, count=11 }
 
local colon = display.newSprite(sheet, digitSequence )
colon.x, colon.y = display.contentCenterX+150, 80
colon:setFrame( 11 )

local minutesSingle = display.newSprite(sceneGroup, sheet, digitSequence )
minutesSingle.x, minutesSingle.y = 0, 80
minutesSingle.anchorX = 1
 
local minutesDouble = display.newSprite(sceneGroup, sheet, digitSequence )
minutesDouble.x, minutesDouble.y = 0, 80
minutesDouble.anchorX = 1
 
local secondsDouble = display.newSprite(sceneGroup, sheet, digitSequence )
secondsDouble.x, secondsDouble.y = 0, 80
secondsDouble.anchorX = 0
 
local secondsSingle = display.newSprite(sceneGroup, sheet, digitSequence )
secondsSingle.x, secondsSingle.y = 0, 80
secondsSingle.anchorX = 0

local function updateTime( event )
 
    if ( event ~= "init" ) then
    -- Decrement the number of seconds
    secondsLeft = secondsLeft - 1
    end

    -- Time is tracked in seconds; convert it to minutes and seconds
    local minutes = math.floor( secondsLeft / 60 )
    local seconds = secondsLeft % 60
 
    -- Make it a formatted string
    local timeDisplay = string.format( "%02d:%02d", minutes, seconds )
     
    -- Update the text object
    -- Get the individual new value of each element in time display
    local md = tonumber( string.sub( timeDisplay, 1, 1 ) )
    local ms = tonumber( string.sub( timeDisplay, 2, 2 ) )
    local sd = tonumber( string.sub( timeDisplay, 4, 4 ) )
    local ss = tonumber( string.sub( timeDisplay, 5, 5 ) )
    if ( md == 0 ) then minutesDouble:setFrame( 10 ) else minutesDouble:setFrame( md ) end
    if ( ms == 0 ) then minutesSingle:setFrame( 10 ) else minutesSingle:setFrame( ms ) end
    if ( sd == 0 ) then secondsDouble:setFrame( 10 ) else secondsDouble:setFrame( sd ) end
    if ( ss == 0 ) then secondsSingle:setFrame( 10 ) else secondsSingle:setFrame( ss ) end
 
    -- Reposition digits around central colon
    minutesSingle.x = colon.contentBounds.xMin
    minutesDouble.x = minutesSingle.contentBounds.xMin
    secondsDouble.x = colon.contentBounds.xMax
    secondsSingle.x = secondsDouble.contentBounds.xMax
end

updateTime( "init" )
local countDownTimer = timer.performWithDelay( 1000, updateTime, secondsLeft )



local function soccerCollision(self, event )
	if(event.phase == "began") then
		--composer.gotoScene()
		timer.cancel(countDownTimer)
    --showWin()
    composer.stars = 3
    composer.gotoScene( "rate", "fade", 500 )
	end
end

soccer.collision = soccerCollision
soccer:addEventListener("collision", soccer)

sceneGroup:insert(background)
sceneGroup:insert(platform)
sceneGroup:insert(soccer)
sceneGroup:insert(player1)
sceneGroup:insert(player2)
sceneGroup:insert(colon)
sceneGroup:insert(text)
sceneGroup:insert(minutesSingle)
sceneGroup:insert(minutesDouble)
sceneGroup:insert(secondsDouble)
sceneGroup:insert(secondsSingle)

end

function scene:show(event)
  local phase = event.phase
  if(phase == "will") then

  elseif(phase == "did") then
    physics.start()
    physics.setGravity(0, 9.8)
  end
end

scene:addEventListener("create")
scene:addEventListener("show")

return scene