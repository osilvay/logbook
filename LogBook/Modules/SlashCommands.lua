---@class LB_SlashCommands
local LB_SlashCommands = LB_ModuleLoader:CreateModule("LB_SlashCommands")

---@type LB_Settings
local LB_Settings = LB_ModuleLoader:ImportModule("LB_Settings")

---@type LB_WelcomeWindow
local LB_WelcomeWindow = LB_ModuleLoader:ImportModule("LB_WelcomeWindow")

---@type LBC_CriticsWindow
local LBC_CriticsWindow = LB_ModuleLoader:ImportModule("LBC_CriticsWindow")

---@type LBL_LootWindow
local LBL_LootWindow = LB_ModuleLoader:ImportModule("LBL_LootWindow")

---@type LBZ_ZonesWindow
local LBZ_ZonesWindow = LB_ModuleLoader:ImportModule("LBZ_ZonesWindow")

---@type LBF_FishingWindow
local LBF_FishingWindow = LB_ModuleLoader:ImportModule("LBF_FishingWindow")

---@type LBM_MobsWindow
local LBM_MobsWindow = LB_ModuleLoader:ImportModule("LBM_MobsWindow")

function LB_SlashCommands.RegisterSlashCommands()
  LogBook:RegisterChatCommand("logbook", LB_SlashCommands.HandleCommands)
  LogBook:RegisterChatCommand("lb", LB_SlashCommands.HandleCommands)
end

function LB_SlashCommands.HandleCommands(input)
  local criticsModuleLoaded = false
  if CriticsWindowFrame ~= nil then
    criticsModuleLoaded = true
  end

  local lootModuleLoaded = false
  if LootWindowFrame ~= nil then
    lootModuleLoaded = true
  end

  local zonesModuleLoaded = false
  if ZonesWindowFrame ~= nil then
    zonesModuleLoaded = true
  end

  local fishingModuleLoaded = false
  if FishingWindowFrame ~= nil then
    fishingModuleLoaded = true
  end

  local mobsModuleLoaded = false
  if MobsWindowFrame ~= nil then
    mobsModuleLoaded = true
  end
  

  local command = string.lower(input) or "help"
  if command == "config" then
    LB_SlashCommands:OpenSettingsWindow()
  elseif command == "main" then
    LB_SlashCommands:OpenWelcomeWindow()
  elseif command == "critics" and criticsModuleLoaded then
    LB_SlashCommands:OpenCriticsWindow()
  elseif command == "loot" and lootModuleLoaded then
    LB_SlashCommands:OpenLootWindow()
  elseif command == "zones" and zonesModuleLoaded then
    LB_SlashCommands:OpenZonesWindow()
  elseif command == "zones" and zonesModuleLoaded then
    LB_SlashCommands:OpenFishingWindow()
  elseif command == "mobs" and mobsModuleLoaded then
    LB_SlashCommands:OpenMobsWindow()
  else
    LogBook:Print(LogBook:i18n("Log|cff57b6ffBook|r available commands"))
    LogBook:Print("/lb |cffc1c1c1config|r - " .. LogBook:i18n("Open settings window"))
    LogBook:Print("/lb |cffc1c1c1main|r - " .. LogBook:i18n("Open main window"))
    if criticsModuleLoaded then
      LogBook:Print("/lb |cfffff757critics|r - " .. LogBook:i18n("Open critics window"))
    end
    if lootModuleLoaded then
      LogBook:Print("/lb |cffe38d4floot|r - " .. LogBook:i18n("Open loot window"))
    end
    if zonesModuleLoaded then
      LogBook:Print("/lb |cff4fe388zones|r - " .. LogBook:i18n("Open zones window"))
    end
    if fishingModuleLoaded then
      LogBook:Print("/lb |cffa27be0fishing|r - " .. LogBook:i18n("Open fishing window"))
    end
    if mobsModuleLoaded then
      LogBook:Print("/lb |cff4bd1c4mobs|r - " .. LogBook:i18n("Open mobs window"))
    end
  end
end

function LB_SlashCommands:CloseAllFrames()
  LB_Settings:HideSettingsFrame()
  LB_WelcomeWindow:HideWelcomeWindowFrame()
  LBC_CriticsWindow:HideCriticsWindowFrame()
  LBL_LootWindow:HideLootWindowFrame()
  LBZ_ZonesWindow:HideZonesWindowFrame()
  LBF_FishingWindow:HideFishingWindowFrame()
  LBM_MobsWindow:HideMobsWindowFrame()
end

function LB_SlashCommands:OpenSettingsWindow()
  LB_SlashCommands:CloseAllFrames()
  C_Timer.After(0.2, function()
    LB_Settings:OpenSettingsFrame()
  end)
end

function LB_SlashCommands:OpenCriticsWindow()
  LB_SlashCommands:CloseAllFrames()
  C_Timer.After(0.2, function()
    LBC_CriticsWindow:OpenCriticsWindowFrame()
  end)
end

function LB_SlashCommands:OpenWelcomeWindow()
  LB_SlashCommands:CloseAllFrames()
  C_Timer.After(0.2, function()
    LB_WelcomeWindow:OpenWelcomeWindowFrame()
  end)
end

function LB_SlashCommands:OpenLootWindow()
  LB_SlashCommands:CloseAllFrames()
  C_Timer.After(0.2, function()
    LBL_LootWindow:OpenLootWindowFrame()
  end)
end

function LB_SlashCommands:OpenZonesWindow()
  LB_SlashCommands:CloseAllFrames()
  C_Timer.After(0.2, function()
    LBZ_ZonesWindow:OpenZonesWindowFrame()
  end)
end

function LB_SlashCommands:OpenFishingWindow()
  LB_SlashCommands:CloseAllFrames()
  C_Timer.After(0.2, function()
    LBF_FishingWindow:OpenFishingWindowFrame()
  end)
end

function LB_SlashCommands:OpenMobsWindow()
  LB_SlashCommands:CloseAllFrames()
  C_Timer.After(0.2, function()
    LBM_MobsWindow:OpenMobsWindowFrame()
  end)
end