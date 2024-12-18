--TradePanel.lua

local addonName, EZT = ...

local attachToFrame = TradeFrame --TradeFrame PaperDollItemsFrame MerchantFrame

---@class EZTradeFrame: Frame
local EZTradeFrame = CreateFrame("Frame", "EZTradeFrame", attachToFrame, "DefaultPanelFlatTemplate")
local minMaxButton = CreateFrame("Button", "ToggleMinMax", EZTradeFrame, "UIPanelButtonTemplate")

local myLoot = {}

local maxLootItems = 10
local longestLootString = 10 -- used to estimate width of "open" loot panel.
local lootRowFrames = {}


local windowOpen = 0
local windowClosedSize = 105

EZT.AddLoot = function(itemLink, itemId, itemName, itemIcon, itemGuid)
    EZT.debugPrint("Adding loot: " .. itemLink .. ", " .. itemId .. ", " .. itemName .. ", " .. itemIcon .. ", " .. itemGuid)

    local newItem = {
        link = itemLink,
        id = itemId or 0,
        name = itemName or "",
        icon = itemIcon,
        guid = itemGuid
    }

    myLoot[#myLoot + 1] = newItem
    if #myLoot == maxLootItems then
        table.remove(myLoot, 1)
    end
    EZT.RedrawLootList()
end

local function getRequiredHeight()
    local lootHeight = #myLoot * 41
    if lootHeight < 300 then
        lootHeight = 300
    end
    return lootHeight
end

local function getRequiredWidth()
    local lootWidth = 105 -- Minimized panel size.
    local magicNumber = 7 -- A bit of guesstimate number. "Width of a char".
    return lootWidth + (longestLootString * magicNumber)
end

local function findAndUseItem(searchID)
    for bag = 0, NUM_BAG_FRAMES do
        for slot = 1, C_Container.GetContainerNumSlots(bag) do
            local containerInfo = C_Container.GetContainerItemInfo(bag, slot)
            local currentID = containerInfo and containerInfo.itemID or nil
            if currentID == searchID then
                C_Container.UseContainerItem(bag, slot)
                return
            end
        end
    end
end

local function findItem(searchID)
    for bag = 0, NUM_BAG_FRAMES do
        for slot = 1, C_Container.GetContainerNumSlots(bag) do
            local containerInfo = C_Container.GetContainerItemInfo(bag, slot)
            local currentID = containerInfo and containerInfo.itemID or nil
            if currentID == searchID then
                return true
            end
        end
    end
    return false
end

local function hideOnNoLoot()
    if #myLoot == 0 then
        longestLootString = 10
        EZTradeFrame:Hide()
    else
        EZTradeFrame:Show()
    end
end

local function toggleFrameSize()
    if minMaxButton then
        ---@diagnostic disable-next-line: undefined-field
        local currentText = minMaxButton.Text:GetText()
        if currentText == "<" then
            windowOpen = 0
            ---@diagnostic disable-next-line: undefined-field
            minMaxButton.Text:SetText(">")
        else
            windowOpen = 1
            ---@diagnostic disable-next-line: undefined-field
            minMaxButton.Text:SetText("<")
        end
        EZT.RedrawLootList()
    end
end

local function setUpTradeFrame(f)
    f:SetSize(windowClosedSize, getRequiredHeight())
    f:SetPoint("TOPLEFT", attachToFrame, "TOPRIGHT", 0, 0)

    f.title = f:CreateFontString("Title", "OVERLAY")
    f.title:SetFontObject("GameFontHighlight")
    ---@diagnostic disable-next-line: undefined-field
    f.title:SetPoint("BOTTOMRIGHT", -5, 10)
    f.title:SetText(addonName .. " v" .. EZT.addon.version)

    minMaxButton:SetPoint("TOPRIGHT", -5, -25)
    minMaxButton:SetWidth(25)
    if windowOpen == 1 then
        ---@diagnostic disable-next-line: undefined-field
        minMaxButton.Text:SetText("<")
    else
        ---@diagnostic disable-next-line: undefined-field
        minMaxButton.Text:SetText(">")
    end
    minMaxButton:SetScript("OnClick", toggleFrameSize)

    for i = 1, maxLootItems do
        local rowFrame = CreateFrame("Frame", "LootRow" .. i, f)

        rowFrame:SetScript("OnEnter", function(self)
            GameTooltip:SetOwner(self, "ANCHOR_CURSOR_RIGHT")
            GameTooltip:SetHyperlink(self.hyperlink)
            GameTooltip:Show()
        end)

        rowFrame:SetScript("OnLeave", function(self)
            GameTooltip:Hide()
        end)

        ---@diagnostic disable-next-line: inject-field
        rowFrame.icon = rowFrame:CreateTexture(nil, "OVERLAY")
        rowFrame.icon:SetSize(32, 32)
        rowFrame.icon:SetPoint("LEFT", rowFrame, "LEFT", -3, 0)

        rowFrame:Hide()
        lootRowFrames[i] = rowFrame

    end

    EZTradeFrame:Hide()
end

setUpTradeFrame(EZTradeFrame)

-- Update Loot List Function
EZT.RedrawLootList = function()
    local yPos = 35
    local yIncrement = 35
    local updatedLoot = {}

    for i = 1, #myLoot do
        local lootItem = myLoot[i]
        -- Update longestLootString for width calculation
        longestLootString = max(longestLootString, #lootItem.name)

        if findItem(lootItem.id) then -- Keep the loot item if found
            updatedLoot[#updatedLoot + 1] = lootItem
        end
    end

    --DevTools_Dump(myLoot)
    --DevTools_Dump(updatedLoot)

    myLoot = updatedLoot

    for _, rowFrame in ipairs(lootRowFrames) do
        rowFrame:Hide()
    end

    for i, lootItem in ipairs(myLoot) do
        local rowFrame = lootRowFrames[i]

        rowFrame:SetPoint("TOPLEFT", EZTradeFrame, "TOPLEFT", 20, -yPos)
        yPos = yPos + yIncrement
        if lootItem then

            if rowFrame.icon then
                rowFrame.icon:SetTexture(lootItem.icon)
            else
                rowFrame.icon = rowFrame:CreateTexture(nil, "OVERLAY")
                rowFrame.icon:SetTexture(lootItem.icon)
                rowFrame.icon:SetSize(32, 32)
                rowFrame.icon:SetPoint("LEFT", rowFrame, "LEFT", -3, 0)
            end

            rowFrame.hyperlink = lootItem.link

            if not rowFrame.fontString then
                rowFrame.fontString = rowFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlightMedium")
                rowFrame.fontString:SetPoint("LEFT", rowFrame, "LEFT", 30, 0)
            end

            if windowOpen == 1 then
                EZTradeFrame:SetSize(getRequiredWidth(), getRequiredHeight())
                EZTradeFrame:SetPoint("TOPLEFT", attachToFrame, "TOPRIGHT", 0, 0)
                rowFrame:SetSize(200, 32)
                rowFrame.fontString:SetText(rowFrame.hyperlink)
            else
                EZTradeFrame:SetSize(windowClosedSize, getRequiredHeight())
                EZTradeFrame:SetPoint("TOPLEFT", attachToFrame, "TOPRIGHT", 0, 0)
                rowFrame:SetSize(32, 32)
                rowFrame.fontString:SetText("")
            end

            rowFrame:SetScript("OnMouseUp", function(self, button)
                if button == "RightButton" then
                    local itemId = lootItem.id
                    if itemId then
                        findAndUseItem(itemId)
                    end
                end
            end)
            rowFrame:Show()
        end
    end

    hideOnNoLoot()
end

EZT.OnTrade = function()
    EZT.RedrawLootList()
end

EZT.OffTrade = function()
    EZT.RedrawLootList()
end