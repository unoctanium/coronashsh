

local M = {}

M.display = nil

function M:new (x,y,w,h)
    -- Crete Display Group for this control
    self.display = display.newGroup()
    --
    --
    return self
end

function M:willShow()
end

function M:show ()
end

function M:willHide()
end

function M:hide (event)
end

function M:destroy (event)
    self.display:removeSelf()
    self.display = nil
end

return M




--[[
function newProgressBar(...)
    local obj = display.newRect(...)
    obj.initBar = function (self, min, max, actual)
        -- self is obj, although obj is an upvalue so can use directly too
        print(self, obj, min, max, actual)
    end
    return obj
end
--]]
