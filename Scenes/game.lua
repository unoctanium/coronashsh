-----------------------------------------------------------------------------------------
--
-- level1.lua
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()

-- include Corona's "physics" library
local physics = require "physics"
local ShakeHandler = require("Modules.shake-handler")

--------------------------------------------

-- forward declarations and other locals
local topBarHeight = 80
local bottomBarHeight = 80
local topBarFontSize = 20

local topBarRect = {
    x = display.contentCenterX, 
    y = display.safeScreenOriginY+topBarHeight/2, 
    w = display.safeActualContentWidth, 
    h = topBarHeight
}
local btmBarRect = {
    x = display.contentCenterX, 
    y = display.safeActualContentHeight+display.safeScreenOriginY-bottomBarHeight/2, 
    w = display.safeActualContentWidth, 
    h = bottomBarHeight
}
local mainDispRect = {
    x = display.contentCenterX, 
    y = topBarRect.y+topBarHeight/2+(btmBarRect.y-topBarRect.y-(topBarHeight+bottomBarHeight)/2)/2, 
    w = display.safeActualContentWidth, 
    h = btmBarRect.y-topBarRect.y-(topBarHeight+bottomBarHeight)/2
}

local particleSystem

--
-- Member vars
--
local shakesCounterText = nil
local secondsCounterText = nil
local shakesPerSecondText = nil

local shakeStrength = 0
local shakesCounterTarget = 100
local secondsCounter = 0

local particleSystem

--------------------------------------------

--
-- event handler: enterFrame
--
local function onEnterFrame ( event )
	--snapshot:invalidate()
	local secsInGame = math.floor(event.time/1000)
	if secsInGame > secondsCounter then
	  shakesCounterText.text = "Count: " .. tostring(ShakeHandler.shakesCounter)
	  shakesPerSecondText.text = "SpS: " .. tostring(ShakeHandler.shakesPerSecond)
	  ShakeHandler.shakesPerSecond = 0
	  secondsCounter = secsInGame
	  secondsCounterText.text = "Secs: " .. tostring(secondsCounter)
	end
  
	--shakeStrength = ShakeHandler:getShakeStrength()
	--print(shakeStrength)
	-- do something with shakeStrength
	-- local yForce = -math.abs(shakeStrength) 
	-- particleSystem:applyForce( 0, yForce *2)
  
	-- local ax, ay, az = ShakeHandler:getAccel()
	-- particleSystem:applyForce( ax*ax*ax * 40, ay*ay*ay * 40)

	-- local gx, gy, gz = ShakeHandler:getGravity()
	-- physics.setGravity( gx*20, -gy*20)

	local gx, gy, gz = ShakeHandler:getGravity()
	--local ax, ay, az = ShakeHandler:getAccel()
	physics.setGravity( gx*20, -gy*20 + (ShakeHandler.shakesPerSecond/5))


  
  end
  
  
--------------------------------------------

