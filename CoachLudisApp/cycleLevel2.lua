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

local spawnedplay  = 0

obstaclesCycle = display.newGroup()


local injuriesOccured  = {}

physics.start()

bottles = display.newGroup()
stamina = 3
healthValue = 50

healthRectangeRed = display.newRect( 130, 20, healthValue*2, 20 ) 
healthRectangeRed:setFillColor(208, 208, 57, 1)
healthRectangeRed.x = 100
	-- health bar
healthRectangeGreen = display.newRect( 130, 20, healthValue*2, 20 ) 
healthRectangeGreen:setFillColor(1, 0, 0, 1)
healthRectangeGreen.x = 100

-- initialize the stamina
local function showBottle(stamina)

 	for i = 1, bottles.numChildren do
		bottles[i].removeSelf()
	end

	if(stamina == 4) then
		local bottle = display.newImageRect("images/cycling level assets/boost/boost symbol.png", 50, 50)
		bottle.x, bottle.y = 490,20
		local bottle1 = display.newImageRect("images/cycling level assets/boost/boost symbol.png", 50, 50)
		bottle1.x, bottle1.y = 520,20
		local bottle2 = display.newImageRect("images/cycling level assets/boost/boost symbol.png", 50, 50)
		bottle2.x, bottle2.y = 550,20
		local bottle3 = display.newImageRect("images/cycling level assets/boost/boost symbol.png", 50, 50)
		bottle3.x, bottle3.y = 580,20
		bottles:insert(bottle)
		bottles:insert(bottle1)
		bottles:insert(bottle2)
		bottles:insert(bottle3)
	elseif(stamina == 3) then
		local bottle = display.newImageRect("images/cycling level assets/boost/boost symbol.png", 50, 50)
		bottle.x, bottle.y = 490,20
		local bottle1 = display.newImageRect("images/cycling level assets/boost/boost symbol.png", 50, 50)
		bottle1.x, bottle1.y = 520,20
		local bottle2 = display.newImageRect("images/cycling level assets/boost/boost symbol.png", 50, 50)
		bottle2.x, bottle2.y = 550,20
		bottles:insert(bottle)
		bottles:insert(bottle1)
		bottles:insert(bottle2)
	elseif(stamina == 2) then
		local bottle = display.newImageRect("images/cycling level assets/boost/boost symbol.png", 50, 50)
		bottle.x, bottle.y = 490,20
		local bottle1 = display.newImageRect("images/cycling level assets/boost/boost symbol.png", 50, 50)
		bottle1.x, bottle1.y = 520,20
		bottles:insert(bottle)
		bottles:insert(bottle1)
	elseif(stamina == 1) then
		local bottle = display.newImageRect("images/cycling level assets/boost/boost symbol.png", 50, 50)
		bottle.x, bottle.y = 490,20
		bottles:insert(bottle)
	end
end
-- CAll the function
showBottle(stamina)

-- Randomizes the x axis for the obstacles
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

-- For the rank text
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

-- We have 2 types of images for players, we are randomizing these images
local function randomizePlayers()
	if spawnedplay + 1 <= 4 then
		spawnedplay = spawnedplay + 1
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
end

-- Spawns opponent players
local function spawnOpponentPlayer()
	randomizePlayers()
end

-- rank textbox
local myText = display.newText( options )
myText:setFillColor( 1, 1, 1 )

-- forward declarations and other locals
local screenW, screenH, halfW = display.actualContentWidth, display.actualContentHeight, display.contentCenterX

local function moveToRate()
	composer.gotoScene("rate","fade",500)
end
-- Game over screen
local loss = display.newImageRect( "gameOver.png", screenW, screenH )
loss.anchorX = 0
loss.anchorY = 0
loss.isVisible = false
loss:addEventListener( "touch", moveToRate )

-- Set Variables
_W = display.contentWidth; -- Get the width of the screen
_H = display.contentHeight; -- Get the height of the screen
scrollSpeed = 2; -- Set Scroll Speed of background

-- function  to stop boost 
function stopBoost()
	scrollSpeed = 2
	timer.cancel(spawnOp)
	spawnOp = timer.performWithDelay( 7000, spawnOpponentPlayer, rank - 1)
end

-- Boost function , also has a timer of 3 second(3  second  boost)
function boost(event)
	if(event.phase == "began") then
		if(stamina >  0)  then
			stamina  = stamina - 1
			bottles[stamina+1].isVisible = false
			scrollSpeed = 4
			timer.performWithDelay( 3000, stopBoost, 1)
			timer.cancel(spawnOp)
			spawnOp = timer.performWithDelay( 2000, spawnOpponentPlayer, rank - 1)
		end
	end
