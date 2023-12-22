---@class LB_Init
local LB_Init = LB_ModuleLoader:CreateModule("LB_Init")

---@type LB_Settings
local LB_Settings = LB_ModuleLoader:ImportModule("LB_Settings")

---@type LB_CustomFunctions
local LB_CustomFunctions = LB_ModuleLoader:ImportModule("LB_CustomFunctions")

---@type LB_SlashCommands
local LB_SlashCommands = LB_ModuleLoader:ImportModule("LB_SlashCommands")

---@type LB_MinimapIcon
local LB_MinimapIcon = LB_ModuleLoader:ImportModule("LB_MinimapIcon")

-- called by the PLAYER_LOGIN event handler
function LB_Init:Initialize()
    LB_MinimapIcon:Initialize()
    LB_SlashCommands.RegisterSlashCommands()
    LogBook:Info(LogBook:i18n("LogBook initialized"))
    LB_CustomFunctions:Delay(0.1, LB_Init.LoadAddons, "")
end

function LB_Init.LoadAddons()
    local addons_to_load = { "LogBookCritics" }
    for _, addon in ipairs(addons_to_load) do
        local loaded, reason = C_AddOns.LoadAddOn(addon)
        -- reload settings
        if not loaded then
            LogBook:Warning(ADDON_LOAD_FAILED:format(C_AddOns.GetAddOnInfo(addon), _G["ADDON_" .. reason]))
        else
            LogBook:Info(string.format(LogBook:i18n("Module |cffffcc00%s|r loaded"), addon))
        end
    end
    LB_Settings:Initialize()
    LogBook.started = true
end