function scene:create( event )

	-- Called when the scene's view does not exist.
	-- 
	-- INSERT code here to initialize the scene
	-- e.g. add display objects to 'sceneGroup', add touch listeners, etc.
	ShakeHandler:create(event)

	-- Display Group to insert all Scene paintings into
	local sceneGroup = self.view

	-- We need physics started to add bodies, but we don't want the simulaton
	-- running until the scene is on the screen.
	physics.start()
	physics.setGravity( 0, 10)
	physics.setDrawMode( "normal" )
	physics.pause()

	-- Create Top Bar
	local topBar = display.newRect(topBarRect.x, topBarRect.y, topBarRect.w, topBarRect.h)
	topBar:setFillColor(243/255, 159/255, 65/255, 1)
	
	-- Top Bar HUD
	-- DRAFT
    shakesCounterText = display.newText(
		"Count: 0", 
		topBarRect.x-topBarRect.w*2/8, topBarRect.y-topBarRect.h*2/8, 
		native.systemFont, topBarFontSize 
	)
    shakesCounterText:setFillColor( 0,0,0,1 )
    secondsCounterText = display.newText(
		"Secs: 0", 
		topBarRect.x-topBarRect.w*2/8, topBarRect.y+topBarRect.h*2/8, 
		native.systemFont, topBarFontSize 
	)
    secondsCounterText:setFillColor( 0,0,0,1)
	shakesPerSecondText = display.newText(
		"SpS: 0", 
		topBarRect.x+topBarRect.w*3/8, topBarRect.y-topBarRect.h*2/8, 
		native.systemFont, topBarFontSize 
	)
    shakesPerSecondText:setFillColor( 0,0,0,1 )

	-- Create Bottom Bar
	local btmBar = display.newRect(btmBarRect.x, btmBarRect.y, btmBarRect.w, btmBarRect.h)
	btmBar:setFillColor(1,1,0)
	
	-- Bottom Bar Icons
	--DRAFT
	local iconWidth, iconHeight = btmBarRect.w/4, bottomBarHeight
	local btmBarIcon1 = display.newRect(
		btmBarRect.x-iconWidth*3/2,
		btmBarRect.y,
		iconWidth,
		iconHeight
	)
	btmBarIcon1:setFillColor(1,0,0,1)
	local btmBarIcon2 = display.newRect(
		btmBarRect.x-iconWidth*1/2,
		btmBarRect.y,
		iconWidth,
		iconHeight
	)
	btmBarIcon2:setFillColor(0,1,0,1)
	local btmBarIcon3 = display.newRect(
		btmBarRect.x+iconWidth*1/2,
		btmBarRect.y,
		iconWidth,
		iconHeight
	)
	btmBarIcon3:setFillColor(0,0,1,1)
	local btmBarIcon4 = display.newRect(
		btmBarRect.x+iconWidth*3/2,
		btmBarRect.y,
		iconWidth,
		iconHeight
	)
	btmBarIcon4:setFillColor(1,1,0,1)

	-- Crate Main Display for liquid display
	local mainDisp = display.newRect(mainDispRect.x, mainDispRect.y, mainDispRect.w, mainDispRect.h)
	mainDisp:setFillColor(0,0,1,0.5)
	mainDisp.fill.effect = "generator.checkerboard"
	mainDisp.fill.effect.color1 = { 0.2, 0.4, 0.8, 1 }
	mainDisp.fill.effect.color2 = { 0.6, 0.6, 0.8, 1 }
	mainDisp.fill.effect.xStep = 8
	mainDisp.fill.effect.yStep = 8
	
	-- create the physics border boxes for the liquid (invisible)
	local borderBoxThickness = 60

	local borderLeftSide = display.newRect(
		mainDispRect.x - mainDispRect.w/2 - borderBoxThickness/2+0, 
		mainDispRect.y, 
		borderBoxThickness, 
		mainDispRect.h 
	)
	borderLeftSide:setFillColor(1,1,1,0.3)
	physics.addBody( borderLeftSide, "static" )
	local borderRightSide = display.newRect(
		mainDispRect.x + mainDispRect.w/2 + borderBoxThickness/2-0,
		mainDispRect.y, 
		borderBoxThickness, 
		mainDispRect.h 
	)
	borderRightSide:setFillColor(1,1,1,0.3)
	physics.addBody( borderRightSide, "static" )
	local borderTopSide = display.newRect(
		mainDispRect.x, 
		mainDispRect.y - mainDispRect.h/2 - borderBoxThickness/2+0, 
		mainDispRect.w, 
		borderBoxThickness
	)
	borderTopSide:setFillColor(1,1,1,0.3)
	physics.addBody( borderTopSide, "static" )
	local borderBottomSide =  display.newRect(
		mainDispRect.x, 
		mainDispRect.y + mainDispRect.h/2 + borderBoxThickness/2-0, 
		mainDispRect.w, 
		borderBoxThickness
	)
	borderBottomSide:setFillColor(1,1,1,0.3)
	physics.addBody( borderBottomSide, "static" )

	-- Create a liquid fun Particle System
	particleSystem = physics.newParticleSystem{
		filename = "Assets/particle-liquid-1.png",
		radius = 3, --18,
		imageRadius = 4, --30,
		gravityScale = 1.0,
		strictContactCheck = true
	  }
  
	-- Create a "block" of water (LiquidFun group)
	particleSystem:createGroup(
	  {
		  flags = { "tensile" }, --tensile, water
		  x = mainDispRect.x,
		  y = mainDispRect.y,
		  color = { 0.9, 0.2, 0.2, 1},
		  halfWidth = 138,
		  halfHeight = 220
	  }
	)


	-- all display objects must be inserted into group
	sceneGroup:insert( mainDisp )
	sceneGroup:insert( borderLeftSide )
	sceneGroup:insert( borderRightSide )
	sceneGroup:insert( borderBottomSide )
	sceneGroup:insert( borderTopSide )
	sceneGroup:insert( topBar )
	sceneGroup:insert( shakesCounterText )
	sceneGroup:insert( secondsCounterText )
	sceneGroup:insert( shakesPerSecondText )
	sceneGroup:insert( btmBar )
	sceneGroup:insert( btmBarIcon1 )
	sceneGroup:insert( btmBarIcon2 )
	sceneGroup:insert( btmBarIcon3 )
	sceneGroup:insert( btmBarIcon4 )
	
