local composer = require("composer")
--local G = require("scripts.modules.g")

local scene = composer.newScene()
local splash

local fontName = "Assets/fonts/SHAKETHATBOOTY.ttf"
local fontSize = 50


function scene:create(event)
  local sceneGroup = self.view
  -- display a background image
	local background = display.newImageRect( "Assets/bkg-menu.png", display.actualContentWidth, display.actualContentHeight )
	background.anchorX = 0
	background.anchorY = 0
	background.x = 0 + display.screenOriginX 
	background.y = 0 + display.screenOriginY
	
	-- create/position logo/title image on upper-half of the screen
	--local titleLogo = display.newImageRect( "Assets/logo.png", 264, 42 )
  local titleLogo = display.newText(
    "ShakeShakeR", 
    display.contentCenterX, 
    display.contentCenterY,
    fontName,
    fontSize
  )
  titleLogo:setFillColor(0.5,0.5,0.5,1)
  --titleLogo.x = display.contentCenterX
  --titleLogo.y = 100


  
  sceneGroup:insert(background)
  sceneGroup:insert(titleLogo)
  
end

function scene:show(event)
  local sceneGroup = self.view
  local phase = event.phase
  if (phase == "will") then
    --splash.x = G.xm
    --splash.y = G.ym
  elseif (phase == "did") then
    -- TODO: temporarily shortened for development
    -- TODO: temporarily pointed at game scene instead
    timer.performWithDelay(2000, function() -- 1000
      --composer.gotoScene("scripts.scenes.game") -- goto menu scene after 3s
      composer.gotoScene("Scenes.game") -- goto menu scene after 3s
    end)
  end
end

function scene:hide(event)
  local sceneGroup = self.view
  local phase = event.phase
  if (phase == "will") then
  elseif (phase == "did") then
    composer.removeScene("scripts.scenes.splash", false) -- fully unload scene no recycle
  end
end

function scene:destroy(event) end
scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)
scene:addEventListener("destroy", scene)
return scene
