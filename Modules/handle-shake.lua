local M = {}

--local Utils = require("scripts.modules.utils")

M.acc = {x=0.0, y=0.0, z=0.0}
M.grav = {x=0.0, y=0.0, z=0.0}
M.shakeDeadZone = 2.5
M.shakesCounter = 0
M.shakesPerSecond = 0

M.lastShakeStrength = 0
M.thisShakeStrength = 0

local secsTimer = nil
local secsInLevel = 0

local rrCounter = 0
local rrLen = 5
M.SPSAvg = {0,0,0,0,0}
M.shakesPerSecondAvg = 0

--
-- event handler timer
--
function M:timer(event)
    secsInLevel = secsInLevel + 1
    rrCounter = (rrCounter + 1) % rrLen 
    self.SPSAvg[rrCounter] = self.shakesPerSecond 
    local sum = 0
    for _, v in ipairs(self.SPSAvg) do
        sum = sum + v
    end
    sum = sum / rrLen
    self.shakesPerSecondAvg = sum * 2 -- TODO: ODO Think about *2. Shall up be a shake (*2) or up/down(*1) 
    self.shakesPerSecond = 0
end


--
-- event handler system
--
function M:system ( event )
    if event.type == "applicationSuspend" then
        timer.pause(secsTimer)
    elseif event.type == "applicationResume" then
        if secsTimer then
            timer.resume(secsTimer)
        end
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
    if self.thisShakeStrength < self.lastShakeStrength then -- turning
      if self.thisShakeStrength > self.shakeDeadZone then -- out of dead zone
        self:countShake(self.thisShakeStrength)
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
    self.shakesCounter = self.shakesCounter +0.5
    self.shakesPerSecond = self.shakesPerSecond +0.5

    if self.shakesCounter == math.floor(self.shakesCounter) then
        --print(strength)
        local soundEffect = audio.loadSound("Assets/sounds/ice-shake.mp3")
        audio.play( soundEffect, { channel = CHANNEL_SHAKER } ) 
    end

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
