--Utilities.lua

local _, EZT = ...

---Helper function to print debug messages
---@param message string
EZT.debugPrint = function(message)
    if EZTradeDB.debug then
        print((EZT.addon.title or "") .. WrapTextInColorCode(" debug: ", EZT.colors["PRIMARY"]) .. tostring(message))
    end
end

---Helper function to set or hook script to a frame.
---@param frame frame frame to attach script to
---@param event string event name
---@param func function function to attach
EZT.setOrHookHandler = function(frame, event, func)
    if frame:GetScript(event) then
        frame:HookScript(event, func)
    else
        frame:SetScript(event, func)
    end
end

---Helper function to make a frame movable
---@param frame frame frame to make movable
EZT.makeFrameMovable = function(frame)
    frame:SetMovable(true)
    frame:EnableMouse(true)
    frame:RegisterForDrag("LeftButton")
    frame:SetScript("OnDragStart", frame.StartMoving)
    frame:SetScript("OnDragStop", frame.StopMovingOrSizing)
end

