local M = {}

--local Utils = require("scripts.modules.utils")


function M:create (event)
    
end


function M:show (event)
    local phase = event.phase
    if (phase == "will") then
        -- will show
    elseif (phase == "did") then
        -- showing now
    end
end

function M:hide (event)
    local phase = event.phase
    if (phase == "will") then
        -- will hide
    elseif (phase == "did") then
        -- hiding now
    end
end


function M:destroy (event)
end

return M
