---@class LB_WelcomeHeader
local LB_WelcomeHeader = LB_ModuleLoader:CreateModule("LB_WelcomeHeader")

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

---Create loot fiter frame
---@param containerTable table
---@param parentFrame AceGUIFrame
function LB_WelcomeHeader:ContainerHeaderFrame(containerTable, parentFrame)
  -- container
  ---@type AceGUIInlineGroup
  local headerContainer = AceGUI:Create("SimpleGroup")
  headerContainer:SetFullWidth(true)
  headerContainer:SetWidth(500)
  headerContainer:SetHeight(40)
  headerContainer:SetLayout("Flow")
  headerContainer:SetPoint("TOPLEFT", parentFrame.frame, "TOPLEFT", 20, 0)
  parentFrame:AddChild(headerContainer)

  --Options button
  ---@type AceGUIButton
  local settingsButton = AceGUI:Create("Button")
  local settingsIcon = "|TInterface\\AddOns\\LogBook\\Images\\settings:16:16|t"
  settingsButton:SetWidth(140)
  settingsButton:SetPoint("TOPRIGHT", parentFrame.frame, "TOPRIGHT", -20, -15)
  settingsButton:SetText(settingsIcon .. " " .. LogBook:i18n('Settings'))
  settingsButton:SetCallback("OnClick", function()
    LB_SlashCommands:OpenSettingsWindow()
  end)
  parentFrame:AddChild(settingsButton)
end
