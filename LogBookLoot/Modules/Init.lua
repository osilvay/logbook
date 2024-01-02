---@class LBL_Init
local LBL_Init = LB_ModuleLoader:CreateModule("LBL_Init")

---@type LBL_Track
local LBL_Track = LB_ModuleLoader:ImportModule("LBL_Track")

---@type LBL_LootWindow
local LBL_LootWindow = LB_ModuleLoader:ImportModule("LBL_LootWindow")

-- called by the PLAYER_LOGIN event handler
function LBL_Init:Initialize()
    LBL_Track:Initialize()
    LBL_LootWindow:Initialize()
end
