-----------------------------------------------------------------------------------------
--
-- level1.lua
--
-----------------------------------------------------------------------------------------


local composer = require( "composer" )
local scene = composer.newScene()

-- include Corona's "physics" library
local physics = require "physics"

local map = require "native"

--------------------------------------------

local timeElapsed = 0

local rank = 5

local obstaclesCycle = display.newGroup()

local opponentCycles = display.newGroup()

-- forward declarations and other locals
local screenW, screenH, halfW = display.actualContentWidth, display.actualContentHeight, display.contentCenterX

-- Set Variables
_W = display.contentWidth; -- Get the width of the screen
_H = display.contentHeight; -- Get the height of the screen
scrollSpeed = 2; -- Set Scroll Speed of background
-- Add First Background
local bg1 = display.newImageRect("images/level2Cycling/bicycle level 2 Street 1.png", screenW, screenH)
bg1.x = _W*0.5 + 45; bg1.y = _H/2;

-- Add Second Background
local bg2 = display.newImageRect("images/level2Cycling/bicycle level 2 Street 1.png", screenW, screenH)
bg2.x = _W*0.5+ 45; bg2.y = bg1.y+screenH;
 
-- Add Third Background
local bg3 = display.newImageRect("images/level2Cycling/bicycle level 2 Street 1.png", screenW, screenH)
bg3.x = _W*0.5+ 45; bg3.y = bg2.y+screenH;


local bg4 = display.newImageRect("images/level2Cycling/bicycle level 2 road.jpg", screenW, screenH)
bg4.x = _W*0.5 + 45; bg4.y = _H/2;
bg4.isVisible = false
-- Add Second Background
local bg5 = display.newImageRect("images/level2Cycling/bicycle level 2 road.jpg", screenW, screenH)
bg5.x = _W*0.5+ 45; bg5.y = bg4.y+screenH;
bg5.isVisible = false
-- Add Third Background
local bg6 = display.newImageRect("images/level2Cycling/bicycle level 2 road.jpg", screenW, screenH)
bg6.x = _W*0.5+ 45; bg6.y = bg5.y+screenH;
bg6.isVisible = false

local cycle = display.newImageRect("images/level2Cycling/bicycle character top view.png", 50, 50)

cycle.x, cycle.y = 250,280
cycle.name =  "cycle"
physics.addBody(cycle, "static")

local boom = display.newImageRect("boom.png", 40,40)
boom.x, boom.y = 250,255
boom.name =  "boom"
boom.isVisible = false

local finished = false

local function goLeftPosition(event)
	if(cycle.x > 212) then
		cycle.x = cycle.x - 1
		boom.x = boom.x -  1
	end
end

local function goRightPosition(event)
	if(cycle.x < 346) then
		cycle.x = cycle.x + 1
		boom.x = boom.x + 1
	end
end

local goLeft = display.newImageRect("images/level2Cycling/bicycle character top view.png", 50, 50)
goLeft.x, goLeft.y = 20,150
goLeft.name =  "buttonLeft"
goLeft.touch = goLeftPosition
goLeft:addEventListener( "touch", goLeft )


local goRight = display.newImageRect("images/level2Cycling/bicycle character top view.png", 50, 50)
goRight.x, goRight.y = 550,150
goRight.name =  "buttonRight"
goRight.touch = goRightPosition
goRight:addEventListener( "touch", goRight )

