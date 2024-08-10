--OptionsPanel.lua
---@diagnostic disable: undefined-doc-name

local addonName, EZT = ...

---Helper function to create option check button.
---@param parent optionsPanel
---@param displayText string Text associated to options item
---@param name string name of item
---@param x number x position
---@param y number y position
---@return CheckButton|InterfaceOptionsCheckButtonTemplate
local function createOptionCheckButton(parent, displayText, name, x, y)
    local checkbutton = CreateFrame("CheckButton", name, parent, "InterfaceOptionsCheckButtonTemplate")
    checkbutton:SetPoint("TOPLEFT", x, y)
    ---@diagnostic disable-next-line: undefined-field
    checkbutton.Text:SetText(displayText)
    return checkbutton
end

---Helper function to create option button.
---@param parent optionsPanel
---@param displayText string Text associated to options item
---@param name string name of item
---@param x number x position
---@param y number y position
---@param w number width of button
---@param h number height of button
---@return Button|UIPanelButtonTemplate
local function createOptionButton(parent, displayText, name, x, y, w, h)
    local button = CreateFrame("Button", name, parent, "UIPanelButtonTemplate")
    button:SetPoint("TOPLEFT", x, y)
    button:SetWidth(w)
    button:SetHeight(h)
    ---@diagnostic disable-next-line: undefined-field
    button.Text:SetText(displayText)
    return button
end

---Create the options panel
EZT.InitOptions = function()
    ---@class optionsPanel : Frame
    local optionsPanel = CreateFrame("Frame", "AddonOptionsPanel", InterfaceOptionsFramePanelContainer)
    optionsPanel.name = addonName

    -- Create a toggle for the "Debug" option.
    --local debugCheckbox = createOptionCheckButton(optionsPanel, "Debug mode (developer mode)", "ToggleDebugCheckbox", 16, -16)
    --EZT.setOrHookHandler(debugCheckbox, "OnClick", function(self)
    --    EZTradeDB.debug = self:GetChecked()
    --end)
    --debugCheckbox:SetChecked(EZTradeDB.debug)

     -- Loot options
    
     optionsPanel.lootHeader = optionsPanel:CreateFontString(nil, "OVERLAY", "GameFontHighlightMedium")
     optionsPanel.lootHeader:SetPoint("TOPLEFT", 16, -10)
     optionsPanel.lootHeader:SetText("Loot tracking")

    local trackWeapons = createOptionCheckButton(optionsPanel, "Track weapons", "trackWeaponsButton", 16, -30)
    EZT.setOrHookHandler(trackWeapons, "OnClick", function(self)
        EZTradeDB.trackWeapons = self:GetChecked()
    end)
    trackWeapons:SetChecked(EZTradeDB.trackWeapons)

    local trackArmors = createOptionCheckButton(optionsPanel, "Track armors", "trackArmorsButton", 16, -50)
    EZT.setOrHookHandler(trackArmors, "OnClick", function(self)
        EZTradeDB.trackArmors = self:GetChecked()
    end)
    trackArmors:SetChecked(EZTradeDB.trackArmors)

    local trackRecipe = createOptionCheckButton(optionsPanel, "Track recipies", "trackRecipeButton", 16, -70)
    EZT.setOrHookHandler(trackRecipe, "OnClick", function(self)
        EZTradeDB.trackRecipe = self:GetChecked()
    end)
    trackRecipe:SetChecked(EZTradeDB.trackRecipe)

    local trackPets = createOptionCheckButton(optionsPanel, "Track battle pets", "trackPetsButton", 16, -90)
    EZT.setOrHookHandler(trackPets, "OnClick", function(self)
        EZTradeDB.trackPets = self:GetChecked()
    end)
    trackPets:SetChecked(EZTradeDB.trackPets)

     -- Button for resetting to default settings.
     local resetButton = createOptionButton(optionsPanel, "Reset to default settings", "resetButton", 16, -200, 200, 25)
     EZT.setOrHookHandler(resetButton, "OnClick", function()
        EZTradeDB = CopyTable(EZT.addonDefaults)
        --debugCheckbox:SetChecked(EZTradeDB.debug)
        trackWeapons:SetChecked(EZTradeDB.trackWeapons)
        trackArmors:SetChecked(EZTradeDB.trackArmors)
        trackRecipe:SetChecked(EZTradeDB.trackRecipe)
        trackPets:SetChecked(EZTradeDB.trackPets)

        print(WrapTextInColorCode(EZT.addon.title .. " is reset to default settings.", EZT.colors["PRIMARY"]))
     end)

     optionsPanel.versionInfo = optionsPanel:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
     optionsPanel.versionInfo:SetPoint("BOTTOMRIGHT", optionsPanel, -10, 10)
     optionsPanel.versionInfo:SetText(addonName .. " v" .. EZT.addon.version)
    
     --Add panel to interface
    if InterfaceOptions_AddCategory then
        InterfaceOptions_AddCategory(optionsPanel)
    else
        local category, layout = Settings.RegisterCanvasLayoutCategory(optionsPanel, optionsPanel.name);
        Settings.RegisterAddOnCategory(category);
        EZT.settingsCategory = category
    end

    -- Collect analytics.
    EZT.WagoAnalytics:IncrementCounter("OpenOptions")
end
