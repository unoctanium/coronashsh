local M = {}

M.display = nil

function M:new (x,y,w,h)
    -- Crete Display Group for this control
    self.display = display.newGroup()
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
