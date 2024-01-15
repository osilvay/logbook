---@class LBC_Track
local LBC_Track = LB_ModuleLoader:CreateModule("LBC_Track")

---@type LBC_TrackEventHandler
local LBC_TrackEventHandler = LB_ModuleLoader:ImportModule("LBC_TrackEventHandler")

---@type LBC_TrackCritics
local LBC_TrackCritics = LB_ModuleLoader:ImportModule("LBC_TrackCritics")

---@type LB_CustomFunctions
local LB_CustomFunctions = LB_ModuleLoader:ImportModule("LB_CustomFunctions")

---@type LB_CustomColors
local LB_CustomColors = LB_ModuleLoader:ImportModule("LB_CustomColors")

---Initialize track
function LBC_Track:Initialize()
  --LogBook:Debug(LogBookCritics:LBC_i18n("Initializating general tracking..."))
  LB_CustomFunctions:Delay(0, LBC_Track.StartTracking, "")
end

---Start tracking
function LBC_Track.StartTracking()
  local statusColor = "ffe04040"
  local statusText = LogBookCritics:LBC_i18n("Disabled")
  LBC_TrackEventHandler:Initialize()
  if LBC_Track:IsTrackingCritics() then
    LBC_TrackCritics:Initialize()
    statusColor = "ff40e068"
    statusText = LogBookCritics:LBC_i18n("Enabled")
  end
  LogBookCritics:Print(string.format(LogBookCritics:LBC_i18n("|c%s%s|r critics tracking"), statusColor, statusText))
end

---Check if tracking experience
function LBC_Track:IsTrackingCritics()
  if LogBookCritics.db.char.general.critics.trackingEnabled == nil then
    LogBookCritics.db.char.general.critics.trackingEnabled = false
    return false
  end
  return LogBookCritics.db.char.general.critics.trackingEnabled
end
