
local composer = require( "composer" )
local scene = composer.newScene()

--
-- GLOBALS
--
AUDIOCHANNEL_BUTTON = 1
AUDIOCHANNEL_PANEL = 2
ShakeHandler = require("Modules.handle-shake")

--
-- LOCALS
--



local WindowGame = require ("Modules.window-game")
local windowGame = nil

local ToolbarBottom = require("Modules.toolbar-bottom")
local btmBar = nil

local ToolbarTop = require("Modules.toolbar-top")
local topBar = nil

local WindowBannerAd = require ("Modules.window-bannerAd")
local bannerAd = nil

local WindowAd = require ("Modules.window-ad")
local windowAd = nil

local WindowScreenshot = require ("Modules.window-screenshot")
local windowScreenshot = nil

local SideBarLeft = require("Modules.sidebar-left")
local sideBarLeft = nil

local SideBarRight = require("Modules.sidebar-right")
local sideBarRight = nil

local SideBarBottom = require("Modules.sidebar-bottom")
local sideBarBottom = nil

local SideBarSettings = require("Modules.sidebar-settings")
local sideBarSettings = nil

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

local windowGameRect = {
    x = display.contentCenterX, 
    --y = topBarRect.y+topBarHeight/2+(btmBarRect.y-topBarRect.y-(topBarHeight+bottomBarHeight)/2)/2, 
	y = display.safeScreenOriginY + (btmBarRect.y-topBarRect.y+(topBarHeight+bottomBarHeight)/2) / 2,
	w = display.safeActualContentWidth, 
	--h = btmBarRect.y-topBarRect.y-(topBarHeight+bottomBarHeight)/2+topBarRect.h
	h = btmBarRect.y-topBarRect.y+(topBarHeight+bottomBarHeight)/2
}

local windowAdRect = {
	x = display.contentCenterX,
	y = display.contentCenterY,
	w = display.safeActualContentWidth,
	h = display.safeActualContentHeight
}

local windowScreenshotRect = {
	x = display.contentCenterX,
	y = display.contentCenterY,
	w = display.safeActualContentWidth,
	h = display.safeActualContentHeight
}

local sidebarLeftRect = {
	x = display.safeScreenOriginX + display.safeActualContentWidth*1/3,
	y = (display.safeActualContentHeight)/2 + display.safeScreenOriginY,
	w = display.safeActualContentWidth *2/3,
	h = display.safeActualContentHeight
}

local sidebarRightRect = {
	x = display.safeScreenOriginX + display.safeActualContentWidth * 2/3,
	y = (display.safeActualContentHeight)/2 + display.safeScreenOriginY,
	w = display.safeActualContentWidth *2/3,
	h = display.safeActualContentHeight
}

local sideBarBottomRect = {
	x = display.contentCenterX,
	y = (display.safeActualContentHeight)/2 + display.safeScreenOriginY,
	w = display.safeActualContentWidth,
	h = display.safeActualContentHeight
}

local sideBarSettingsRect = {
	x = display.safeScreenOriginX + display.safeActualContentWidth * 2/3,
	y = (display.safeActualContentHeight)/2 + display.safeScreenOriginY,
	w = display.safeActualContentWidth *2/3,
	h = display.safeActualContentHeight
}



--
-- Game Parameters
--

--local shakeStrength = 0
local shakesCounterTarget = 100
-- local secondsCounter = 0



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
  
	windowGame:updateForces()

end
  

--
-- event Handler: touch
--
local onTouch = function (event )
    if event.phase == "began" then
    end
	if event.phase == "ended" then
		
		if event.target and event.target.id == "btnCamera" then 
			sideBarLeft:closeFast()
			sideBarRight:closeFast()
			sideBarBottom:closeFast()
			sideBarSettings:closeFast()
			bannerAd:closeFast()
			windowScreenshot:takePicture() 
		else

			if sideBarLeft.isOpen then sideBarLeft:close() end
			if sideBarRight.isOpen then sideBarRight:close() end
			if sideBarBottom.isOpen then sideBarBottom:close() end
			if sideBarSettings.isOpen then sideBarSettings:close() end
	
			if event.target and event.target.id then print( "You pressed and released the "..event.target.id.." button!" ) end
			if event.target and event.target.id == "btnResults" then sideBarLeft:open() end
			if event.target and event.target.id == "btnBattle" then sideBarBottom:open() end
			if event.target and event.target.id == "btnStore" then sideBarRight:open() end
			if event.target and event.target.id == "btnSettings" then sideBarSettings:open() end
		
		end


		
	
	
		--return true; -- put this in your function.
    end
end

  
--------------------------------------------

