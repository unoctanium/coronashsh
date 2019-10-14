-----------------------------------------------------------------------------------------
--
-- level1.lua
--
-----------------------------------------------------------------------------------------

AUDIOCHANNEL_BUTTON = 1


local composer = require( "composer" )
local scene = composer.newScene()

-- include Corona's "physics" library
local physics = require "physics"
local ShakeHandler = require("Modules.handle-shake")

local ToolbarBottom = require("Modules.toolbar-bottom")
local btmBar = nil

local ToolbarTop = require("Modules.toolbar-top")
local topBar = nil

--------------------------------------------

-- forward declarations and other locals
local topBarHeight = 80
local bottomBarHeight = 80
local bannerAdHeight = 0
local topBarFontSize = 30

local topBarRect = {
    x = display.contentCenterX, 
    y = display.safeScreenOriginY+topBarHeight/2, 
    w = display.safeActualContentWidth, 
    h = topBarHeight
}

local bannerAdRect = {
	x = display.contentCenterX, 
    y = display.safeActualContentHeight+display.safeScreenOriginY-bannerAdHeight/2, 
    w = display.safeActualContentWidth, 
    h = bannerAdHeight
}

local btmBarRect = {
    x = display.contentCenterX, 
    y = display.safeActualContentHeight+display.safeScreenOriginY-bottomBarHeight/2-bannerAdHeight, 
    w = display.safeActualContentWidth, 
    h = bottomBarHeight
}

local mainDispRect = {
    x = display.contentCenterX, 
    --y = topBarRect.y+topBarHeight/2+(btmBarRect.y-topBarRect.y-(topBarHeight+bottomBarHeight)/2)/2, 
	y = display.safeScreenOriginY + (btmBarRect.y-topBarRect.y+(topBarHeight+bottomBarHeight)/2) / 2,
	w = display.safeActualContentWidth, 
	--h = btmBarRect.y-topBarRect.y-(topBarHeight+bottomBarHeight)/2+topBarRect.h
	h = btmBarRect.y-topBarRect.y+(topBarHeight+bottomBarHeight)/2
}



local particleSystem

--
-- Member vars
--


--local shakeStrength = 0
local shakesCounterTarget = 100
-- local secondsCounter = 0

local particleSystem

--------------------------------------------

--
-- event handler: enterFrame
--
local function onEnterFrame ( event )
	--snapshot:invalidate()
	
	topBar:setShakesCounter(ShakeHandler.shakesCounter)
	topBar:setSPS(ShakeHandler.shakesPerSecond)
	
	-- local secsInGame = math.floor(event.time/1000)
	-- if secsInGame > secondsCounter then
	-- 	--secondsCounterText.text = "Secs: " .. tostring(secsInGame)
	-- 	ShakeHandler.shakesPerSecond = 0
	-- 	secondsCounter = secsInGame
	-- end
  
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
  

--
-- event Handler: touch
--
local onTouch = function (event )
    if event.phase == "began" then
    end
	if event.phase == "ended" then
		if event.target and event.target.id then
			print( "You pressed and released the "..event.target.id.." button!" )
		else
			print("some touch")
		end
    end
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
	topBar = ToolbarTop:new(topBarRect.x, topBarRect.y, topBarRect.w, topBarRect.h, topBarHeight/2, topBarHeight/2)
	topBar:setFillColor(243/255, 159/255, 65/255, 0.3)
	
	-- Create Bottom Bar
	btmBar = ToolbarBottom:new(btmBarRect.x, btmBarRect.y, btmBarRect.w, btmBarRect.h, bottomBarHeight, bottomBarHeight )
	btmBar:setFillColor(243/255, 159/255, 65/255, 0.3)

	-- Create AdBanner Bar
	local bannerAd = display.newRect(bannerAdRect.x, bannerAdRect.y, bannerAdRect.w, bannerAdRect.h)
	bannerAd:setFillColor(243/255, 159/255, 65/255, 1)


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
	borderLeftSide:setFillColor(0,0,0,0)
	physics.addBody( borderLeftSide, "static" )
	local borderRightSide = display.newRect(
		mainDispRect.x + mainDispRect.w/2 + borderBoxThickness/2-0,
		mainDispRect.y, 
		borderBoxThickness, 
		mainDispRect.h 
	)
	borderRightSide:setFillColor(0,0,0,0)
	physics.addBody( borderRightSide, "static" )
	local borderTopSide = display.newRect(
		mainDispRect.x, 
		mainDispRect.y - mainDispRect.h/2 - borderBoxThickness/2+0, 
		mainDispRect.w, 
		borderBoxThickness
	)
	borderTopSide:setFillColor(0,0,0,0)
	physics.addBody( borderTopSide, "static" )
	local borderBottomSide =  display.newRect(
		mainDispRect.x, 
		mainDispRect.y + mainDispRect.h/2 + borderBoxThickness/2-0, 
		mainDispRect.w, 
		borderBoxThickness
	)
	borderBottomSide:setFillColor(0,0,0,0)
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


	-- all display objects must be inserted into group
	sceneGroup:insert( mainDisp )
	sceneGroup:insert( borderLeftSide )
	sceneGroup:insert( borderRightSide )
	sceneGroup:insert( borderBottomSide )
	sceneGroup:insert( borderTopSide )
	sceneGroup:insert( particleSystem )
	sceneGroup:insert( topBar.display )
	sceneGroup:insert( btmBar.display )
	sceneGroup:insert( bannerAd )
	
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

		-- e.g. start timers, begin animation, play audio, etc.
		physics.start()
		ShakeHandler:show(event)
		Runtime:addEventListener( "enterFrame", onEnterFrame )
		Runtime:addEventListener( "touch", onTouch )
		
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
		Runtime:removeEventListener( "touch", onTouch )
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