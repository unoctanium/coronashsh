local transition = require "transition"

local M = {}

M.display = nil
M.bkg = nil
M.xOpen = 0
M.xClose = 0
M.isOpen = false


--
-- Touch handler
--
function M:touch(event)
    if event.phase == "ended" then
        print("touched sidebarLeft")
        print(event.name)
        print(event.target)
        print(event.target.id)
    end
    return true -- stop propagation
end


function M:new (x,y,w,h)
    -- Crete Display Group for this control
    self.display = display.newGroup()
    self.xOpen = 0
    self.xClose = -w
    --
    self.bkg = display.newRect(x,y,w,h)
    self.bkg:setFillColor(0.5,0.5,0.5,1)
    self.display.x = self.xClose
    --
    self.display:insert(self.bkg)
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

function M:open()
    transition.moveTo( self.display, { x=self.xOpen, time=250 } )
    self.isOpen = true
    self.bkg:addEventListener("touch", self)
end

function M:close()
    self.bkg:removeEventListener("touch", self)
    local soundEffect = audio.loadSound("Assets/sounds/slide-closed.mp3")
    audio.play( soundEffect, { channel = AUDIOCHANNEL_PANEL } ) 
    transition.moveTo( self.display, { x=self.xClose, time=250 } )
    self.isOpen = false
end

function M:closeFast()
    self.bkg:removeEventListener("touch", self)
    self.display.x = self.xClose
    self.isOpen = false
end

return M
