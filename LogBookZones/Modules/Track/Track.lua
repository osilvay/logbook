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

---@type LB_CustomPopup
local LB_CustomPopup = LB_ModuleLoader:ImportModule("LB_CustomPopup")

---Initialize track
function LBZ_Track:Initialize()
  -- Start general tracking
  C_Timer.After(0.1, function()
    LBZ_Track:StartTracking()
  end)

  -- automatic tracking
  if LogBookZones.db.char.general.zones.autoTrackingEnabled then
    C_Timer.After(1, function()
      LBZ_Track:StartAutomaticTracking()
    end)
  end
end

---Start tracking
function LBZ_Track.StartTracking()
  local statusColor = "ffe04040"
  local statusText = LogBookZones:LBZ_i18n("Disabled")
  LBZ_TrackEventHandler:Initialize()
  if LBZ_Track:IsTrackingZones() then
    LBZ_TrackEventHandler:Initialize()
    statusColor = "ff40e068"
    statusText = LogBookZones:LBZ_i18n("Enabled")
  end
  LogBookZones:Print(string.format(LogBookZones:LBZ_i18n("|c%s%s|r zone tracking"), statusColor, statusText))
end

---Check if tracking
function LBZ_Track:IsTrackingZones()
  if LogBookZones.db.char.general.zones.trackingEnabled == nil then
    LogBookZones.db.char.general.zones.trackingEnabled = false
    return false
  end
  return LogBookZones.db.char.general.zones.trackingEnabled
end

local automaticTrackingTicker
local autoTrackingIteration = 0
---Start automatic tracking
function LBZ_Track:StartAutomaticTracking()
  local timeToTrack = LogBookZones.db.char.general.zones.timeAutoTracking
  if LogBookZones.db.char.general.zones.autoTrackingEnabled then
    --LogBook:Debug(string.format("Starting automatic tracking each %d minutes", timeToTrack))
    if automaticTrackingTicker == nil then
      automaticTrackingTicker = C_Timer.NewTicker(timeToTrack * 60, function()
        if not LogBookZones.db.char.general.zones.autoTrackingEnabled then
          --LogBook:Debug(string.format("Cancelling automatic tracking..."))
          if automaticTrackingTicker ~= nil then
            automaticTrackingTicker:Cancel()
          end
          automaticTrackingTicker = nil
        end
        autoTrackingIteration = autoTrackingIteration + 1
        --LogBook:Debug(string.format("Automatic tracking iteration : %d", autoTrackingIteration))
        LBZ_TrackZones:ZoneChanged(false)

        timeToTrack = LogBookZones.db.char.general.zones.timeAutoTracking
      end)
    else
      --LogBook:Debug(string.format("Autotracking is already running..."))
    end
  end
end

---Stop automatic tracking
function LBZ_Track:StopAutomaticTracking()
  --LogBook:Debug(string.format("Stopping automatic tracking..."))
  if automaticTrackingTicker ~= nil then
    automaticTrackingTicker:Cancel()
  end
  automaticTrackingTicker = nil
  autoTrackingIteration = 0
end
