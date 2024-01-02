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
  --LogBook:Debug(LogBookLoot:i18n("Initializating general tracking..."))
  LB_CustomFunctions:Delay(0, LBL_Track.StartTracking, "")
end

---Start tracking
function LBL_Track.StartTracking()
  local level           = LogBook.db.global.characters[LogBookLoot.key].info.level
  local name            = LogBook.db.global.characters[LogBookLoot.key].info.name
  local faction         = LogBook.db.global.characters[LogBookLoot.key].info.faction
  local factionName     = LogBook.db.global.characters[LogBookLoot.key].info.factionName
  local className       = LogBook.db.global.characters[LogBookLoot.key].info.className
  local classFilename   = LogBook.db.global.characters[LogBookLoot.key].info.classFilename

  local colored_name    = LB_CustomColors:GetColoredName(name)
  local colored_level   = LB_CustomColors:GetColoredLevel(LogBookLoot:i18n("Level") .. " " .. level)
  local colored_class   = LB_CustomColors:GetColoredClass(className, classFilename)
  local colored_faction = LB_CustomColors:GetColoredFaction(faction, factionName)

  local message         = colored_name .. ", " .. colored_class .. " " .. colored_faction .. " " .. colored_level
  LogBookLoot:Print(LogBookLoot:i18n("Tracking loot of") .. " " .. message)
  LBL_TrackEventHandler:Initialize()
  if LBL_Track:IsTrackingLoot() then
    LBL_TrackLoot:Initialize()
  end
end

---Check if tracking experience
function LBL_Track:IsTrackingLoot()
  if LogBookLoot.db.char.general.loot.trackingEnabled == nil then
    LogBookLoot.db.char.general.loot.trackingEnabled = false
    return false
  end
  return LogBookLoot.db.char.general.loot.trackingEnabled
end
