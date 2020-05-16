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

local collided = false

local rank = 5

local obstaclesCycle = display.newGroup()

local spawnOp

local bottles = display.newGroup()
local stamina = 3
local healthValue = 50

local healthRectangeRed = display.newRect( 130, 20, healthValue*2, 20 ) 
healthRectangeRed:setFillColor(208, 208, 57, 1)
healthRectangeRed.x = 450
	-- health bar
local healthRectangeGreen = display.newRect( 130, 20, healthValue*2, 20 ) 
healthRectangeGreen:setFillColor(1, 0, 0, 1)
healthRectangeGreen.x = 450

local function reduceHealth(redHealth)
	healthValue = healthValue - (redHealth/2)
	if(healthValue <= 20) then
		--composer
		composer.gotoScene("precautionOpenWound", "fade", 100)
	end

	healthRectangeGreen.width =  healthValue*2
	healthRectangeGreen.x = healthRectangeGreen.x - (redHealth/2)
end

local function showBottle(stamina)

 	for i = 1, bottles.numChildren do
		bottles[i].removeSelf()
	end

	if(stamina == 4) then
		local bottle = display.newImageRect("images/cycling level assets/obstacles/bottle/water bottle.png", 50, 50)
		bottle.x, bottle.y = 30,20
		local bottle1 = display.newImageRect("images/cycling level assets/obstacles/bottle/water bottle.png", 50, 50)
		bottle1.x, bottle1.y = 50,20
		local bottle2 = display.newImageRect("images/cycling level assets/obstacles/bottle/water bottle.png", 50, 50)
		bottle2.x, bottle2.y = 70,20
		local bottle3 = display.newImageRect("images/cycling level assets/obstacles/bottle/water bottle.png", 50, 50)
		bottle3.x, bottle3.y = 90,20
		bottles:insert(bottle)
		bottles:insert(bottle1)
		bottles:insert(bottle2)
		bottles:insert(bottle3)
	elseif(stamina == 3) then
		local bottle = display.newImageRect("images/cycling level assets/obstacles/bottle/water bottle.png", 50, 50)
		bottle.x, bottle.y = 30,20
		local bottle1 = display.newImageRect("images/cycling level assets/obstacles/bottle/water bottle.png", 50, 50)
		bottle1.x, bottle1.y = 50,20
		local bottle2 = display.newImageRect("images/cycling level assets/obstacles/bottle/water bottle.png", 50, 50)
		bottle2.x, bottle2.y = 70,20
		bottles:insert(bottle)
		bottles:insert(bottle1)
		bottles:insert(bottle2)
	elseif(stamina == 2) then
		local bottle = display.newImageRect("images/cycling level assets/obstacles/bottle/water bottle.png", 50, 50)
		bottle.x, bottle.y = 30,20
		local bottle1 = display.newImageRect("images/cycling level assets/obstacles/bottle/water bottle.png", 50, 50)
		bottle1.x, bottle1.y = 50,20
		bottles:insert(bottle)
		bottles:insert(bottle1)
	elseif(stamina == 1) then
		local bottle = display.newImageRect("images/cycling level assets/obstacles/bottle/water bottle.png", 50, 50)
		bottle.x, bottle.y = 30,20
		bottles:insert(bottle)
	end
end

showBottle(stamina)

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


local options = 
{
    text = "Rank 5",     
    x = 480,
    y = 300,
    width = 128,
    font = native.systemFont,   
    fontSize = 18,
    align = "right"  -- Alignment parameter
}


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


local myText = display.newText( options )
myText:setFillColor( 1, 1, 1 )

-- forward declarations and other locals
local screenW, screenH, halfW = display.actualContentWidth, display.actualContentHeight, display.contentCenterX

-- Set Variables
_W = display.contentWidth; -- Get the width of the screen
_H = display.contentHeight; -- Get the height of the screen
scrollSpeed = 2; -- Set Scroll Speed of background

function stopBoost()
	scrollSpeed = 2
	timer.cancel(spawnOp)
	spawnOp = timer.performWithDelay( 7000, spawnOpponentPlayer, rank - 1)
end

function boost(event)
	if(event.phase == "began") then
		if(stamina >  0)  then
			stamina  = stamina - 1
			bottles[stamina+1].isVisible = false
			scrollSpeed = 4
			timer.performWithDelay( 3000, stopBoost, 1)
			timer.cancel(spawnOp)
			spawnOp = timer.performWithDelay( 3000, spawnOpponentPlayer, rank - 1)
		end
	end
end

local nitros  = display.newImageRect("images/cycling level assets/boost/boost button.png", 60, 60)
nitros.x, nitros.y  = 50,screenH-50
nitros:addEventListener( "touch", boost )
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

local goLeft = display.newImageRect("images/cycling level assets/directions/left arrow.png", 50, 50)
goLeft.x, goLeft.y = 20,150
goLeft.name =  "buttonLeft"
goLeft.touch = goLeftPosition
goLeft:addEventListener( "touch", goLeft )


local goRight = display.newImageRect("images/cycling level assets/directions/right arrow.png", 50, 50)
goRight.x, goRight.y = 550,150
goRight.name =  "buttonRight"
goRight.touch = goRightPosition
goRight:addEventListener( "touch", goRight )


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
			if(collided ==  true) then
				obstaclesCycle[i].y = obstaclesCycle[i].y - 1
			end
		end
		if(obstaclesCycle[i].name == 'op-cycle' and obstaclesCycle[i].y > screenH) then
			rank= rank- 1
			myText.text = "Rank "..rank
			beatOpponentIndex = i

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

local function wait()
	--spawnOp = timer.performWithDelay( 9000, spawnOpponentPlayer, rank - 1)
	scrollSpeed = 2
	collided = false
end

