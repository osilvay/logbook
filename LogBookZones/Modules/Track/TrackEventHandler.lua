---@class LBZ_TrackEventHandler
local LBZ_TrackEventHandler = LB_ModuleLoader:CreateModule("LBZ_TrackEventHandler")
local _LBZ_TrackEventHandler = {}

---@type LBZ_TrackZones
local LBZ_TrackZones = LB_ModuleLoader:ImportModule("LBZ_TrackZones")

function LBZ_TrackEventHandler:Initialize()
  --LogBook:Debug(LogBookZones:i18n("Initializing track events..."))
  LogBookZones:RegisterEvent("ZONE_CHANGED", _LBZ_TrackEventHandler.ZoneChanged)
  LogBookZones:RegisterEvent("ZONE_CHANGED_INDOORS", _LBZ_TrackEventHandler.ZoneChanged)
  LogBookZones:RegisterEvent("ZONE_CHANGED_NEW_AREA", _LBZ_TrackEventHandler.ZoneChanged)
end

function _LBZ_TrackEventHandler.ZoneChanged()
  LBZ_TrackZones:ZoneChanged()
end
