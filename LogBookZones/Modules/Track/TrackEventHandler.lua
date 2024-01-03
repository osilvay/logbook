---@class LBZ_TrackEventHandler
local LBZ_TrackEventHandler = LB_ModuleLoader:CreateModule("LBZ_TrackEventHandler")
local _LBZ_TrackEventHandler = {}

---@type LBZ_TrackZones
local LBZ_TrackZones = LB_ModuleLoader:ImportModule("LBZ_TrackZones")

function LBZ_TrackEventHandler:Initialize()
  --LogBook:Debug(LogBookZones:i18n("Initializing track events..."))
end
