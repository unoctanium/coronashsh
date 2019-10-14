local M = {}

M.display = nil
M.bkg = nil
M.isOpen = false



--
-- Touch handler
--
function M:touch(event)
    if event.phase == "ended" then
        print("touched adBanner")
        print(event.name)
        print(event.target)
        print(event.target.id)
    end
    return true -- stop propagation
end



function M:new (x,y,w,h)
    -- Crete Display Group for this control
    self.display = display.newGroup()
    --
    self.bkg = display.newRect(x,y,w,h)
    self.bkg:setFillColor(0,0,0,0)
    self.isOpen = false
    --
    self.display:insert(self.bkg)
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

function M:setFillColor(r, b, g, a)
    self.bkg:setFillColor(r,b,g,a)
end

function M:open()
    self.isOpen = true
    -- TODO: tween alpha here
    self.bkg:addEventListener("touch", self)
end

function M:close()
    self.bkg:removeEventListener("touch", self)
    -- TODO: tween alpha here
    self.isOpen = false
end


function M:closeFast()
    self.bkg:removeEventListener("touch", self)
    -- TODO: tween alpha here
    self.isOpen = false
end




return M
