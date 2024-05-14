--EZTrade.lua

local addonName, EZT = ...

---@class f:Frame
local f = CreateFrame("Frame")

local function isRelevantLoot(classID)
    if (classID == 2 and EZTradeDB.trackWeapons) then
        return true
    elseif (classID == 4 and EZTradeDB.trackArmors) then
        return true
    elseif (classID == 9 and EZTradeDB.trackRecipe) then
        return true
    elseif (classID == 17 and EZTradeDB.trackPets) then
        return true
    --elseif (classID == 0 or classID == 15) then -- Temporary
    --    return true
    else
        return false
    end
end

local function isMyLoot(lootText, localizedLootString)
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
    local localizedLootString = LOOT_ITEM_SELF:gsub("%%s", ""):gsub("%.$", "")

    local itemLinkTmp = string.match(lootText, "|c.-|h|r")
    --local itemId = GetItemInfoFromHyperlink(itemLinkTmp)

    if (itemLinkTmp) then
        local itemName, itemLink, itemQuality, itemLevel, itemMinLevel, itemType,
                itemSubType, itemStackCount, itemEquipLoc, itemTexture, sellPrice, classID,
                subclassID, bindType, expansionID, setID, isCraftingReagent = C_Item.GetItemInfo(itemLinkTmp)
        
        EZT.debugPrint(itemLink .. classID)

        if (isMyLoot(lootText, localizedLootString)) then -- Only add "my" loot to the list.
            ---@diagnostic disable-next-line: undefined-field
            if (isRelevantLoot(classID)) then    -- Only add relevant loot               
                EZT.AddLoot(itemLinkTmp)
                --EZT.RedrawLootList()
            end
        end
    end
end

f:SetScript("OnEvent", function(self, event, ...)
    self[event](self, ...)
end)

f:RegisterEvent("ADDON_LOADED")
f:RegisterEvent("CHAT_MSG_LOOT")
f:RegisterEvent("TRADE_SHOW")
f:RegisterEvent("TRADE_CLOSED")
