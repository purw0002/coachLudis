-----------------------------------------------------------------------------------------
--
-- main.lua
-- InfoSheet
-----------------------------------------------------------------------------------------
-- Initializing Composer

local composer = require "composer"
----------------------------------------------------------------------------------------
-- Screen Display H&W

local screenW = display.actualContentWidth
local screenH = display.actualContentHeight

local backgroundimg = display.newImageRect( "infoimage/backgroundInfo.jpg", screenW, screenH)
	backgroundimg.anchorX = 0
	backgroundimg.anchorY = 0

-- local title = display.newText("Check", display.contentCenterX, 15 , native.systemFontBold, 20) 
--	title:setTextColor(0)

-- 20
local fracture = display.newImageRect( "infoimage/fracture.png", 110,120 )
	fracture.x =  display.contentCenterX -180
	fracture.y = display.contentCenterY +3.5

-- 10
local tissue= display.newImageRect( "infoimage/soft-tissue.png",  110,120 )
	tissue.x =  display.contentCenterX +190
	tissue.y = display.contentCenterY +105

-- 50
local head = display.newImageRect( "infoimage/headstrike.png",  110,120 )
	head.x =  display.contentCenterX -60
	head.y = display.contentCenterY +3.5

-- 30
local openwound = display.newImageRect( "infoimage/open wound.png",  140,140 )
	openwound.x =  display.contentCenterX -120
	openwound.y = display.contentCenterY +105

-- 40
local dislocation = display.newImageRect( "infoimage/dislocation.png",  110,120 )
	dislocation.x =  display.contentCenterX +190
	dislocation.y = display.contentCenterY +3.5

-- 5
local other = display.newImageRect( "infoimage/other.png",  110,120 )
	other.x =  display.contentCenterX +190
	other.y = display.contentCenterY +105

-- 5
local unspecified = display.newImageRect( "infoimage/unspecified.png",  110,120 )
	unspecified.x =  display.contentCenterX +190
	unspecified.y = display.contentCenterY +3.5

