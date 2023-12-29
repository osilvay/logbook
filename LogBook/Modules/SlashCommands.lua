---@class LB_SlashCommands
local LB_SlashCommands = LB_ModuleLoader:CreateModule("LB_SlashCommands")

---@type LB_Settings
local LB_Settings = LB_ModuleLoader:ImportModule("LB_Settings")

---@type LB_WelcomeWindow
local LB_WelcomeWindow = LB_ModuleLoader:ImportModule("LB_WelcomeWindow")

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
    LB_SlashCommands:OpenSettingsWindow()
  elseif command == "main" then
    LB_SlashCommands:OpenWelcomeWindow()
  elseif command == "critics" and criticsModuleLoaded then
    LB_SlashCommands:OpenCriticsWindow()
  else
    LogBook:Print(LogBook:i18n("Log|cff57b6ffBook|r available commands"))
    LogBook:Print("/lb |cfffce060config|r - " .. LogBook:i18n("Open settings window"))
    LogBook:Print("/lb |cfffce060main|r - " .. LogBook:i18n("Open main window"))
    if criticsModuleLoaded then
      LogBook:Print("/lb |cfffce060critics|r - " .. LogBook:i18n("Open critics window"))
    end
  end
end

function LB_SlashCommands:CloseAllFrames()
  LB_Settings:HideSettingsFrame()
  LBC_CriticsWindow:HideCriticsWindowFrame()
end

function LB_SlashCommands:OpenSettingsWindow()
  LB_WelcomeWindow:HideWelcomeWindowFrame()
  LBC_CriticsWindow:HideCriticsWindowFrame()
  LB_Settings:OpenSettingsFrame()
end

function LB_SlashCommands:OpenCriticsWindow()
  LB_Settings:HideSettingsFrame()
  LB_WelcomeWindow:HideWelcomeWindowFrame()
  LBC_CriticsWindow:OpenCriticsWindowFrame()
end

function LB_SlashCommands:OpenWelcomeWindow()
  LBC_CriticsWindow:HideCriticsWindowFrame()
  LB_Settings:HideSettingsFrame()
  LB_WelcomeWindow:OpenWelcomeWindowFrame()
end
