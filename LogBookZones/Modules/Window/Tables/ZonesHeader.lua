---@class LBZ_ZonesHeader
local LBZ_ZonesHeader = LB_ModuleLoader:CreateModule("LBZ_ZonesHeader")

---@type LB_SlashCommands
local LB_SlashCommands = LB_ModuleLoader:ImportModule("LB_SlashCommands")

---@type LB_Settings
local LB_Settings = LB_ModuleLoader:ImportModule("LB_Settings")

---@type LB_CustomColors
local LB_CustomColors = LB_ModuleLoader:ImportModule("LB_CustomColors")

---@type LB_CustomFunctions
local LB_CustomFunctions = LB_ModuleLoader:ImportModule("LB_CustomFunctions")

---@type LB_CustomFrames
local LB_CustomFrames = LB_ModuleLoader:ImportModule("LB_CustomFrames")

local LibStub = LibStub
local AceGUI = LibStub("AceGUI-3.0")
local AceConfigDialog = LibStub("AceConfigDialog-3.0")
local AceConfigRegistry = LibStub("AceConfigRegistry-3.0")

---Create loot fiter frame
---@param containerTable table
---@param parentFrame AceGUIFrame
function LBZ_ZonesHeader:ContainerHeaderFrame(containerTable, parentFrame)
  -- container
  ---@type AceGUIInlineGroup
  local headerContainer = AceGUI:Create("SimpleGroup")
  headerContainer:SetFullWidth(true)
  headerContainer:SetWidth(500)
  headerContainer:SetHeight(40)
  headerContainer:SetLayout("Flow")
  headerContainer:SetPoint("TOPLEFT", parentFrame.frame, "TOPLEFT", 20, 0)
  parentFrame:AddChild(headerContainer)

  --Back button
  ---@type AceGUIButton
  local backButton = AceGUI:Create("Button")
  local backIcon = "|TInterface\\AddOns\\LogBook\\Images\\back:16:16|t"
  backButton:SetWidth(140)
  backButton:SetPoint("TOPLEFT", parentFrame.frame, "TOPLEFT", 20, -15)
  backButton:SetText(backIcon .. " " .. LogBookZones:i18n('Back'))
  backButton:SetCallback("OnClick", function()
    LB_SlashCommands:OpenWelcomeWindow()
  end)
  parentFrame:AddChild(backButton)

  --Options button
  ---@type AceGUIButton
  local settingsButton = AceGUI:Create("Button")
  local settingsIcon = "|TInterface\\AddOns\\LogBook\\Images\\settings:16:16|t"
  settingsButton:SetWidth(140)
  settingsButton:SetPoint("TOPRIGHT", parentFrame.frame, "TOPRIGHT", -20, -15)
  settingsButton:SetText(settingsIcon .. " " .. LogBookZones:i18n('Settings'))
  settingsButton:SetCallback("OnClick", function()
    LB_SlashCommands:OpenSettingsWindow()
  end)
  parentFrame:AddChild(settingsButton)
end
