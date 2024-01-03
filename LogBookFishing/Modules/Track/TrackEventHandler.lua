---@class LBF_TrackEventHandler
local LBF_TrackEventHandler = LB_ModuleLoader:CreateModule("LBF_TrackEventHandler")
local _LBF_TrackEventHandler = {}

---@type LBF_TrackFishing
local LBF_TrackFishing = LB_ModuleLoader:ImportModule("LBF_TrackFishing")

function LBF_TrackEventHandler:Initialize()
  --LogBook:Debug(LogBookFishing:i18n("Initializing track events..."))
end
