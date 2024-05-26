--EZTrade.lua

local addonName, EZT = ...

---@class f:Frame
local f = CreateFrame("Frame")

local function isRelevantLoot(classID)
    if (classID == Enum.ItemClass.Weapon and EZTradeDB.trackWeapons) then
        return true
    elseif (classID == Enum.ItemClass.Armor and EZTradeDB.trackArmors) then
        return true
    elseif (classID == Enum.ItemClass.Recipe and EZTradeDB.trackRecipe) then
        return true
    elseif (classID == Enum.ItemClass.Battlepet and EZTradeDB.trackPets) then
        return true
    else
        return false
    end
end

local function tradeableBinds(tooltipData)
    local bindType = EZT.getItemBindingFromTooltipData(tooltipData)
    local tradeTimer = EZT.itemHasTradeTimerFromTooltipData(tooltipData)
    if (bindType) then
        
        if  (bindType == Enum.TooltipDataItemBinding.BindOnEquip) or
            (bindType == Enum.TooltipDataItemBinding.BindOnUse) or
            (bindType == Enum.TooltipDataItemBinding.BindOnPickup) or
            --Följande med "tradeTimer = true"
            (bindType == Enum.TooltipDataItemBinding.Soulbound and tradeTimer) then
            return true
        else
            return false
        end
    end
end

local function addIfTradeableAndRelevant(itemLink)
    EZT.debugPrint(itemLink)
    local itemID, _, _, _, icon, _, _ = C_Item.GetItemInfoInstant(itemLink)

    local itemLoc = EZT.getItemLocation(itemID)

    if itemLoc and itemLoc:IsValid() then
        local itemGuid = C_Item.GetItemGUID(itemLoc)
        local item = Item:CreateFromItemGUID(itemGuid)

        if item and not item:IsItemEmpty() then
            item:ContinueOnItemLoad(function()
                local name = item:GetItemName()
                local tooltipData = C_TooltipInfo.GetItemByGUID(itemGuid)

                if tradeableBinds(tooltipData) then
                    EZT.AddLoot(itemLink, itemID, name, icon, itemGuid, itemLoc)
                end

            end)
        end
    else
        EZT.debugPrint(" itemLoc is nil or not valid.")
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

    end
end

function f:CHAT_MSG_LOOT(lootText)
    local itemLink = string.match(lootText, "|c.-|h|r")

    if (itemLink) then
        if (isMyLoot(lootText)) then -- Only add "my" loot to the list.
            local _, _, _, _, _, classID, _ = C_Item.GetItemInfoInstant(itemLink)

            if (isRelevantLoot(classID)) then
                -- Running right away seem to cause random errors. Thinking it might be other
                -- addons moving items around slots? Stacking etc.. Executing after a short timer
                -- as a workaround for now.
                C_Timer.After(2, function()
                    addIfTradeableAndRelevant(itemLink)
                end)
            end
        end
    end
end

f:SetScript("OnEvent", function(self, event, ...)
    self[event](self, ...)
end)

--For debug
--function f:MERCHANT_SHOW()
--    EZT.RedrawLootList()
--    print("Merchant open")
--end
--
--function f:MERCHANT_CLOSED()
--    print("Merchant close")
--    EZT.RedrawLootList()
--end
--
--f:RegisterEvent("MERCHANT_SHOW")
--f:RegisterEvent("MERCHANT_CLOSED")

f:RegisterEvent("ADDON_LOADED")
f:RegisterEvent("CHAT_MSG_LOOT")
f:RegisterEvent("TRADE_SHOW")
f:RegisterEvent("TRADE_CLOSED")
