local widget = require "widget"

local M = {}

M.display = nil
M.bkg = nil

M.shakesCounter = 0
M.shakesPerSecond = 0

M.shakesCounterText = "Shakes: "
M.shakesPerSecondText = "Shakings per second: "
M.shakesCounterTextField = nil
M.shakesPerSecondTectField = 0
M.shakesCounterFontSize = 40
M.shakesPerSecondFontSize = 30
M.fontName = "Assets/fonts/SHAKETHATBOOTY.ttf"


--This is what is run when we press our button
local onBtn = function (event )
    if event.phase == "began" then
        event.target.width = event.target.width * 1.1
        event.target.height = event.target.height * 1.1
        if event.target.id == "btnCamera" then
            local soundEffect = audio.loadSound("Assets/sounds/camera-click.mp3")
            audio.play( soundEffect, { channel = AUDIOCHANNEL_BUTTON } )  
        else
            local soundEffect = audio.loadSound("Assets/sounds/btn-click.mp3")
            audio.play( soundEffect, { channel = AUDIOCHANNEL_BUTTON } )  
        end
    end
    if event.phase == "ended" then
        event.target.width = event.target.width / 1.1
        event.target.height = event.target.height / 1.1
        Runtime:dispatchEvent( event ) -- name = touch, event.target.id=btnCamera/btnSettigs
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

    --Create Camera-button
    local btn1=widget.newButton{
        id = "btnCamera",
        x = x - w/2 + iw/2,
        y = y-ih/2,
        width = iw,
        height = ih,
        defaultFile = "Assets/icon-camera.png",
        onEvent = onBtn
    }
    self.display:insert(btn1)

    --Create Setup Button
    local btn2=widget.newButton{
        id = "btnSettings",
        x = x + w/2 - iw/2,
        y = y-ih/2,
        width = iw,
        height = ih,
        defaultFile = "Assets/icon-settings.png",
        onEvent = onBtn
    }
    self.display:insert(btn2)

    -- create Shakes display
    --self.shakesCounterFontSize = 20
    self.shakesCounterTextField = display.newText(
		self.shakesCounterText, 
		x, y-h*2/8, 
		self.fontName, self.shakesCounterFontSize 
	)
    self.shakesCounterTextField:setFillColor( 0.6,0.6,1,1 )
    self.display:insert(self.shakesCounterTextField)

    -- create Shakes per second display
    --self.shakesPerSecondFontSize = 20
	self.shakesPerSecondTextField = display.newText(
		self.shakesPerSecondText, 
		x, y+h*2/8, 
		self.fontName, self.shakesPerSecondFontSize 
	)
    self.shakesPerSecondTextField:setFillColor( 0.6,0.6,1,1 )
    self.display:insert(self.shakesPerSecondTextField)

    return self
end

function M:setFillColor(r, b, g, a)
    self.bkg:setFillColor(r,b,g,a)
end

function M:show ()
    self.display.isVisible = true
end

function M:setShakesCounter(n)
    self.shakesCounterTextField.text = self.shakesCounterText  .. tostring(n)
end

function M:setSPS(n)
    self.shakesPerSecondTextField.text = self.shakesPerSecondText .. tostring(n)
end


function M:tween(x,y,w,h)
end

function M:hide (event)
    self.display.isVisible = false
end

function M:uninit ()
    self.display:removeSelf()
    self.display = nil
end

return M


