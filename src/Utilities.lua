--Utilities.lua

local _, EZT = ...

---Helper function to print debug messages, handling strings and tables.
---@param message any The message or data to print
EZT.debugPrint = function(message)
    if EZTradeDB.debug then
        local prefix = (EZT.addon.title or "") .. WrapTextInColorCode(" debug: ", EZT.colors["PRIMARY"])

        if type(message) == "table" then
            -- If it's a table, iterate and print key-value pairs
            print(prefix .. " (table):")
            for k, v in pairs(message) do
                print(prefix .. string.format("  %s = %s", tostring(k), tostring(v)))
            end
        else
            -- Otherwise, print the message as a string
            print(prefix .. tostring(message))
        end
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

---Helper function to extract item ID from an item link
---@param itemLink string The item link to extract from
EZT.getItemIDFromLink = function(itemLink)
    return tonumber(itemLink:match("item:(%d+)"))
end

---Helper function to extract item name from an item link
---@param itemLink string The item link to extract from
EZT.getItemNameFromLink = function(itemLink)
    return itemLink:match("h%[(.*)%]|h")
end

--- Function snatched from https://github.com/zeptognome/BetterBags_Bindings
---@param TooltipData TooltipData
---@return boolean
EZT.itemHasTradeTimerFromTooltipData = function(TooltipData)
    local matchString = string.format(BIND_TRADE_TIME_REMAINING, ".*")
    matchString = (string.gsub(matchString,"%(","%%%("))  -- remove magic chars "(" and ")"
    matchString = (string.gsub(matchString,"%)","%%%)"))  -- fingers crossed that this works for other locales

    for i = 2, 20 do
      local line = TooltipData.lines[i]
      if (not line) then
        break
      end
      if line.type == Enum.TooltipDataLineType.None then
        if (string.find(line.leftText, matchString)) then
          return true
        end
      end
    end
    return false
end

--- Function snatched from https://github.com/zeptognome/BetterBags_Bindings
---@param tooltipData TooltipData
---@return Enum.TooltipDataItemBinding|nil
EZT.getItemBindingFromTooltipData = function(tooltipData)
    local tbl = TooltipUtil.FindLinesFromData({Enum.TooltipDataLineType.ItemBinding},tooltipData)
    if tbl and tbl[1].bonding then
        return tbl[1].bonding
    else
        if EZTradeDB.debug then
            return Enum.TooltipDataItemBinding.BindOnPickup
        end
        return nil
    end
end

EZT.getItemLocation = function(searchID)
    for bagID = NUM_BAG_FRAMES, 0, -1 do 
        for slotID = C_Container.GetContainerNumSlots(bagID), 1, -1 do
            local containerInfo = C_Container.GetContainerItemInfo(bagID, slotID)
            local currentID = containerInfo and containerInfo.itemID or nil
            if currentID == searchID then
                local itemLoc = ItemLocation:CreateFromBagAndSlot(bagID, slotID)
                return itemLoc
            end
        end
    end
end
