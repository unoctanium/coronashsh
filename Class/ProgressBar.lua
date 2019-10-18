require 'Class.Class'

ProgressBar = class()

function ProgressBar:init(x,y,w,h,dir,min,max,actual)
    if x == nil then return end

    -- Properties
    self.display = nil
    self.bkg = nil
    self.rectActual = nil
    self.dir = dir    
    self.progressMin = nil
    self.progressMax = nil
    self.progressActual = nil
    
    -- Crete Display Group for this control
    self.display = display.newGroup()
    --
    self.bkg = display.newRect(x,y,w,h)
    self.bkg:setFillColor(0,0,0,1)
    self.dir = dir
    self.progressMin = min
    self.progressMax = max
    self.rectActual = display.newRect(x,y,w,h)
    self.rectActual:setFillColor(1,1,1,0.5)
    if actual~=nil then self:update(actual) end

    self.display:insert(self.bkg)
    self.display:insert(self.rectActual)
end


function ProgressBar:willShow()
end

function ProgressBar:show ()
end

function ProgressBar:willHide()
end

function ProgressBar:hide (event)
end

function ProgressBar:destroy (event)
    self.display:removeSelf()
    self.display = nil
end

function ProgressBar:setBackgroundColor(...)
    self.bkg:setBackgroundColor(...)
end

function ProgressBar:setBarColor(...)
    self.rectActual:setFillColor(...)
end

function ProgressBar:setFillColor(r,g,b,a)
    self:setBackgroundColor(r,g,b,a)
    self:setBarColor(r,g,b,a/2)
end

function ProgressBar:update(val)

    self.progressActual = val
    if self.dir == 1 then -- horizontal
        local dx = (self.progressActual-self.progressMin) * self.bkg.width / (self.progressMax-self.progressMin)
        self.rectActual.x = self.bkg.x-self.bkg.width/2+dx/2
        self.rectActual.width = dx
    else -- vertical
        -- Map: [A, B] --> [a, b] := (val - A)*(b-a)/(B-A) + a
        local A = self.progressMin
        local B = self.progressMax
        local a = self.bkg.y - self.bkg.height/2
        local b = a + self.bkg.height
        local mapval = (val - A)*(b-a)/(B-A)+a 
        if mapval > b then mapval = b end
        if mapval < a then mapval = a end
        local dh = mapval-a
        local dy = b - dh/2 
        self.rectActual.y = dy
        self.rectActual.height = dh
        --print(val, A, B, a, b, dy, dh)

    end
end

