--TradePanel.lua

local addonName, EZT = ...

local attachToFrame = TradeFrame --TradeFrame  MailFrame PaperDollItemsFrame

---@class EZTradeFrame: Frame
local EZTradeFrame = CreateFrame("Frame", "EZTradeFrame", attachToFrame, "DefaultPanelFlatTemplate")
local minMaxButton = CreateFrame("Button", "ToggleMinMax", EZTradeFrame, "UIPanelButtonTemplate")

local myLoot = {}

local maxLootItems = 10
local lootRowFrames = {}

local windowOpen = 0
local windowOpenSize = 250
local windowCloseSize = 105

EZT.AddLoot = function(item)
    myLoot[#myLoot + 1] = item
    if #myLoot == maxLootItems then
        table.remove(myLoot, 1)
    end
end

local function getRequiredHeight()
    local lootHeight = #myLoot * 41
    if lootHeight < 300 then
        lootHeight = 300
    end
    return lootHeight
end

local function findAndUseItem(listedId)
    local GetContainerNumSlots = C_Container and C_Container.GetContainerNumSlots
    local GetContainerItemInfo = C_Container and C_Container.GetContainerItemInfo

    for bag = 0, NUM_BAG_FRAMES do
        for slot = 1, GetContainerNumSlots(bag) do
            local containerInfo = GetContainerItemInfo(bag, slot)
            local iid = containerInfo and containerInfo.itemID or nil
            if iid == listedId then
                C_Container.UseContainerItem(bag, slot)
                break
            end
        end
    end
end

local function findItem(listedId)
    local GetContainerNumSlots = C_Container and C_Container.GetContainerNumSlots
    local GetContainerItemInfo = C_Container and C_Container.GetContainerItemInfo

    for bag = 0, NUM_BAG_FRAMES do
        for slot = 1, GetContainerNumSlots(bag) do
            local containerInfo = GetContainerItemInfo(bag, slot)
            local iid = containerInfo and containerInfo.itemID or nil
            if iid == listedId then
                return true
            end
        end
    end
    return false
end

local function hideOnNoLoot()
    if #myLoot == 0 then
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
    f:SetSize(windowOpenSize, getRequiredHeight())
    f:SetPoint("RIGHT", attachToFrame, "RIGHT", 255, 0)

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

    -- Create loot row frames  that we reuse
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

        lootRowFrames[i] = rowFrame
        lootRowFrames[i]:Hide()
    end

    hideOnNoLoot()
end

setUpTradeFrame(EZTradeFrame)

-- Update Loot List Function
EZT.RedrawLootList = function()
    local yPos = 35
    local yIncrement = 35

    local updatedLoot = {}

    for _, lootItem in ipairs(myLoot) do
        local itemId = GetItemInfoFromHyperlink(lootItem)
        if findItem(itemId) then -- Keep the loot item if found
            updatedLoot[#updatedLoot + 1] = lootItem
        end
    end

    myLoot = updatedLoot

    for _, rowFrame in ipairs(lootRowFrames) do
        rowFrame:Hide()
    end

    for i, lootItem in ipairs(myLoot) do
        local rowFrame = lootRowFrames[i]

        rowFrame:SetPoint("TOPLEFT", EZTradeFrame, "TOPLEFT", 20, -yPos)
        yPos = yPos + yIncrement
        if myLoot[i] then
            local _, _, _, _, _, _, _, _, _, itemTexture = C_Item.GetItemInfo(myLoot[i])

            if rowFrame.icon then
                rowFrame.icon:SetTexture(itemTexture)
            else
                rowFrame.icon = rowFrame:CreateTexture(nil, "OVERLAY")
                rowFrame.icon:SetSize(32, 32)
                rowFrame.icon:SetPoint("LEFT", rowFrame, "LEFT", -3, 0)
            end

            rowFrame.hyperlink = myLoot[i]

            if not rowFrame.fontString then
                rowFrame.fontString = rowFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlightMedium")
                rowFrame.fontString:SetPoint("LEFT", rowFrame, "LEFT", 30, 0)
            end

            if windowOpen == 1 then
                EZTradeFrame:SetSize(windowOpenSize, getRequiredHeight())
                EZTradeFrame:SetPoint("RIGHT", attachToFrame, "RIGHT", 255, 0)
                rowFrame:SetSize(200, 32)
                rowFrame.fontString:SetText(rowFrame.hyperlink)
            else
                EZTradeFrame:SetSize(windowCloseSize, getRequiredHeight())
                EZTradeFrame:SetPoint("RIGHT", attachToFrame, "RIGHT", 110, 0)
                rowFrame:SetSize(32, 32)
                rowFrame.fontString:SetText("")
            end

            rowFrame:SetScript("OnMouseUp", function(self, button)
                if button == "RightButton" then
                    local itemId = GetItemInfoFromHyperlink(rowFrame.hyperlink)
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
    hideOnNoLoot()
end

EZT.OffTrade = function()
end
