---@class LBL_Track
local LBL_Track = LB_ModuleLoader:CreateModule("LBL_Track")

---@type LBL_TrackEventHandler
local LBL_TrackEventHandler = LB_ModuleLoader:ImportModule("LBL_TrackEventHandler")

---@type LBL_TrackLoot
local LBL_TrackLoot = LB_ModuleLoader:ImportModule("LBL_TrackLoot")

---@type LB_CustomFunctions
local LB_CustomFunctions = LB_ModuleLoader:ImportModule("LB_CustomFunctions")

---@type LB_CustomColors
local LB_CustomColors = LB_ModuleLoader:ImportModule("LB_CustomColors")

---Initialize track
function LBL_Track:Initialize()
  --LogBook:Debug(LogBookLoot:LBL_i18n("Initializating general tracking..."))
  LB_CustomFunctions:Delay(0, LBL_Track.StartTracking, "")
end

---Start tracking
function LBL_Track.StartTracking()
  local statusColor = "ffe04040"
  local statusText = LogBookLoot:LBL_i18n("Disabled")
  LBL_TrackEventHandler:Initialize()
  if LBL_Track:IsTrackingLoot() then
    LBL_TrackEventHandler:Initialize()
    LBL_TrackLoot:Initialize()
    statusColor = "ff40e068"
    statusText = LogBookLoot:LBL_i18n("Enabled")
  end
  LogBookLoot:Print(string.format(LogBookLoot:LBL_i18n("|c%s%s|r loot tracking"), statusColor, statusText))
end

---Check if tracking experience
function LBL_Track:IsTrackingLoot()
  if LogBookLoot.db.char.general.loot.trackingEnabled == nil then
    LogBookLoot.db.char.general.loot.trackingEnabled = false
    return false
  end
  return LogBookLoot.db.char.general.loot.trackingEnabled
end
