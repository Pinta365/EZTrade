--DebugPanel.lua
-- Just a temporary panel with things for development

local addonName, EZT = ...

EZT.setUpDebugFrame = function()
    ---@class EZTDebugFrame: Frame
    local EZTDebugFrame = CreateFrame("Frame", "EZTradeFrame", UIParent, "BasicFrameTemplateWithInset")
    EZTDebugFrame:SetSize(250, 350)
    EZTDebugFrame:SetPoint("CENTER", -150, 250)
    EZTDebugFrame:Show()

    EZT.makeFrameMovable(EZTDebugFrame)

    -- DEBUG BUTTONS
    -- DEBUG BUTTONS

    local dbx = 10
    local dby = 10
    local button1 = CreateFrame("Button", "Pattern: Toxic Thorn Footwraps", EZTDebugFrame, "UIPanelButtonTemplate")
    button1:SetPoint("TOPLEFT", 25 + dbx, -(25 + dby))
    ---@diagnostic disable-next-line: undefined-field
    button1.Text:SetText("Pattern: Toxic Thorn Footwraps")
    button1:SetWidth(200)
    EZT.setOrHookHandler(button1, "OnClick", function(self)
        EZT.AddLoot("|cffa335ee|Hitem:193869::::::::4:1448:::::::::|h[Pattern: Toxic Thorn Footwraps]|h|r")
        C_Timer.After(1, function()
            EZT.RedrawLootList()
        end)
    end)

    local button2 = CreateFrame("Button", "Dathea's Cyclonic Cage", EZTDebugFrame, "UIPanelButtonTemplate")
    button2:SetPoint("TOPLEFT", 25 + dbx, -(50 + dby))
    ---@diagnostic disable-next-line: undefined-field
    button2.Text:SetText("Dathea's Cyclonic Cage")
    button2:SetWidth(200)
    EZT.setOrHookHandler(button2, "OnClick", function(self)
        EZT.AddLoot("|cffa335ee|Hitem:195494::::::::4:1448:::::::::|h[Dathea's Cyclonic Cage]|h|r")
        C_Timer.After(1, function()
            EZT.RedrawLootList()
        end)
    end)

    local button3 = CreateFrame("Button", "Sargha's Smasher", EZTDebugFrame, "UIPanelButtonTemplate")
    button3:SetPoint("TOPLEFT", 25 + dbx, -(75 + dby))
    ---@diagnostic disable-next-line: undefined-field
    button3.Text:SetText("Sargha's Smasher")
    button3:SetWidth(200)
    EZT.setOrHookHandler(button3, "OnClick", function(self)
        EZT.AddLoot("|cff0070dd|Hitem:193779::::::::4:1448:::::::::|h[Sargha's Smasher]|h|r")
        C_Timer.After(1, function()
            EZT.RedrawLootList()
        end)
    end)

    local button4 = CreateFrame("Button", "Eye of Allseeing", EZTDebugFrame, "UIPanelButtonTemplate")
    button4:SetPoint("TOPLEFT", 25 + dbx, -(100 + dby))
    ---@diagnostic disable-next-line: undefined-field
    button4.Text:SetText("Eye of Allseeing")
    button4:SetWidth(200)
    EZT.setOrHookHandler(button4, "OnClick", function(self)
        EZT.AddLoot("|cff1eff00|Hitem:186554::::::::4:1448:::::::::|h[Eye of Allseeing]|h|r")
        C_Timer.After(1, function()
            EZT.RedrawLootList()
        end)
    end)

    local button5 = CreateFrame("Button", "Redraw", EZTDebugFrame, "UIPanelButtonTemplate")
    button5:SetPoint("TOPLEFT", 25 + dbx, -(125 + dby))
    ---@diagnostic disable-next-line: undefined-field
    button5.Text:SetText("Redraw")
    button5:SetWidth(200)
    EZT.setOrHookHandler(button5, "OnClick", function(self)
        EZT.RedrawLootList()
    end)

    
    -- DEBUG BUTTONS
    -- DEBUG BUTTONS
end
