---@class LBL_Init
local LBL_Init = LB_ModuleLoader:CreateModule("LBL_Init")

---@type LBL_Track
local LBL_Track = LB_ModuleLoader:ImportModule("LBL_Track")

---@type LBL_LootWindow
local LBL_LootWindow = LB_ModuleLoader:ImportModule("LBL_LootWindow")

---@type LBL_LootTooltip
local LBL_LootTooltip = LB_ModuleLoader:ImportModule("LBL_LootTooltip")

---@type LBL_Database
local LBL_Database = LB_ModuleLoader:ImportModule("LBL_Database")

-- called by the PLAYER_LOGIN event handler
function LBL_Init:Initialize()
  LBL_Track:Initialize()
  LBL_Database:Initialize()
  LBL_LootWindow:Initialize()
  LBL_LootTooltip:Initialize()

  if LogBookEnchanting.db.char.general.enchanting.autoUpdateDb then
    C_Timer.After(0.1, function()
      LBL_Database:StartAutoUpdateDatabase()
    end)
  end
end
