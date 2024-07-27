--SlashCommand.lua

local addonName, EZT = ...

SLASH_EZTrade_CMD1 = '/ezt'
SLASH_EZTrade_CMD2 = '/eztrade'

---@param args string arguments following the slash command
SlashCmdList["EZTrade_CMD"] = function(args)
    local lowercaseArgs = string.lower(args)

    if lowercaseArgs == "help" or lowercaseArgs == "info" or lowercaseArgs == "?" then
        print(WrapTextInColorCode("-------------------------------------------------", EZT.colors["YELLOW"]))
        print(EZT.addon.title .. " v" .. EZT.addon.version)
        print(WrapTextInColorCode("-------------------------------------------------", EZT.colors["YELLOW"]))

        print("Usage:")
        print("  " .. WrapTextInColorCode("/ezt", EZT.colors["YELLOW"]) .. " - Show options panel")
        print("  " .. WrapTextInColorCode("/ezt help", EZT.colors["YELLOW"]) .. " - Show this help info")
        print("  " .. WrapTextInColorCode("/ezt reset", EZT.colors["YELLOW"]) .. " - Reset to default settings and reload UI")
        print(WrapTextInColorCode("-------------------------------------------------", EZT.colors["YELLOW"]))
    elseif lowercaseArgs == "reset" then
        --Reset to default settings.
        EZTradeDB = CopyTable(EZT.addonDefaults)
        ReloadUI()
    elseif lowercaseArgs == "debug" then
        -- toggle EZTradeDB.debug
        EZTradeDB.debug = not EZTradeDB.debug
        if EZTradeDB.debug then
            print(WrapTextInColorCode(EZT.addon.title .. " debug mode enabled.", EZT.colors["PRIMARY"]))
        else
            print(WrapTextInColorCode(EZT.addon.title .. " debug mode disabled.", EZT.colors["PRIMARY"]))
        end

    else
        if InterfaceOptionsFrame_OpenToCategory then
			InterfaceOptionsFrame_OpenToCategory("EZTrade")
		else
			Settings.OpenToCategory(EZT.settingsCategory.ID)
		end
    end
end
