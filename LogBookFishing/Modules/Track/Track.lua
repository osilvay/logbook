---@class LBF_Track
local LBF_Track = LB_ModuleLoader:CreateModule("LBF_Track")

---@type LBF_TrackEventHandler
local LBF_TrackEventHandler = LB_ModuleLoader:ImportModule("LBF_TrackEventHandler")

---@type LBF_TrackFishing
local LBF_TrackFishing = LB_ModuleLoader:ImportModule("LBF_TrackFishing")

---@type LB_CustomFunctions
local LB_CustomFunctions = LB_ModuleLoader:ImportModule("LB_CustomFunctions")

---@type LB_CustomColors
local LB_CustomColors = LB_ModuleLoader:ImportModule("LB_CustomColors")

---Initialize track
function LBF_Track:Initialize()
  --LogBook:Debug(LogBookFishing:LBF_i18n("Initializating general tracking..."))
  LB_CustomFunctions:Delay(0, LBF_Track.StartTracking, "")
end

---Start tracking
function LBF_Track.StartTracking()
  local statusColor = "ffe04040"
  local statusText = LogBookFishing:LBF_i18n("Disabled")
  LBF_TrackEventHandler:Initialize()
  if LBF_Track:IsTrackingFishing() then
    LBF_TrackFishing:Initialize()
    statusColor = "ff40e068"
    statusText = LogBookFishing:LBF_i18n("Enabled")
  end
  LogBookFishing:Print(string.format(LogBookFishing:LBF_i18n("|c%s%s|r fishing tracking"), statusColor, statusText))
end

---Check if tracking experience
function LBF_Track:IsTrackingFishing()
  if LogBookFishing.db.char.general.fishing.trackingEnabled == nil then
    LogBookFishing.db.char.general.fishing.trackingEnabled = false
    return false
  end
  return LogBookFishing.db.char.general.fishing.trackingEnabled
end
