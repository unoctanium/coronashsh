local M = {}

--local Utils = require("scripts.modules.utils")

M.acc = {x=0.0, y=0.0, z=0.0}
M.grav = {x=0.0, y=0.0, z=0.0}
M.shakeDeadZone = 0.8
M.shakesCounter = 0
M.shakesPerSecond = 0

M.lastShakeStrength = 0
M.thisShakeStrength = 0

local secsTimer = 0
local secsInLevel = 0



--
-- event handler timer
--
function M:timer(event)
    secsInLevel = secsInLevel + 1
    self.shakesPerSecond = 0
end


--
-- event handler system
--
function M:system ( event )
    if event.type == "applicationSuspend" then
        timer.pause(secsTimer)
    elseif event.type == "applicationResume" then
        timer.resume(secsTimer)
    end
end


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


function M:resetTimer()
    secsInLevel = 0
end

function M:getSecsInLevel()
    return secsInLevel
end


function M:getShakeSpeed ()
    return ({x=self.acc.x, y=self.acc.y, z=self.acc.z})
end

function M:getShakeStrength ()
    return (self.lastShakeStrength * self.shakesPerSecond)
end

function M:getAccel ()
    return self.acc.x, self.acc.y, self.acc.z
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


function M:new ()
    system.setAccelerometerInterval( 60 )
    secsInLevel = 0
end


function willShow()
end

function M:show ()
    -- showing now
    Runtime:addEventListener( "accelerometer", M )
    Runtime:addEventListener( "system", M )
    secsTimer = timer.performWithDelay( 1000, M, 0 )
end

function M:willHide()
    timer.cancel(secsTimer)
    Runtime:removeEventListener( "accelerometer", M )
    Runtime:removeEventListener( "system", M )
end

function M:hide ()
end

function M:destroy ()
end

return M