local function randomizeLane()
	local lane = {'1', '2'}
	local idx = math.random(#lane)
	local selectedLane = lane[idx]
	if(selectedLane == '1') then
		return 320
	else
		return 250
	end
end

local function randomizePlayers()
	local obstacle = {'player1','player2'}
	local idx = math.random(#obstacle)
	local selectedObstacle = obstacle[idx]
	if(selectedObstacle == 'player1') then
		local player = display.newImageRect("images/cycling level assets/obstacles/cyclists/cyclist1.png", 50, 50)
		player.x, player.y = randomizeLane(),-10
		player.name =  "op-cycle"
		physics.addBody(player)
		obstaclesCycle:insert(player)
	elseif(selectedObstacle == 'player2') then
		local player = display.newImageRect("images/cycling level assets/obstacles/cyclists/cyclist2.png", 50, 50)
		player.x, player.y = randomizeLane(),-10
		player.name =  "op-cycle"
		physics.addBody(player)
		obstaclesCycle:insert(player)
	end
end


local function spawnOpponentPlayer()
	randomizePlayers()
end

local screenLoop = 0
local done = false
local function move(event)
 -- move backgrounds to the left by scrollSpeed, default is 2
	bg1.y = bg1.y + scrollSpeed
 	bg2.y = bg2.y + scrollSpeed
 	bg3.y = bg3.y + scrollSpeed
 	bg4.y = bg4.y + scrollSpeed
 	bg5.y = bg5.y + scrollSpeed
 	bg6.y = bg6.y + scrollSpeed
 	local beatOpponentIndex = -5 
 	for i = 1, obstaclesCycle.numChildren do
		obstaclesCycle[i].y = obstaclesCycle[i].y + scrollSpeed
		if(obstaclesCycle[i].name == 'op-cycle') then
			obstaclesCycle[i].y = obstaclesCycle[i].y - 1
		end
		if(obstaclesCycle[i].name == 'op-cycle' and obstaclesCycle[i].y > screenH) then
			rank= rank- 1
			beatOpponentIndex = i
			print(rank)
		end
	end

	if(beatOpponentIndex > -1) then
		obstaclesCycle[beatOpponentIndex]:removeSelf()
		beatOpponentIndex = -5
	end

	--if (done == false) then
	--else
	--	timer.performWithDelay( 1000, showGameOver(), 1)
	--end

 -- Set up listeners so when backgrounds hits a certain point off the screen,
 -- move the background to the right off screen
	if (bg1.y + bg1.contentWidth) > 1040 then
  		bg1:translate( 0, -960 )
 		bg4:translate( 0, -960 )
  		screenLoop = screenLoop + 1

  		if(screenLoop == 4) then
  			bg1.isVisible = false
  			bg2.isVisible = false
  			bg3.isVisible = true
  			bg4.isVisible = true
  			bg5.isVisible = true
  			bg6.isVisible = false
  			done = true
  		end

 	end
 	if (bg2.y + bg2.contentWidth) > 1040 then
  		bg2:translate( 0, -960 )
  		bg5:translate( 0, -960 )
  		if(done == true)  then
  			bg6.isVisible = true
  			bg3.isVisible = false
  		end
 	end
 	if (bg3.y + bg3.contentWidth) > 1040 then
  		bg3:translate( 0, -960 )
  		bg6:translate( 0, -960 )
 	end
end

local function boomVisible(event)
	boom.isVisible = false
end

local function onCollision(event)
	if(event.phase == "began") then
		print(event.object1.name)
		print(event.object2.name)

		if(event.object1.name == "cycle" and ( (event.object2.name  == "kangaroo") or (event.object2.name  == "pothole") or (event.object2.name  == "speedBreaker") )) then
			print(event.object1.name)
			print(event.object2.name)
			if(sound == "ON") then
				--audio.play(collisionSound)
			end
			event.object2:removeSelf()
			boom.isVisible = true
			timer.performWithDelay( 800, boomVisible, 1 )
		elseif(event.object1.name == "cycle" and event.object2.name  == "bottle") then
			if(sound == "ON") then
				--audio.play(collisionSound)
			end
			event.object2:removeSelf()
		elseif(event.object1.name == "cycle" and event.object2.name  == "finishLine") then
			if(sound == "ON") then
				--audio.play(collisionSound)
			end
			event.object2:removeSelf()
			print("You win!!!!!")
		end	
	end
end


function scene:create( event )

	local sceneGroup = self.view

	-- We need physics started to add bodies, but we don't want the simulaton
	-- running until the scene is on the screen.
	physics.start()
	physics.pause()
	-- Called when the scene's view does not exist.
	-- 
	-- INSERT code here to initialize the scene
	-- e.g. add display objects to 'sceneGroup', add touch listeners, etc.
	sceneGroup:insert(bg1)
	sceneGroup:insert(bg2)
	sceneGroup:insert(bg3)
	sceneGroup:insert(bg4)
	sceneGroup:insert(bg5)	
	sceneGroup:insert(bg6)
	sceneGroup:insert(cycle)

end

local kangaroos = display.newGroup()


local function randomizeObstaclesForSuburb()
	local obstacles = {'potholes', 'speedBreaker', 'bottle'}
	local idx = math.random(#obstacles)
	local selectedObstacle = obstacles[idx]
	if(selectedObstacle == 'potholes') then
		local pothole = display.newImageRect("images/cycling level assets/obstacles/potholes/pothole.png", 50, 50)
		pothole.x, pothole.y = randomizeLane(),-10
		pothole.name =  "pothole"
		physics.addBody(pothole)
		obstaclesCycle:insert(pothole)
	elseif (selectedObstacle == 'speedBreaker') then
		local speedBreaker = display.newImageRect("images/cycling level assets/obstacles/speed-breaker/road breaker.png", 50, 50)
		speedBreaker.x, speedBreaker.y = randomizeLane(),-10
		speedBreaker.name =  "speedBreaker"
		physics.addBody(speedBreaker)
		obstaclesCycle:insert(speedBreaker)
	elseif (selectedObstacle == 'bottle') then
		local bottle = display.newImageRect("images/cycling level assets/obstacles/bottle/water bottle.png", 50, 50)
		bottle.x, bottle.y = randomizeLane(),-10
		bottle.name =  "bottle"
		physics.addBody(bottle)
		obstaclesCycle:insert(bottle)
	end
end

local function randomizeObstaclesForForest()
	local obstacles = {'kangaroo', 'potholes', 'bottle'}
	local idx = math.random(#obstacles)
	local selectedObstacle = obstacles[idx]
	if(selectedObstacle == 'potholes') then
		local pothole = display.newImageRect("images/cycling level assets/obstacles/potholes/pothole.png", 50, 50)
		pothole.x, pothole.y = randomizeLane(),-10
		pothole.name =  "pothole"
		physics.addBody(pothole)
		obstaclesCycle:insert(pothole)
	elseif (selectedObstacle == 'kangaroo') then
		local kangaroo = display.newImageRect("images/cycling level assets/obstacles/animals/kangaroo.png", 50, 50)
		kangaroo.x, kangaroo.y = randomizeLane(),-10
		kangaroo.name =  "kangaroo"
		physics.addBody(kangaroo)
		obstaclesCycle:insert(kangaroo)
	elseif (selectedObstacle == 'bottle') then
		local bottle = display.newImageRect("images/cycling level assets/obstacles/bottle/water bottle.png", 50, 50)
		bottle.x, bottle.y = randomizeLane(),-10
		bottle.name =  "bottle"
		physics.addBody(bottle)
		obstaclesCycle:insert(bottle)
	end
end


local function createObstacles()
	timeElapsed = timeElapsed + 3

	if(timeElapsed >= 18 and finished == false and timeElapsed < 40 ) then
		randomizeObstaclesForForest()
	elseif (timeElapsed < 18 and finished == false) then
		randomizeObstaclesForSuburb()
	end

	if timeElapsed > 40 and finished == false then
		finished = true
		local finishLine = display.newImageRect("images/cycling level assets/finish line/finish line.png", 200, 20)
		finishLine.x, finishLine.y = 285,-10
		finishLine.name =  "finishLine"
		physics.addBody(finishLine)
		obstaclesCycle:insert(finishLine)
	end

end


function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase
	if phase == "will" then
		-- Called when the scene is still off screen and is about to move on screen
	elseif phase == "did" then
		-- Called when the scene is now on screen
		-- 
		--print(cycle.x)
		--map.positionCamera(cycle.x,cycle.y )
		timer.performWithDelay( 3000, createObstacles, -1)
		timer.performWithDelay( 9000, spawnOpponentPlayer, 4)
		physics.setGravity( 0, 0 )

		-- INSERT code here to make the scene come alive
		-- e.g. start timers, begin animation, play audio, etc.
		physics.start()
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
		physics.stop()
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
	package.loaded[physics] = nil
	physics = nil
end

---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
-- Create a runtime event to move backgrounds
Runtime:addEventListener( "enterFrame", move )
Runtime:addEventListener("collision", onCollision)

-----------------------------------------------------------------------------------------

return scene 
















