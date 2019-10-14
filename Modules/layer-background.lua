local M = {}

--local Utils = require("scripts.modules.utils")

M.display = nil
M.bkg = nil

function M:new (x,y,w,h)
    -- Crete Display Group for this control
    self.display = display.newGroup()
    --
    self.bkg = display.newRect(x,y,w,h)
    self.bkg:setFillColor(0,0,0,0)

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


return M


-- 192,222,21
--0,0,0
	-- mainDisp:setFillColor(0,0,1,0.5)
	-- mainDisp.fill.effect = "generator.checkerboard"
	-- mainDisp.fill.effect.color1 = { 0.2, 0.4, 0.8, 1 }
	-- mainDisp.fill.effect.color2 = { 0.6, 0.6, 0.8, 1 }
	-- mainDisp.fill.effect.xStep = 8
    -- mainDisp.fill.effect.yStep = 8
