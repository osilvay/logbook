---@class LBM_Track
local LBM_Track = LB_ModuleLoader:CreateModule("LBM_Track")

---@type LBM_TrackEventHandler
local LBM_TrackEventHandler = LB_ModuleLoader:ImportModule("LBM_TrackEventHandler")

---@type LBM_TrackMobs
local LBM_TrackMobs = LB_ModuleLoader:ImportModule("LBM_TrackMobs")

---@type LB_CustomFunctions
local LB_CustomFunctions = LB_ModuleLoader:ImportModule("LB_CustomFunctions")

---@type LB_CustomColors
local LB_CustomColors = LB_ModuleLoader:ImportModule("LB_CustomColors")

---Initialize track
function LBM_Track:Initialize()
  --LogBook:Debug(LogBookMobs:LBM_i18n("Initializating general tracking..."))
  LB_CustomFunctions:Delay(0, LBM_Track.StartTracking, "")
end

---Start tracking
function LBM_Track.StartTracking()
  local statusColor = "ffe04040"
  local statusText = LogBookMobs:LBM_i18n("Disabled")
  if LBM_Track:IsTrackingMobs() then
    LBM_TrackEventHandler:Initialize()
    LBM_TrackMobs:Initialize()
    statusColor = "ff40e068"
    statusText = LogBookMobs:LBM_i18n("Enabled")
  end
  LogBookMobs:Print(string.format(LogBookMobs:LBM_i18n("|c%s%s|r mobs tracking"), statusColor, statusText))
end

---Check if tracking experience
function LBM_Track:IsTrackingMobs()
  if LogBookMobs.db.char.general.mobs.trackingEnabled == nil then
    LogBookMobs.db.char.general.mobs.trackingEnabled = false
    return false
  end
  return LogBookMobs.db.char.general.mobs.trackingEnabled
end
