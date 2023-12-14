---@class LB_SlashCommands
local LB_SlashCommands = LB_ModuleLoader:CreateModule("LB_SlashCommands")

---@type LB_Settings
local LB_Settings = LB_ModuleLoader:ImportModule("LB_Settings")

---@type LBC_CriticsWindow
local LBC_CriticsWindow = LB_ModuleLoader:ImportModule("LBC_CriticsWindow")

function LB_SlashCommands.RegisterSlashCommands()
  LogBook:RegisterChatCommand("logbook", LB_SlashCommands.HandleCommands)
  LogBook:RegisterChatCommand("lb", LB_SlashCommands.HandleCommands)
end

function LB_SlashCommands.HandleCommands(input)
  
  local criticsModuleLoaded = false
  if CriticsWindowFrame ~= nil then
    criticsModuleLoaded = true
  end

  local command = string.lower(input) or "help"
  if command == "config" then
    --LogBook:Debug(LogBook:i18n("Opening settings window"))
    LB_SlashCommands:CloseAllFrames()
    LB_Settings:OpenSettingsFrame("general_tab")
  elseif command == "critics" and criticsModuleLoaded then
    --LogBook:Debug(LogBook:i18n("Opening critics window"))
    LB_SlashCommands:CloseAllFrames()
    LBC_CriticsWindow:OpenCriticsWindowFrame()
  else
    LogBook:Print(LogBook:i18n("Log|cff57b6ffBook|r Available Commands"))
    LogBook:Print("/lb |cfffce060config|r - " .. LogBook:i18n("Shows settings window"))
    if criticsModuleLoaded then
      LogBook:Print("/lb |cfffce060critics|r - " .. LogBook:i18n("Shows critics window"))
    end
  end
end

function LB_SlashCommands:CloseAllFrames()
  LB_Settings:HideSettingsFrame()
  LBC_CriticsWindow:HideCriticsWindowFrame()
end
