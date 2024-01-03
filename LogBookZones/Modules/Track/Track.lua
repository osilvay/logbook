---@class LBZ_Track
local LBZ_Track = LB_ModuleLoader:CreateModule("LBZ_Track")

---@type LBZ_TrackEventHandler
local LBZ_TrackEventHandler = LB_ModuleLoader:ImportModule("LBZ_TrackEventHandler")

---@type LBZ_TrackZones
local LBZ_TrackZones = LB_ModuleLoader:ImportModule("LBZ_TrackZones")

---@type LB_CustomFunctions
local LB_CustomFunctions = LB_ModuleLoader:ImportModule("LB_CustomFunctions")

---@type LB_CustomColors
local LB_CustomColors = LB_ModuleLoader:ImportModule("LB_CustomColors")

---Initialize track
function LBZ_Track:Initialize()
  --LogBook:Debug(LogBookZones:i18n("Initializating general tracking..."))
  LB_CustomFunctions:Delay(0, LBZ_Track.StartTracking, "")
end

---Start tracking
function LBZ_Track.StartTracking()
  local statusColor = "ffe04040"
  local statusText = LogBookZones:i18n("Disabled")
  LBZ_TrackEventHandler:Initialize()
  if LBZ_Track:IsTrackingZones() then
    LBZ_TrackEventHandler:Initialize()
    statusColor = "ff40e068"
    statusText = LogBookZones:i18n("Enabled")
  end
  LogBookZones:Print(string.format(LogBookZones:i18n("|c%s%s|r zone tracking"), statusColor, statusText))
end

---Check if tracking experience
function LBZ_Track:IsTrackingZones()
  if LogBookZones.db.char.general.zones.trackingEnabled == nil then
    LogBookZones.db.char.general.zones.trackingEnabled = false
    return false
  end
  return LogBookZones.db.char.general.zones.trackingEnabled
end
