local M = {}

M.display = nil


--
-- Touch handler
--
function M:touch(event)
    if event.phase == "ended" then
        print("touched screenShot")
        print(event.name)
        print(event.target)
        print(event.target.id)

        self.display:removeEventListener("touch", self)
        self.display:removeSelf()
        self.display = nil

    end
    return true -- stop propagation
end




function M:new (x,y,w,h)
    -- Crete Display Group for this control
    --self.display = display.newGroup()
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
    if self.display then
        self.display:removeSelf()
        self.display = nil
    end
end


function M:takePicture()
 
    self.display = display.newGroup()

    -- Capture the screen
    local screenCap = display.captureScreen( false ) -- tue to save to photo library
  
    local overlay = display.newRect(
        display.contentCenterX,
        display.contentCenterY,
	    display.safeActualContentWidth,
	    display.safeActualContentHeight
    )
    overlay:setFillColor(0,0,0,0.3)
    self.display:insert(overlay)

    -- Scale the screen capture, now on the screen, to half its size
    screenCap:scale( 0.7, 0.7 )
    screenCap.x = display.contentCenterX
    screenCap.y = display.contentCenterY
    screenCap.rotation = -10
    --screenCap:toFront()
    self.display:insert(screenCap)

    self.display:addEventListener("touch", self)
  
    -- Alert the user to look in the library (device) or on the desktop (Simulator) for the screen capture
    --local alert = native.showAlert( "Success", "Screen Capture Saved to Library", { "OK" } )
end




return M


