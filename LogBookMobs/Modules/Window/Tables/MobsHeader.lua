---@class LBM_MobsHeader
local LBM_MobsHeader = LB_ModuleLoader:CreateModule("LBM_MobsHeader")

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

---@type LB_CustomMedias
local LB_CustomMedias = LB_ModuleLoader:ImportModule("LB_CustomMedias")

local LibStub = LibStub
local AceGUI = LibStub("AceGUI-3.0")

---Create mobs fiter frame
---@param containerTable table
---@param parentFrame AceGUIFrame
function LBM_MobsHeader:ContainerHeaderFrame(containerTable, parentFrame)
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
  local backIcon = LB_CustomMedias:GetIconFileAsLink("back", 16, 16)
  backButton:SetWidth(140)
  backButton:SetPoint("TOPLEFT", parentFrame.frame, "TOPLEFT", 20, -15)
  backButton:SetText(backIcon .. " " .. LogBookMobs:LBM_i18n('Back'))
  backButton:SetCallback("OnClick", function()
    LB_SlashCommands:OpenWelcomeWindow()
  end)
  parentFrame:AddChild(backButton)

  --Options button
  ---@type AceGUIButton
  local settingsButton = AceGUI:Create("Button")
  local settingsIcon = LB_CustomMedias:GetIconFileAsLink("settings", 16, 16)
  settingsButton:SetWidth(140)
  settingsButton:SetPoint("TOPRIGHT", parentFrame.frame, "TOPRIGHT", -20, -15)
  settingsButton:SetText(settingsIcon .. " " .. LogBookMobs:LBM_i18n('Settings'))
  settingsButton:SetCallback("OnClick", function()
    LB_SlashCommands:OpenSettingsWindow()
  end)
  parentFrame:AddChild(settingsButton)
end
