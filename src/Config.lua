--Config.lua

local _, EZT = ...

--Register the Wago Analytics lib.
EZT.WagoAnalytics = LibStub("WagoAnalytics"):Register("BKpqarGE")

--Addon information parsed from TOC
EZT.addon = {
    title = C_AddOns.GetAddOnMetadata("EZTrade", "Title"),
    version = C_AddOns.GetAddOnMetadata("EZTrade", "Version")
}

--Placeholder for settings category
EZT.settingsCategory = nil

--Default configuration
EZT.addonDefaults = {
    debug = false,
    trackWeapons = true,
    trackArmors = true,
    trackRecipe = true,
    trackPets = true
}

--Helper color codes
EZT.colors = {
    PRIMARY = "ff45D388",
    WHITE = "ffFFFFFF",
    YELLOW = "ffFFFF00",
}
