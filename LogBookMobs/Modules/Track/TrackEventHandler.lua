---@class LBM_TrackEventHandler
local LBM_TrackEventHandler = LB_ModuleLoader:CreateModule("LBM_TrackEventHandler")
local _LBM_TrackEventHandler = {}

---@type LBM_TrackMobs
local LBM_TrackMobs = LB_ModuleLoader:ImportModule("LBM_TrackMobs")

function LBM_TrackEventHandler:Initialize()
  --LogBook:Debug(LogBookMobs:i18n("Initializing track events..."))
end
