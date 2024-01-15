---@class LBC_TrackEventHandler
local LBC_TrackEventHandler = LB_ModuleLoader:CreateModule("LBC_TrackEventHandler")
local _LBC_TrackEventHandler = {}

---@type LBC_TrackCritics
local LBC_TrackCritics = LB_ModuleLoader:ImportModule("LBC_TrackCritics")

function LBC_TrackEventHandler:Initialize()
  --LogBook:Debug(LogBookCritics:LBC_i18n("Initializing track events..."))
  LogBookCritics:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED", _LBC_TrackEventHandler.CombatLogEventUnfiltered)
end

function _LBC_TrackEventHandler.CombatLogEventUnfiltered()
  LBC_TrackCritics:ProcessCombatLogEventUnfiltered()
end