end

-- GO back to normal speed
function goNormal()
	scrollSpeed = 2
end

-- 3 seconds break and goNormal is invoked
function applyBreak(event)
	if(event.phase == "began") then
		scrollSpeed = 1
		timer.performWithDelay( 3000, goNormal, 1)
		
	end
end

--brakes button
local brakes = display.newImageRect("images/cycling level assets/boost/slow down button.png", 60, 60)
brakes.x, brakes.y  = 110,screenH-50
brakes:addEventListener( "touch", applyBreak )

-- nitros button
local nitros  = display.newImageRect("images/cycling level assets/boost/boost button.png", 60, 60)
nitros.x, nitros.y  = 50,screenH-50
nitros:addEventListener( "touch", boost )
-- Add First Background
bg1 = display.newImageRect("images/level2Cycling/bicycle level 2 Street 1.png", screenW, screenH)
bg1.x = _W*0.5 + 45; bg1.y = _H/2;

-- Add Second Background
bg2 = display.newImageRect("images/level2Cycling/bicycle level 2 Street 1.png", screenW, screenH)
bg2.x = _W*0.5+ 45; bg2.y = bg1.y+screenH;
 
-- Add Third Background
bg3 = display.newImageRect("images/level2Cycling/bicycle level 2 Street 1.png", screenW, screenH)
bg3.x = _W*0.5+ 45; bg3.y = bg2.y+screenH;


bg4 = display.newImageRect("images/level2Cycling/forest background.png", screenW, screenH)
bg4.x = _W*0.5 + 45; bg4.y = _H/2;
bg4.isVisible = false
-- Add Second Background
bg5 = display.newImageRect("images/level2Cycling/forest background.png", screenW, screenH)
bg5.x = _W*0.5+ 45; bg5.y = bg4.y+screenH;
bg5.isVisible = false
-- Add Third Background
bg6 = display.newImageRect("images/level2Cycling/forest background.png", screenW, screenH)
bg6.x = _W*0.5+ 45; bg6.y = bg5.y+screenH;
bg6.isVisible = false
physics.pause()
cycle = display.newImageRect("images/level2Cycling/bicycle character top view.png", 50, 50)

-- cycle, position is set  to static
cycle.x, cycle.y = 250,280
cycle.name =  "cycle"
physics.addBody(cycle, "static")

-- nitros button
boom = display.newImageRect("boom.png", 40,40)
boom.x, boom.y = 250,255
boom.name =  "boom"
boom.isVisible = false

local finished = false


screenLoop = 0
done = false

-- on crash boom is invisible after some time
local function boomVisible(event)
	boom.isVisible = false
end

local function wait()
	--spawnOp = timer.performWithDelay( 9000, spawnOpponentPlayer, rank - 1)
	scrollSpeed = 2
	collided = false
end




-- Used to move the backgroud
local function move(event)
 -- move backgrounds to the left by scrollSpeed, default is 2
	bg1.y = bg1.y + scrollSpeed
 	bg2.y = bg2.y + scrollSpeed
 	bg3.y = bg3.y + scrollSpeed
 	bg4.y = bg4.y + scrollSpeed
 	bg5.y = bg5.y + scrollSpeed
 	bg6.y = bg6.y + scrollSpeed
 	local beatOpponentIndex = -5 
 	-- Collided player would move faster the user
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






