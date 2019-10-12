local M = {}

--local Utils = require("scripts.modules.utils")

M.acc = {x=0.0, y=0.0, z=0.0}
M.grav = {x=0.0, y=0.0, z=0.0}
M.shakeDeadZone = 0.8
M.shakesCounter = 0
M.shakesPerSecond = 0

M.lastShakeStrength = 0
M.thisShakeStrength = 0

--
-- event handler accelerometer
--
function M:accelerometer ( event )
    --print( event.name, event.xInstant, event.yInstant, event.zInstant )
  
    local dx = event.xInstant
    local dy = event.yInstant
    local dz = event.zInstant

    local gx = event.xGravity
    local gy = event.yGravity
    local gz = event.zGravity
    
  
    self.thisShakeStrength = math.sqrt(dx*dx+dy*dy+dz*dz)
    if math.abs(self.thisShakeStrength) < math.abs(self.lastShakeStrength) then -- turning
      if self.lastShakeStrength > self.shakeDeadZone then -- out of dead zone
        self:countShake(1)
      end   
    end
    self.lastShakeStrength = self.thisShakeStrength
    self.acc.x = dx
    self.acc.y = dy
    self.acc.z = dz
    self.grav.x = gx
    self.grav.y = gy
    self.grav.z = gz
end

function M:getShakeSpeed ()
    return ({x=self.acc.x, y=self.acc.y, z=self.acc.z})
end

function M:getAccel ()
    return self.acc.x, self.acc.y, self.acc.z
end

function M:getShakeStrength ()
    return (self.lastShakeStrength * self.shakesPerSecond)
end

function M:getGravity ()
    return self.grav.x, self.grav.y
end



function M:countShake(strength)
    self.shakesCounter = self.shakesCounter + 0.5
    self.shakesPerSecond = self.shakesPerSecond + 0.5
    local event = { name="countShake", data=strength }
    Runtime:dispatchEvent( event )
  end


function M:create (event)
    system.setAccelerometerInterval( 60 )
end


function M:show (event)
    local phase = event.phase
    if (phase == "will") then
        -- will show
    elseif (phase == "did") then
        -- showing now
        Runtime:addEventListener( "accelerometer", M )
    end
end

function M:hide (event)
    local phase = event.phase
    if (phase == "will") then
        -- will hide
        Runtime:removeEventListener( "accelerometer", M )
    elseif (phase == "did") then
        -- hiding now
    end
end


function M:destroy (event)
end

return M
