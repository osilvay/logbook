---@class LBE_TrackEventHandler
local LBE_TrackEventHandler = LB_ModuleLoader:CreateModule("LBE_TrackEventHandler")
local _LBE_TrackEventHandler = {}

---@type LBE_TrackEnchanting
local LBE_TrackEnchanting = LB_ModuleLoader:ImportModule("LBE_TrackEnchanting")

function LBE_TrackEventHandler:Initialize()
  --LogBook:Debug(LogBookEnchanting:i18n("Initializing track events..."))
end
