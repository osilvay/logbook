---@class LBE_Track
local LBE_Track = LB_ModuleLoader:CreateModule("LBE_Track")

---@type LBE_TrackEventHandler
local LBE_TrackEventHandler = LB_ModuleLoader:ImportModule("LBE_TrackEventHandler")

---@type LBE_TrackEnchanting
local LBE_TrackEnchanting = LB_ModuleLoader:ImportModule("LBE_TrackEnchanting")

---@type LB_CustomFunctions
local LB_CustomFunctions = LB_ModuleLoader:ImportModule("LB_CustomFunctions")

---@type LB_CustomColors
local LB_CustomColors = LB_ModuleLoader:ImportModule("LB_CustomColors")

---Initialize track
function LBE_Track:Initialize()
  --LogBook:Debug(LogBookEnchanting:i18n("Initializating general tracking..."))
  LB_CustomFunctions:Delay(0, LBE_Track.StartTracking, "")
end

---Start tracking
function LBE_Track.StartTracking()
  local statusColor = "ffe04040"
  local statusText = LogBookEnchanting:i18n("Disabled")
  LBE_TrackEventHandler:Initialize()
  if LBE_Track:IsTrackingEnchanting() then
    LBE_TrackEnchanting:Initialize()
    statusColor = "ff40e068"
    statusText = LogBookEnchanting:i18n("Enabled")
  end
  LogBookEnchanting:Print(string.format(LogBookEnchanting:i18n("|c%s%s|r enchanting tracking"), statusColor, statusText))
end

---Check if tracking experience
function LBE_Track:IsTrackingEnchanting()
  if LogBookEnchanting.db.char.general.enchanting.trackingEnabled == nil then
    LogBookEnchanting.db.char.general.enchanting.trackingEnabled = false
    return false
  end
  return LogBookEnchanting.db.char.general.enchanting.trackingEnabled
end
