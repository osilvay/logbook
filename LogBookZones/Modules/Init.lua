---@class LBZ_Init
local LBZ_Init = LB_ModuleLoader:CreateModule("LBZ_Init")

---@type LBZ_Track
local LBZ_Track = LB_ModuleLoader:ImportModule("LBZ_Track")

---@type LB_Settings
local LB_Settings = LB_ModuleLoader:ImportModule("LB_Settings")

---@type LBZ_ZonesWindow
local LBZ_ZonesWindow = LB_ModuleLoader:ImportModule("LBZ_ZonesWindow")

---@type LBZ_WorldMapOverlay
local LBZ_WorldMapOverlay = LB_ModuleLoader:ImportModule("LBZ_WorldMapOverlay")

-- called by the PLAYER_LOGIN event handler
function LBZ_Init:Initialize()
  LBZ_Track:Initialize()
  LBZ_ZonesWindow:Initialize()
  LBZ_WorldMapOverlay:Initialize()
end