end


--------------------------------------------

function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase
	
	if phase == "will" then
		-- Called when the scene is still off screen and is about to move on screen
	elseif phase == "did" then
		-- Called when the scene is now on screen
		-- 
		-- INSERT code here to make the scene come alive

-- -- Initialize snapshot for mainDisp since we want to put effects on in
-- snapshot = display.newSnapshot( sceneGroup, mainDispRect.w, mainDispRect.h )
-- local snapshotGroup = snapshot.group
-- snapshot.x = mainDispRect.x
-- snapshot.y = mainDispRect.y
-- snapshot.canvasMode = "discard"
-- snapshot.alpha = 0.8
-- -- Apply filter to MainDisp
-- snapshot.fill.effect = "filter.sobel"
-- --snapshot.fill.effect = "filter.blur"
-- -- Insert the particle system into the snapshot
-- snapshotGroup:insert( particleSystem )
-- snapshotGroup.x = -mainDispRect.w/2
-- snapshotGroup.y = -mainDispRect.h/2
-- -- Remember to invalidate Snapshot in onEnterFrame Event Handler


		-- e.g. start timers, begin animation, play audio, etc.
		physics.start()
		ShakeHandler:show(event)
		Runtime:addEventListener( "enterFrame", onEnterFrame )
	end
end

--------------------------------------------

function scene:hide( event )
	local sceneGroup = self.view
	
	local phase = event.phase
	
	if event.phase == "will" then
		-- Called when the scene is on screen and is about to move off screen
		--
		-- INSERT code here to pause the scene
		-- e.g. stop timers, stop animation, unload sounds, etc.)
		Runtime:removeEventListener( "enterFrame", onEnterFrame )
		ShakeHandler:hide(event)
		physics.stop()
	elseif phase == "did" then
		-- Called when the scene is now off screen
	end	
	
end

--------------------------------------------

function scene:destroy( event )

	-- Called prior to the removal of scene's "view" (sceneGroup)
	-- 
	-- INSERT code here to cleanup the scene
	-- e.g. remove display objects, remove touch listeners, save state, etc.
	local sceneGroup = self.view
	
	package.loaded[physics] = nil
	physics = nil
	ShakeHandler:destroy(event)
	ShakeHandler = nil
end

---------------------------------------------------------------------------------


-- Handle unhandled errors

local function myUnhandledErrorListener( event ) 
	local iHandledTheError = true
	if iHandledTheError then
		print( "Handling the unhandled error", event.errorMessage )
	else
		print( "Not handling the unhandled error", event.errorMessage )
	end
	return iHandledTheError
  end
  Runtime:addEventListener("unhandledError", myUnhandledErrorListener)
  


---------------------------------------------------------------------------------


-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

-----------------------------------------------------------------------------------------

return scene