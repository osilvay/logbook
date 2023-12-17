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
  --LogBook:Debug(LogBookCritics:i18n("Initializating general tracking..."))
  LB_CustomFunctions:Delay(0, LBC_Track.StartTracking, "")
end

---Start tracking
function LBC_Track.StartTracking()
  local level           = LogBook.db.global.characters[LogBookCritics.key].info.level
  local name            = LogBook.db.global.characters[LogBookCritics.key].info.name
  local faction         = LogBook.db.global.characters[LogBookCritics.key].info.faction
  local factionName     = LogBook.db.global.characters[LogBookCritics.key].info.factionName
  local className       = LogBook.db.global.characters[LogBookCritics.key].info.className
  local classFilename   = LogBook.db.global.characters[LogBookCritics.key].info.classFilename

  local colored_name    = LB_CustomColors:GetColoredName(name)
  local colored_level   = LB_CustomColors:GetColoredLevel(LogBookCritics:i18n("Level") .. " " .. level)
  local colored_class   = LB_CustomColors:GetColoredClass(className, classFilename)
  local colored_faction = LB_CustomColors:GetColoredFaction(faction, factionName)

  local message         = colored_name .. ", " .. colored_class .. " " .. colored_faction .. " " .. colored_level
  LogBookCritics:Print(LogBookCritics:i18n("Tracking of") .. " " .. message)
  LBC_TrackEventHandler:Initialize()
  if LBC_Track:IsTrackingCritics() then
    LBC_TrackCritics:Initialize()
  end
end

---Check if tracking experience
function LBC_Track:IsTrackingCritics()
  if LogBookCritics.db.char.general.critics.trackingEnabled == nil then
    LogBookCritics.db.char.general.critics.trackingEnabled = false
    return false
  end
  return LogBookCritics.db.char.general.critics.trackingEnabled
end
