--Initialized below
---@class LogBookZones : AceAddon, AceConsole-3.0, AceEvent-3.0, AceTimer-3.0, AceComm-3.0, AceBucket-3.0
LogBookZones = LibStub("AceAddon-3.0"):NewAddon("LogBookZones", "AceConsole-3.0", "AceEvent-3.0", "AceTimer-3.0", "AceComm-3.0", "AceBucket-3.0")

LogBookZones.db = {}

--- Addon is running on Classic Wotlk client
---@type boolean
LogBookZones.IsWotlk = WOW_PROJECT_ID == WOW_PROJECT_WRATH_CLASSIC

--- Addon is running on Classic TBC client
---@type boolean
LogBookZones.IsTBC = WOW_PROJECT_ID == WOW_PROJECT_BURNING_CRUSADE_CLASSIC

--- Addon is running on Classic "Vanilla" client: Means Classic Era and its seasons like SoM
---@type boolean
LogBookZones.IsClassic = WOW_PROJECT_ID == WOW_PROJECT_CLASSIC

--- Addon is running on Classic "Vanilla" client and on Era realm (non-seasonal)
---@type boolean
LogBookZones.IsEra = LogBookZones.IsClassic and (not C_Seasons.HasActiveSeason())

--- Addon is running on Classic "Vanilla" client and on any Seasonal realm (see: https://wowpedia.fandom.com/wiki/API_C_Seasons.GetActiveSeason )
---@type boolean
LogBookZones.IsEraSeasonal = LogBookZones.IsClassic and C_Seasons.HasActiveSeason()

--- Addon is running on a HardCore realm specifically
---@type boolean
LogBookZones.IsHardcore = C_GameRules and C_GameRules.IsHardcoreActive()