local function boardDissapear(event)
	event.target:removeSelf()
	local function showGameOver(loss)
		player:pause()
		if(sound == "ON") then
			audio.stop()
			audio.play(lostTrack)
		end
		loss.isVisible = true
		settingsButton.isVisible = false
		healthRectangeGreen.isVisible = false
		healthRectangeRed.isVisible = false
	end

	if(healthValue <= 20 and composer.chance == 1) then
		composer.chance = 0 
-- By some method such as a "pause" button, show the overlay
		timer.pause(createObs)
		timer.pause(spawnOp)
		--composer.removeScene( "precautionOpenWound")
		composer.gotoScene( "precautionOpenWound", "fade", 100 )
			--composer.gotoScene("level3","fade",100)
	elseif(injuryBoard.param1 == nil) then
		timer.resume(event.target.params)
		timer.resume(spawnOp)
		Runtime:addEventListener( "enterFrame", move )
		physics.start()
	else
		--timer.performWithDelay( 1000, showGameOver(injuryBoard.param1), 1)
	end
end

local function showInjuryBoard()
	timer.pause(createObs)
	timer.pause(spawnOp)
	Runtime:removeEventListener( "enterFrame", move )
	physics.pause()
	local totalWeight = 0
	for _, weight in pairs(weights) do
   		totalWeight = totalWeight + weight
	end

	rand = math.random() * totalWeight
	choice = nil

	for i, weight in pairs(weights) do
   		if rand < weight then
       		choice = choices[i]
       		break
   		else
       		rand = rand - weight
   		end
	end
	injuryBoard = display.newImageRect("images/injury window/" .. choice["Image_name"], 250,200)
	injuryBoard.x = display.contentCenterX
	injuryBoard.y = display.contentCenterY
	injuryBoard.params = createObs
	if( healthValue - choice["Severity"]/2 > 0) then
		healthValue = healthValue - choice["Severity"]/2
	else
		healthValue = 0
	end

	if (healthValue<= 0 and composer.chance == 0) then
		injuryBoard.param1 = loss

		physics.pause()
		
		healthRectangeGreen.width =  0
		Runtime:removeEventListener("collision", onCollision)
	else
		healthRectangeGreen.width =  healthValue*2
		healthRectangeGreen.x = healthRectangeGreen.x - choice["Severity"]
	end
	injuryBoard:addEventListener("tap", boardDissapear)
end



local function onCollision(event)
	if(event.phase == "began") then
		if(event.object1.name == "cycle" and ( (event.object2.name  == "kangaroo") or (event.object2.name  == "pothole") or (event.object2.name  == "speedBreaker") or (event.object2.name  == "op-cycle") )) then
			if(sound == "ON") then
				--audio.play(collisionSound)
			end

			showInjuryBoard()
			event.object2:removeSelf()
			boom.isVisible = true
			timer.performWithDelay( 800, boomVisible, 1 )
			if(rank < 5) then
				--rank = rank+1
				--myText.text = "Rank "..rank
			end
			--timer.cancel(spawnOp)
 			--for i = 1, obstaclesCycle.numChildren do
 			--	obstaclesCycle[i]:removeSelf()
			--end
			scrollSpeed = 1
			collided  =  true
			timer.performWithDelay( 3000, wait, 1)

		elseif(event.object1.name == "cycle" and event.object2.name  == "bottle") then
			if(sound == "ON") then
				--audio.play(collisionSound)
			end
			if(stamina < 3) then
				stamina = stamina + 1
				bottles[stamina].isVisible = true

			end
			event.object2:removeSelf()
		elseif(event.object1.name == "cycle" and event.object2.name  == "finishLine") then
			if(sound == "ON") then
				--audio.play(collisionSound)
			end
			event.object2:removeSelf()
			composer.stars = 0
			composer.chance = 1
			if(rank == 1) then
				composer.stars = 3
			elseif(rank  == 2) then
				composer.stars = 2
			elseif(rank ==3)  then
				composer.stars = 1
			end
			composer.removeScene('rate')
			composer.gotoScene('rate','fade', 500)
		elseif(event.object1.name == "op-cycle" and ((event.object2.name  == "bottle")  or (event.object2.name  == "kangaroo") or (event.object2.name  == "pothole") or (event.object2.name  == "speedBreaker") )) then
			event.object2:removeSelf()
		elseif(event.object1.name == "op-cycle" and event.object2.name  == "finishLine") then
			event.object1:removeSelf()
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
	sceneGroup:insert(boom)
	sceneGroup:insert(bottles)
	--sceneGroup:insert(injuryBoard)
	sceneGroup:insert(cycle)
	sceneGroup:insert(nitros)
	sceneGroup:insert(obstaclesCycle)
	sceneGroup:insert(goLeft)
	sceneGroup:insert(goRight)
	sceneGroup:insert(myText)
	sceneGroup:insert(healthRectangeRed)
	sceneGroup:insert(healthRectangeGreen)
end

local kangaroos = display.newGroup()


local function randomizeObstaclesForSuburb()
	local obstacles
	if(stamina < 3) then
		obstacles = {'potholes', 'speedBreaker', 'bottle'}
	else
		obstacles = {'potholes', 'speedBreaker'}
	end
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
	local obstacles
	if(stamina < 3) then
		obstacles = {'potholes', 'kangaroo', 'bottle'}
	else
		obstacles = {'potholes', 'kangaroo'}
	end
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
		if(composer.chance == 1) then
			createObs = timer.performWithDelay( 3000, createObstacles, -1)
			spawnOp = timer.performWithDelay( 7000, spawnOpponentPlayer, 4)
			physics.setGravity( 0, 0 )
		elseif(composer.chance == 0) then
			timer.resume(createObs)
			timer.resume(spawnOp)
		end
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
















