---@class LBL_TrackLoot
local LBL_TrackLoot = LB_ModuleLoader:CreateModule("LBL_TrackLoot")

---@type LB_CustomColors
local LB_CustomColors = LB_ModuleLoader:ImportModule("LB_CustomColors")

---@type LB_CustomFunctions
local LB_CustomFunctions = LB_ModuleLoader:ImportModule("LB_CustomFunctions")

---@type LB_CustomSounds
local LB_CustomSounds = LB_ModuleLoader:ImportModule("LB_CustomSounds")

---initialize track crit
function LBL_TrackLoot:Initialize()
  -- tooltip hook
  LogBook:Info(LogBookLoot:i18n("Tracking loot initialized"))
end
