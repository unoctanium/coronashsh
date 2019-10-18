local M = {}

local LayerBackground = require("Modules.layer-background")
local layerBackground = nil

local LayerAchievments = require("Modules.layer-achievments")
local layerAchievments = nil

local LayerScoring = require("Modules.layer-scoring")
local layerScoring = nil

require("Class.ProgressBar")
local barLevelProgress = nil
local barTimer = nil

local LayerShaker = require("Modules.layer-shaker")
local layerShaker = nil

M.display = nil

function M:new (x, y, w, h)

    self.display = display.newGroup()

    -- Create Layer Background
	layerBackground = LayerBackground:new(x,y,w,h)
	layerBackground:setFillColor(192/255,222/255,21/255,1)

	-- Create Layer Achievment
	layerAchievments = LayerAchievments:new(x,y,w,h)

	-- Create Layer Scoring
	layerScoring = LayerScoring:new(x,y,w,h)

	-- Create Shaker Layer
	layerShaker = LayerShaker:new(x,y,w,h)
	
	-- Create barLevelProgress
	barLevelProgress = ProgressBar(x+(w*3/8), y, w/16, h/4, 2, 1, 20, 10)
	barTimer = ProgressBar(x-(w*3/8), y, w/16, h/4, 2, 1, 20, 1)
	
	self.display:insert( layerBackground.display )
	self.display:insert( layerShaker.display )
	self.display:insert( layerScoring.display )
	self.display:insert( layerAchievments.display )
	self.display:insert( barLevelProgress.display )
	self.display:insert( barTimer.display)
	return self
    
end

function M:willShow()
	layerShaker:willShow()
end

function M:show ()
    layerShaker:show()
end

function M:willHide()
    layerShaker:willHide()
end

function M:hide (event)
	layerShaker:hide()
end

function M:destroy (event)
	layerBackground:destroy()
	layerBackground = nil

	layerAchievments:destroy()
	layerAchievments = nil

	layerScoring:destroy()
	layerScoring = nil

	layerShaker:destroy()
	layerShaker = nil

	barLevelProgress:destroy()
	barLevelProgress = nil

	barTimer:destroy()
	barTimer = nil

	self.display:removeSelf()
	self.display = nil
end


function M:updateForces()
	layerShaker:updateForces()
end


function M:updateBars()
	self:updateTimerBar(ShakeHandler:getSecsInLevel())
	self:updateProgressBar(ShakeHandler.shakesPerSecondAvg)
end

function M:updateTimerBar(val)
	barTimer:update(val)
end

function M:updateProgressBar(val)
	barLevelProgress:update(val)
end

return M





--[[

for i=group.numChildren, 1, -1 do
  local child = group[i]
  child.someField = someValue
  child.someMethod()
end
 
--]]