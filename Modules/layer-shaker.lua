local M = {}

-- include Corona's "physics" library
local physics = require "physics"


local particleSystem

M.display = nil

function M:new (x,y,w,h)
    M.display = display.newGroup()

	-- We need physics started to add bodies, but we don't want the simulaton
	-- running until the scene is on the screen.
	physics.start()
	physics.setGravity( 0, 10)
	physics.setDrawMode( "normal" )
    physics.pause()
    
    -- create the physics border boxes for the liquid (invisible)
    local borderBoxThickness = 20

    local borderLeftSide = display.newRect(
        x - w/2 - borderBoxThickness/2+0, 
        y, 
        borderBoxThickness, 
        h 
    )
    borderLeftSide:setFillColor(0,0,0,0)
    physics.addBody( borderLeftSide, "static" )
    local borderRightSide = display.newRect(
        x + w/2 + borderBoxThickness/2-0,
        y, 
        borderBoxThickness, 
        h 
    )
    borderRightSide:setFillColor(0,0,0,0)
    physics.addBody( borderRightSide, "static" )
    local borderTopSide = display.newRect(
        x, 
        y - h/2 - borderBoxThickness/2+0, 
        w, 
        borderBoxThickness
    )
    borderTopSide:setFillColor(0,0,0,0)
    physics.addBody( borderTopSide, "static" )
    local borderBottomSide =  display.newRect(
        x, 
        y + h/2 + borderBoxThickness/2-0, 
        w, 
        borderBoxThickness
    )
    borderBottomSide:setFillColor(0,0,0,0)
    physics.addBody( borderBottomSide, "static" )



	-- Create a liquid fun Particle System
	particleSystem = physics.newParticleSystem{
        filename = "Assets/particle-liquid-1.png",
        colorMixingStrength = 0.01,
        radius = 4,--3, 
		imageRadius = 5,--4, 
		gravityScale = 1.0,
		strictContactCheck = true
	}



	-- Create a "block" of water (LiquidFun group)
	particleSystem:createGroup(
	  {
		  flags = { "tensile", "colorMixing" }, --tensile, water
		  x = x+35,
		  y = y+30,
		  color = { 0.9, 0.2, 0.2, 1},
		  halfWidth = 35,--138,
		  halfHeight = 110--220
	  }
    )

	-- Create a "block" of water (LiquidFun group)
	particleSystem:createGroup(
	  {
		  flags = { "tensile", "colorMixing" }, --tensile, water
		  x = x-35,
		  y = y+30,
		  color = { 0.2, 0.3, 0.9, 1},
		  halfWidth = 35,--138,
		  halfHeight = 110--220
	  }
    )


    -- -- Initialize snapshot for mainDisp since we want to put effects on in
    -- snapshot = display.newSnapshot( sceneGroup, w, h )
    -- local snapshotGroup = snapshot.group
    -- snapshot.x = x
    -- snapshot.y = y
    -- snapshot.canvasMode = "discard"
    -- snapshot.alpha = 0.8
    -- -- Apply filter to MainDisp
    -- snapshot.fill.effect = "filter.sobel"
    -- --snapshot.fill.effect = "filter.blur"
--     snapshot.fill.effect = "filter.emboss"
-- snapshot.fill.effect = "filter.frostedGlass"
-- snapshot.fill.effect = "filter.crystallize"
-- snapshot.fill.effect = "filter.scatter"
    -- -- Insert the particle system into the snapshot
    -- snapshotGroup:insert( particleSystem )
    -- snapshotGroup.x = -w/2
    -- snapshotGroup.y = -h/2
    -- -- Remember to invalidate Snapshot in onEnterFrame Event Handler


    --local shakerImage = display.newImageRect( "Assets/objects/shaker-1.png", display.actualContentWidth, display.actualContentHeight )
    local imageFile = "Assets/objects/shaker-1.png"
    --local imageOutline = graphics.newOutline( 2, imageFile )
    local shakerImage = display.newImage( imageFile )
    shakerImage.x = display.contentCenterX
    shakerImage.y = display.contentCenterY

    local physicsData = (require "Assets.objects.shapedefs").physicsData(1.0)
    physics.addBody( shakerImage, "static", physicsData:get("shaker-1-outline") )

    self.display:insert(borderLeftSide)
    self.display:insert(borderTopSide)
    self.display:insert(borderRightSide)
    self.display:insert(borderBottomSide)

    self.display:insert(particleSystem)
    
    self.display:insert(shakerImage)

    return self
end


function M:willShow()
end

function M:show ()
    physics.start()
end

function M:willHide()
    physics.stop()
end

function M:hide (event)
end

function M:destroy (event)
    self.display:removeSelf()
    self.display = nil
    package.loaded[physics] = nil
	physics = nil
end


function M:updateForces()
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


return M
