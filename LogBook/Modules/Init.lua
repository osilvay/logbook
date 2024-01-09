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

---@type LB_WelcomeWindow
local LB_WelcomeWindow = LB_ModuleLoader:ImportModule("LB_WelcomeWindow")

-- called by the PLAYER_LOGIN event handler
function LB_Init:Initialize()
  LB_MinimapIcon:Initialize()
  LB_SlashCommands.RegisterSlashCommands()
  LB_WelcomeWindow:Initialize()
  LogBook:Info(string.format(LogBook:i18n("LogBook %s initialized"), LogBook:GetAddonVersionString()))
  LB_CustomFunctions:Delay(0.1, LB_Init.LoadAddons, "")
end

local addons_to_load = { "LogBookCritics", "LogBookLoot", "LogBookZones", "LogBookFishing", "LogBookMobs" }
function LB_Init.LoadAddons()
  for _, addon in ipairs(addons_to_load) do
    local loaded, reason = C_AddOns.LoadAddOn(addon)
    if not loaded then
      LogBook:Warning(ADDON_LOAD_FAILED:format(C_AddOns.GetAddOnInfo(addon), _G["ADDON_" .. reason]))
    else
      LogBook:Info(string.format(LogBook:i18n("Module |cffffcc00%s|r loaded"), addon))
    end
  end
  C_Timer.After(1, function()
    LB_Init.InitializeAddons()
  end)
  LogBook.started = true
end

local initializeTicker
function LB_Init.InitializeAddons()
  local numAddons = #addons_to_load
  local currentAddonsProccesed = 0
  local addonsProcessed = {}

  if (not initializeTicker) then
    initializeTicker = C_Timer.NewTicker(0.2, function()
      if currentAddonsProccesed >= numAddons then
        initializeTicker:Cancel()
        initializeTicker = nil
        LB_Settings:Initialize()
      end
      for _, addon in ipairs(addons_to_load) do
        if addonsProcessed[addon] == nil and C_AddOns.IsAddOnLoaded(addon) then
          if addon == "LogBookCritics" then
            LogBookCritics:Initialize()
            addonsProcessed[addon] = true
            currentAddonsProccesed = currentAddonsProccesed + 1
            break
          elseif addon == "LogBookLoot" then
            LogBookLoot:Initialize()
            addonsProcessed[addon] = true
            currentAddonsProccesed = currentAddonsProccesed + 1
            break
          elseif addon == "LogBookZones" then
            LogBookZones:Initialize()
            addonsProcessed[addon] = true
            currentAddonsProccesed = currentAddonsProccesed + 1
            break
          elseif addon == "LogBookFishing" then
            LogBookFishing:Initialize()
            addonsProcessed[addon] = true
            currentAddonsProccesed = currentAddonsProccesed + 1
            break
          elseif addon == "LogBookMobs" then
            LogBookMobs:Initialize()
            addonsProcessed[addon] = true
            currentAddonsProccesed = currentAddonsProccesed + 1
            break
          end
        end
      end
    end)
  end
end
