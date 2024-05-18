--EZTrade.lua

local addonName, EZT = ...

---@class f:Frame
local f = CreateFrame("Frame")

local function isRelevantLoot(classID)

    if EZTradeDB.debug then
        return true
    end

    if (classID == 2 and EZTradeDB.trackWeapons) then
        return true
    elseif (classID == 4 and EZTradeDB.trackArmors) then
        return true
    elseif (classID == 9 and EZTradeDB.trackRecipe) then
        return true
    elseif (classID == 17 and EZTradeDB.trackPets) then
        return true
    else
        return false
    end
end

local function isMyLoot(lootText)
    local localizedLootString = LOOT_ITEM_SELF:gsub("%%s", ""):gsub("%.$", "")
    if (string.sub(lootText, 1, #localizedLootString) == localizedLootString) then
        return true
    else
        return false
    end
end

function f:TRADE_SHOW()
    EZT.OnTrade()
end

function f:TRADE_CLOSED()
    EZT.OffTrade()
end

function f:ADDON_LOADED(addon)
    if addon == "EZTrade" then
        EZTradeDB = EZTradeDB or CopyTable(EZT.addonDefaults)
        EZT.InitOptions()
        EZT.debugPrint(addonName .. " v" .. EZT.addon.version .. " is loaded.")

        if EZTradeDB.debug then
            EZT.setUpDebugFrame()
        end
    end
end

function f:CHAT_MSG_LOOT(lootText)
    local itemLinkTmp = string.match(lootText, "|c.-|h|r")

    if (itemLinkTmp) then
        local _, _, _, _, _, classID, _ = C_Item.GetItemInfoInstant(itemLinkTmp)
        if (isMyLoot(lootText)) then -- Only add "my" loot to the list.
            ---@diagnostic disable-next-line: undefined-field
            if (isRelevantLoot(classID)) then    -- Only add relevant loot
                C_Timer.After(1, function()
                    EZT.AddLoot(itemLinkTmp)
                end)
            end
        end
    end
end

f:SetScript("OnEvent", function(self, event, ...)
    self[event](self, ...)
end)

-- --For debug
-- function f:MERCHANT_SHOW()
--     EZT.RedrawLootList()
--     print("Merch open")
-- end
-- 
-- function f:MERCHANT_CLOSED()
--     print("Merch close")
--     EZT.RedrawLootList()
-- end
-- f:RegisterEvent("MERCHANT_SHOW")
-- f:RegisterEvent("MERCHANT_CLOSED")

f:RegisterEvent("ADDON_LOADED")
f:RegisterEvent("CHAT_MSG_LOOT")
f:RegisterEvent("TRADE_SHOW")
f:RegisterEvent("TRADE_CLOSED")