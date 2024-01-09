---@class LBM_TrackEventHandler
local LBM_TrackEventHandler = LB_ModuleLoader:CreateModule("LBM_TrackEventHandler")
local _LBM_TrackEventHandler = {}

---@type LBM_TrackMobs
local LBM_TrackMobs = LB_ModuleLoader:ImportModule("LBM_TrackMobs")

function LBM_TrackEventHandler:Initialize()
  --LogBook:Debug(LogBookMobs:i18n("Initializing track events..."))
  --LogBookZones:RegisterEvent("LOOT_READY", _LBM_TrackEventHandler.LootReady)
  --LogBookZones:RegisterEvent("LOOT_CLOSED", _LBM_TrackEventHandler.LootClosed)
  LogBookMobs:RegisterEvent("PLAYER_TARGET_CHANGED", _LBM_TrackEventHandler.PlayerTargetChanged)
end

function _LBM_TrackEventHandler.PlayerTargetChanged()
  --Bitacora:Debug("Processing PLAYER_TARGET_CHANGED")
  LBM_TrackMobs:ProcessPlayerTargetChanged()
end