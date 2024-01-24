---@class LBE_TrackEnchanting
local LBE_TrackEnchanting = LB_ModuleLoader:CreateModule("LBE_TrackEnchanting")

---@type LB_CustomColors
local LB_CustomColors = LB_ModuleLoader:ImportModule("LB_CustomColors")

---@type LB_CustomFunctions
local LB_CustomFunctions = LB_ModuleLoader:ImportModule("LB_CustomFunctions")

---@type LB_CustomSounds
local LB_CustomSounds = LB_ModuleLoader:ImportModule("LB_CustomSounds")

---@type LBE_EnchantingTooltip
local LBE_EnchantingTooltip = LB_ModuleLoader:ImportModule("LBE_EnchantingTooltip")

---initialize track crit
function LBE_TrackEnchanting:Initialize()
  -- tooltip hooks
  LBE_EnchantingTooltip:Initialize()
end