-- Similar to soccer level, board gets dissapeard on click
local function boardDissapear(event)
	event.target:removeSelf()
	local function showGameOver(loss)
		if(sound == "ON") then
			audio.stop()
			audio.play(lostTrack)
		end
		loss.isVisible = true
		--settingsButton.isVisible = false
		healthRectangeGreen.isVisible = false
		healthRectangeRed.isVisible = false
		--goLeft.isVisible = false
		--goRight.isVisible =  false
		myText.isVisible  = false
		Runtime:removeEventListener( "enterFrame", move )
		timer.cancel(createObs)
		timer.cancel(spawnOp)
		composer.stars  =  0
	end

	if(healthValue <= 20 and composer.chance == 1) then
		local idx = math.random(#injuriesOccured)
		local selectedLevel = injuriesOccured[idx]
		composer.healthValue = healthValue
		composer.chance = 0 
		print("Going to precaution")

-- By some method such as a "pause" button, show the overlay
		--composer.removeScene( "precautionOpenWound")
		composer.rank = rank
		Runtime:removeEventListener( "enterFrame", move )
		composer.timeElapsed = timeElapsed
		print(composer.timeElapsed)
		local options = {
   			effect = "fade",
    		time = 500,
    		isModal = true
		}
		composer.removeScene( selectedLevel)
		composer.showOverlay( selectedLevel, options )
			--composer.gotoScene("level3","fade",100)
	elseif(injuryBoard.param1 == nil) then
		timer.resume(event.target.params)
		timer.resume(spawnOp)
		Runtime:addEventListener( "enterFrame", move )
	else
		timer.performWithDelay( 5000, showGameOver(injuryBoard.param1), 1)
	end
end

-- Shows the inhjury board on collision
local function showInjuryBoard()
	timer.pause(createObs)
	timer.pause(spawnOp)
	Runtime:removeEventListener( "enterFrame", move )
	local totalWeight = 0
	for _, weight in pairs(weights1) do
   		totalWeight = totalWeight + weight
	end

	rand = math.random() * totalWeight
	choice = nil

	for i, weight in pairs(weights1) do
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

	if(choice["Image_name"] == 'leg fracture.png' and choice["Image_name"] == 'soft-tissue injury(leg).png' and choice["Image_name"] == 'shoulder dislocation (text).png') then
		injuriesOccured[#injuriesOccured+1] = 'level3'
	elseif(choice["Image_name"] == 'intracranial injury.png') then
		injuriesOccured[#injuriesOccured+1] = 'precautionheadstrike'
	else
		injuriesOccured[#injuriesOccured+1] = 'precautionOpenWound'
	end

	if( healthValue - choice["Severity"]/2 > 0) then
		healthValue = healthValue - choice["Severity"]/2
	else
		healthValue = 0
	end

	if (healthValue<= 0 and composer.chance == 0) then
		injuryBoard.param1 = loss
		
		healthRectangeGreen.width =  0
		Runtime:removeEventListener("collision", onCollision)
	else
		healthRectangeGreen.width =  healthValue*2
		healthRectangeGreen.x = healthRectangeGreen.x - choice["Severity"]/2
	end
	injuryBoard:addEventListener("tap", boardDissapear)
end

-- Going left (by 1 pixel)
local function goLeftPosition(event)
	if(cycle.x > 212) then
		cycle.x = cycle.x - 1
		boom.x = boom.x -  1
	end
	if(cycle.x < 213 and timeElapsed>20) then
		cycle.x = 300
		boom.x = 300
		showInjuryBoard()
		boom.isVisible = true
		timer.performWithDelay( 800, boomVisible, 1 )
		scrollSpeed = 1
		collided  =  true
		timer.performWithDelay( 3000, wait, 1)
	end
end
-- Going right (by 1 pixel)
local function goRightPosition(event)
	if(cycle.x < 346) then
		cycle.x = cycle.x + 1
		boom.x = boom.x + 1
	end
	if(cycle.x > 345 and timeElapsed>20) then
		cycle.x = 300
		boom.x = 300
		showInjuryBoard()
		boom.isVisible = true
		timer.performWithDelay( 800, boomVisible, 1 )
		scrollSpeed = 1
		collided  =  true
		timer.performWithDelay( 3000, wait, 1)
		
	end
end


-- Go left button
local goLeft = display.newImageRect("images/cycling level assets/directions/left arrow.png", 50, 50)
goLeft.x, goLeft.y = 20,150
goLeft.name =  "buttonLeft"
goLeft.touch = goLeftPosition
goLeft:addEventListener( "touch", goLeft )

-- Go right button
local goRight = display.newImageRect("images/cycling level assets/directions/right arrow.png", 50, 50)
goRight.x, goRight.y = 550,150
goRight.name =  "buttonRight"
goRight.touch = goRightPosition
goRight:addEventListener( "touch", goRight )






-- This function is used to detect collision (Here player 1 on collision with animals or obstacles obstacles would dissapear with injury board ) and player would slow down
local function onCollision(event)
	if(event.phase == "began") then
		print(event.object1.name)
		print(event.object2.name)
		if(event.object1.name == "cycle" and ( (event.object2.name  == "kangaroo") or (event.object2.name  == "pothole") or (event.object2.name  == "speedBreaker") or (event.object2.name  == "op-cycle") )) then
			if(sound == "ON") then
				--audio.play(collisionSound)
			end
			if(event.object2.name  == "speedBreaker" and scrollSpeed < 2) then
				event.object2:removeSelf()
			elseif(event.object2.name  == "op-cycle") then
				showInjuryBoard()
				boom.isVisible = true
				timer.performWithDelay( 800, boomVisible, 1 )
				scrollSpeed = 1
				collided  =  true
				timer.performWithDelay( 3000, wait, 1)
			else
				showInjuryBoard()
				event.object2:removeSelf()
				boom.isVisible = true
				timer.performWithDelay( 800, boomVisible, 1 )
				scrollSpeed = 1
				collided  =  true
				timer.performWithDelay( 3000, wait, 1)
			end

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
		elseif(((event.object1.name  == "bottle")  or (event.object1.name  == "kangaroo") or (event.object1.name  == "pothole") or (event.object1.name  == "speedBreaker") ) and event.object2.name  == "op-cycle") then
			event.object1:removeSelf()
		elseif(event.object1.name == "op-cycle" and event.object2.name  == "finishLine") then
			event.object1:removeSelf()
		elseif(event.object1.name == "finishLine" and event.object2.name == "op-cycle") then
			event.object2:removeSelf()
		end
	end
end


function scene:resumeGame()
    Runtime:addEventListener('enterFrame',move)
    --Runtime:addEventListener("collision", onCollision)
	if composer.success  ==  true then
		healthValue =  healthValue + 20
		healthRectangeGreen.width =  healthValue*2
		healthRectangeGreen.x = healthRectangeRed.x - 50 + (healthValue/2)
	end
	timer.resume(createObs)
	timer.resume(spawnOp)
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
	sceneGroup:insert(brakes)


	sceneGroup:insert(obstaclesCycle)
	sceneGroup:insert(goLeft)
	sceneGroup:insert(goRight)
	sceneGroup:insert(myText)
	sceneGroup:insert(healthRectangeRed)
	sceneGroup:insert(healthRectangeGreen)
	sceneGroup:insert(loss)
end

local kangaroos = display.newGroup()

-- Only potholes , speed-breaker and stamina available on suburbs, we r randomizing the options
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
		local speedBreaker = display.newImageRect("images/cycling level assets/obstacles/speed-breaker/road breaker.png", 200, 50)
		speedBreaker.x, speedBreaker.y = 290,-10
		speedBreaker.name =  "speedBreaker"
		physics.addBody(speedBreaker)
		obstaclesCycle:insert(speedBreaker)
	elseif (selectedObstacle == 'bottle') then
		local bottle = display.newImageRect("images/cycling level assets/boost/boost button.png", 50, 50)
		bottle.x, bottle.y = randomizeLane(),-10
		bottle.name =  "bottle"
		physics.addBody(bottle)
		obstaclesCycle:insert(bottle)
	end
end
-- Only potholes , speed-breaker, kangaroo and stamina available on suburbs, we r randomizing the options

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
		local bottle = display.newImageRect("images/cycling level assets/boost/boost symbol.png", 50, 50)
		bottle.x, bottle.y = randomizeLane(),-10
		bottle.name =  "bottle"
		physics.addBody(bottle)
		obstaclesCycle:insert(bottle)
	end
end

-- Randomizing obstacles
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
		--map.positionCamera(cycle.x,cycle.y )
		composer.game = 'cycle'
		-- First time entering the level, otherwose chance=0
		if(composer.chance == 1) then
			physics.start()
			healthValue  = 50
			stamina = 3
			createObs = timer.performWithDelay( 3000, createObstacles, -1)
			spawnOp = timer.performWithDelay( 7000, spawnOpponentPlayer, 4)
			physics.setGravity( 0, 0 )
		elseif(composer.chance == 0) then 
			--physics.start()
			--physics.setGravity( 0, 0 )
			--physics.addBody(cycle, "static")
			--print("started after precaution")
			--print(composer.timeElapsed)
			--Runtime:addEventListener( "enterFrame", move )
			--print(composer.success)
			--print(composer.healthValue)
			--if composer.success  ==  true then
			--	healthValue =  composer.healthValue + 15
			--	healthRectangeGreen.width =  healthValue*2
			--	healthRectangeGreen.x = healthRectangeGreen.x - 7.5
			--end
			--timer.resume(createObs)
			--timer.resume(spawnOp)
		end
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
		--physics.stop()
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
	Runtime:removeEventListener( "enterFrame", move )
	Runtime:removeEventListener("collision", onCollision)
	--package.loaded[physics] = nil
	--physics = nil
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




