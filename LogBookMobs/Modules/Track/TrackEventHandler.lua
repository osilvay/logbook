---@class LBM_TrackEventHandler
local LBM_TrackEventHandler = LB_ModuleLoader:CreateModule("LBM_TrackEventHandler")
local _LBM_TrackEventHandler = {}

---@type LBM_TrackMobs
local LBM_TrackMobs = LB_ModuleLoader:ImportModule("LBM_TrackMobs")

function LBM_TrackEventHandler:Initialize()
  --LogBook:Debug(LogBookMobs:i18n("Initializing track events..."))
  LogBookMobs:RegisterEvent("PLAYER_TARGET_CHANGED", _LBM_TrackEventHandler.PlayerTargetChanged)
  LogBookMobs:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED", _LBM_TrackEventHandler.CombatLogEventUnfiltered)
end

function _LBM_TrackEventHandler.PlayerTargetChanged()
  LBM_TrackMobs:ProcessPlayerTargetChanged()
end

function _LBM_TrackEventHandler.CombatLogEventUnfiltered()
  LBM_TrackMobs:ProcessCombatLogEventUnfiltered()
end
