---@class LB_Settings
local LB_Settings = LB_ModuleLoader:CreateModule("LB_Settings")

---@type LBC_Settings
local LBC_Settings = LB_ModuleLoader:ImportModule("LBC_Settings")

---@type LBL_Settings
local LBL_Settings = LB_ModuleLoader:ImportModule("LBL_Settings")

---@type LBZ_Settings
local LBZ_Settings = LB_ModuleLoader:ImportModule("LBZ_Settings")

---@type LBF_Settings
local LBF_Settings = LB_ModuleLoader:ImportModule("LBF_Settings")

---@type LBM_Settings
local LBM_Settings = LB_ModuleLoader:ImportModule("LBM_Settings")

---@type LB_CustomFunctions
local LB_CustomFunctions = LB_ModuleLoader:ImportModule("LB_CustomFunctions")

---@type LB_SettingsDefaults
local LB_SettingsDefaults = LB_ModuleLoader:ImportModule("LB_SettingsDefaults");

-- Forward declaration
LB_Settings.tabs = { ... }

---@type AceGUIFrame, AceGUIFrame
LogBookSettingsFrame = nil

local LibStub = LibStub
local AceGUI = LibStub("AceGUI-3.0")
local AceConfigDialog = LibStub("AceConfigDialog-3.0")
local AceConfigRegistry = LibStub("AceConfigRegistry-3.0")

function LB_Settings:Initialize()
  local optionsTable = _CreateSettingsTable()
  AceConfigRegistry:RegisterOptionsTable("LogBook", optionsTable)
  AceConfigDialog:AddToBlizOptions("LogBook", "LogBook");
  if not LogBookSettingsFrame then
    LB_Settings:DrawSettingsFrame()
  end
end

function LB_Settings:DrawSettingsFrame()
  --LogBook:Debug(LogBook:i18n("Creating settings frame"))
  ---@type AceGUIFrame, AceGUIFrame
  local logBookSettingsFrame = AceGUI:Create("Frame");
  logBookSettingsFrame:Hide()
  AceConfigDialog:SetDefaultSize("LogBook", 620, 540)
  AceConfigDialog:Open("LogBook", logBookSettingsFrame) -- load the options into configFrame
  logBookSettingsFrame:SetTitle("LogBook")
  logBookSettingsFrame:SetLayout("Fill")
  logBookSettingsFrame:EnableResize(false)
  logBookSettingsFrame:SetStatusText("|cffffffffLog|r|cff57b6ffBook|r |cffc1c1c1v|r|cff9191a10.0.1|r")
  logBookSettingsFrame:Hide()
  logBookSettingsFrame:SetCallback("OnClose", function(widget)
    PlaySound(840)
  end)

  logBookSettingsFrame:Hide()
  LogBookSettingsFrame = logBookSettingsFrame;

  _G["LogBookSettingsFrame"] = LogBookSettingsFrame.frame
  table.insert(UISpecialFrames, "LogBookSettingsFrame");
end

---@return table
_CreateSettingsTable = function()
  local general_tab = LB_Settings.tabs.general:Initialize()
  local advanced_tab = LB_Settings.tabs.advanced:Initialize()

  local critics_tab = nil
  if CriticsWindowFrame ~= nil then
    critics_tab = LBC_Settings:Initialize()
  end
  local loot_tab = nil
  if LootWindowFrame ~= nil then
    loot_tab = LBL_Settings:Initialize()
  end

  local zones_tab = nil
  if ZonesWindowFrame ~= nil then
    zones_tab = LBZ_Settings:Initialize()
  end

  local fishing_tab = nil
  if FishingWindowFrame ~= nil then
    fishing_tab = LBF_Settings:Initialize()
  end

  local mobs_tab = nil
  if MobsWindowFrame ~= nil then
    mobs_tab = LBM_Settings:Initialize()
  end

  return {
    name = "LogBook",
    handler = LogBook,
    type = "group",
    childGroups = "tree",
    args = {
      general_tab = general_tab,
      loot_tab = loot_tab,
      critics_tab = critics_tab,
      zones_tab = zones_tab,
      fishing_tab = fishing_tab,
      mobs_tab = mobs_tab,
      advanced_tab = advanced_tab,
      profiles_tab = LibStub("AceDBOptions-3.0"):GetOptionsTable(LogBook.db)
    }
  }
end

-- Generic function to hide the config frame.
function LB_Settings:HideSettingsFrame()
  if LogBookSettingsFrame and LogBookSettingsFrame:IsShown() then
    LogBookSettingsFrame:Hide();
  end
end

---Open the configuration window
function LB_Settings:OpenSettingsFrame()
  if not LogBookSettingsFrame then
    return
  end
  if not LogBookSettingsFrame:IsShown() then
    PlaySound(882)
    --LogBook:Debug("Show Config frame")
    LogBookSettingsFrame:Show()
  else
    --LogBook:Debug("Hide Config frame")
    LogBookSettingsFrame:Hide()
  end
end

function LB_Settings:RefreshConfig()
  AceConfigRegistry:NotifyChange("LogBook")
end