function scene:create( event )

	-- Called when the scene's view does not exist.
	-- 
	-- INSERT code here to initialize the scene
	-- e.g. add display objects to 'sceneGroup', add touch listeners, etc.

	ShakeHandler:new()

	-- Display Group to insert all Scene paintings into
	local sceneGroup = self.view


	-- Create Main Game Group
	windowGame = WindowGame:new(windowGameRect.x, windowGameRect.y, windowGameRect.w, windowGameRect.h)
	--windowGame:setFillColor(0,0,0,1)

	-- Create Top Bar
	topBar = ToolbarTop:new(topBarRect.x, topBarRect.y, topBarRect.w, topBarRect.h, topBarHeight/2, topBarHeight/2)
	topBar:setFillColor(243/255, 159/255, 65/255, 0.3)
	
	-- Create Bottom Bar
	btmBar = ToolbarBottom:new(btmBarRect.x, btmBarRect.y, btmBarRect.w, btmBarRect.h, bottomBarHeight, bottomBarHeight )
	btmBar:setFillColor(243/255, 159/255, 65/255, 0.3)

	-- Create AdBanner Bar
	bannerAd = WindowBannerAd:new(bannerAdRect.x, bannerAdRect.y, bannerAdRect.w, bannerAdRect.h)
	bannerAd:setFillColor(243/255, 159/255, 65/255, 1)

	-- Create AdWindow and Hide
	windowAd = WindowAd:new(windowAdRect.x, windowAdRect.y, windowAdRect.w, windowAdRect.h)
	windowAd:hide()

	-- Create ScreenshotWindow and Hide it
	windowScreenshot = WindowScreenshot:new(windowScreenshotRect.x, windowScreenshotRect.y, windowScreenshotRect.w, windowScreenshotRect.h)
	--windowScreenshot:hide()

	-- Create Sidebar Left and Hide
	sideBarLeft = SideBarLeft:new(sidebarLeftRect.x, sidebarLeftRect.y, sidebarLeftRect.w, sidebarLeftRect.h)
	sideBarLeft:hide()

	-- Create Sidebar Right and Hide
	sideBarRight = SideBarRight:new(sidebarRightRect.x, sidebarRightRect.y, sidebarRightRect.w, sidebarRightRect.h)
	sideBarRight:hide()

	-- Create Sidebar Bottom and Hide
	sideBarBottom = SideBarBottom:new(sideBarBottomRect.x, sideBarBottomRect.y, sideBarBottomRect.w, sideBarBottomRect.h)
	sideBarBottom:hide()

	-- Create Sidebar Settings and Hide
	sideBarSettings = SideBarSettings:new(sideBarSettingsRect.x, sideBarSettingsRect.y, sideBarSettingsRect.w, sideBarSettingsRect.h)
	sideBarSettings:hide()

	-- all display objects must be inserted into group
	sceneGroup:insert( windowGame.display )
	sceneGroup:insert( topBar.display )
	sceneGroup:insert( btmBar.display )
	sceneGroup:insert( bannerAd.display )
	sceneGroup:insert( windowAd.display )
	--sceneGroup:insert( windowScreenshot.display )
	sceneGroup:insert( sideBarLeft.display )
	sceneGroup:insert( sideBarRight.display )
	sceneGroup:insert( sideBarBottom.display )
	sceneGroup:insert( sideBarSettings.display )
		
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
		ShakeHandler:show()
		Runtime:addEventListener( "enterFrame", onEnterFrame )
		Runtime:addEventListener( "touch", onTouch )
		windowGame:show()
		--sideBarLeft:show()
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
		windowGame:willHide()
		ShakeHandler:willHide(event)
		Runtime:removeEventListener( "enterFrame", onEnterFrame )
		Runtime:removeEventListener( "touch", onTouch )
		-- sidebarLeft:willHide()
		-- sideBarRight:willHide()
		-- sideBarBottom:willHide()
		-- sideBarSettings:willHide()
		-- topBar:willHide()
		-- btmBar:willHide()
		-- windowAd:willHide()
		-- bannerAd:willHide()
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
	
	ShakeHandler:destroy()
	ShakeHandler = nil

	windowGame:destroy()
	windowGame = nil
	
	btmBar:destroy()
	btmBar = nil
	
	topBar:destroy()
	topBar = nil
	
	bannerAd:destroy()
	bannerAd = nil
	
	windowAd:destroy()
	windowAd = nil
	
	windowScreenshot:destroy()
	windowScreenshot = nil
	
	sideBarLeft:destroy()
	sideBarLeft = nil
	
	sideBarRight:destroy()
	sideBarRight = nil
	
	sideBarBottom:destroy()
	sideBarBottom = nil
	
	sideBarSettings:destroy()
	sideBarSettings = nil

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