local widget = require "widget"

local M = {}

M.display = nil
M.bkg = nil


--This is what is run when we press our button
local onBtn = function (event )
    if event.phase == "began" then
        event.target.width = event.target.width * 1.1
        event.target.height = event.target.height * 1.1
        local soundEffect = audio.loadSound("Assets/sounds/btn-click.mp3")
        audio.play( soundEffect, { channel = AUDIOCHANNEL_BUTTON } )  
    end
    if event.phase == "ended" then
        event.target.width = event.target.width / 1.1
        event.target.height = event.target.height / 1.1
        print(event.name)
        print(event.target.id)
        Runtime:dispatchEvent( event ) -- name = touch, event.target.id=btnResults/btnBattle/btnStore
    end
end

function M:new (x,y,w,h,iw,ih)
    self.iw = iw
    self.ih = ih

    -- create displayGroup
    self.display = display.newGroup()

    self.bkg = display.newRect(x, y, w, h)
    self.bkg:setFillColor(0,0,0,0)
    self.display:insert(self.bkg)

    --Create Results-button
    local btn1=widget.newButton{
        id = "btnResults",
        x = x - w/2 + iw/2,
        y = y,
        width = iw,
        height = ih,
        defaultFile = "Assets/icon-results.png",
        --overFile = "Assets/icon-results.png",
        onEvent = onBtn
    }
    self.display:insert(btn1)

    --Create Battle Button
    local btn2=widget.newButton{
        id = "btnBattle",
        x = x,
        y = y,
        width = iw,
        height = ih,
        defaultFile = "Assets/icon-battle.png",
        --overFile = "Assets/icon-battle.png",
        onEvent = onBtn
    }
    self.display:insert(btn2)

    --Create Store Button
    local btn3=widget.newButton{
        id = "btnStore",
        x = x + w/2 - iw/2,
        y = y,
        width = iw,
        height = ih,
        defaultFile = "Assets/icon-store.png",
        --overFile = "Assets/icon-store.png",
        onEvent = onBtn
    }
    self.display:insert(btn3)
    return self
end

function M:setFillColor(r, b, g, a)
    self.bkg:setFillColor(r,b,g,a)
end


function M:willShow()
end

function M:show ()
    self.display.isVisible = true
end

function M:tween(x,y,w,h)
end

function M:willHide()
end

function M:hide ()
    self.display.isVisible = false
end

function M:destroy ()
    self.display:removeSelf()
    self.display = nil
end

return M
