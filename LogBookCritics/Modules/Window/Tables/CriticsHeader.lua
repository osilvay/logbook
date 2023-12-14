---@class LBC_CriticsHeader
local LBC_CriticsHeader = LB_ModuleLoader:CreateModule("LBC_CriticsHeader")

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

---Create critics fiter frame
---@param containerTable table
---@param parentFrame AceGUIFrame
function LBC_CriticsHeader:ContainerHeaderFrame(containerTable, parentFrame)
  -- table
  local tableData = containerTable.table

  -- container
  ---@type AceGUIInlineGroup
  local headerContainer = AceGUI:Create("SimpleGroup")
  headerContainer:SetFullWidth(true)
  headerContainer:SetWidth(480)
  headerContainer:SetHeight(40)
  headerContainer:SetLayout("Flow")
  headerContainer:SetPoint("TOPLEFT", parentFrame.frame, "TOPLEFT", 20, 0)
  parentFrame:AddChild(headerContainer)

  --Options button
  ---@type AceGUIButton
  local settingsButton = AceGUI:Create("Button")
  settingsButton:SetWidth(140)
  settingsButton:SetPoint("TOPRIGHT", parentFrame.frame, "TOPRIGHT", -20, -25)
  settingsButton:SetText(LogBookCritics:i18n('Settings'))
  settingsButton:SetCallback("OnClick", function()
    LB_SlashCommands:CloseAllFrames()
    LB_Settings:OpenSettingsFrame("tab_critics")
  end)
  parentFrame:AddChild(settingsButton)

  --[[
  -- spellID
  ---@type AceGUILabel
  local bookIconLabel = AceGUI:Create("Label")
  bookIconLabel:SetWidth(40)
  bookIconLabel:SetHeight(40)
  bookIconLabel:SetPoint("TOPLEFT", parentFrame.frame, "TOPLEFT", 20, -25)
  bookIconLabel:SetText("")
  bookIconLabel:SetImage(LB_CustomFunctions:GetCustomIcon("BOOK_5"))
  bookIconLabel:SetImageSize(40, 40)
  bookIconLabel:SetColor(224, 224, 224)
  parentFrame:AddChild(bookIconLabel)

  local frame = CreateFrame("Frame")
		frame.class_id = "class id"
		frame.class_name = "Title"
		--frame:SetParent(criticsWindowFrame)
		frame:SetPoint("TOPLEFT", criticsWindowFrame.frame, "TOPLEFT", 0, 0)
		frame:SetWidth(60)
		frame:SetHeight(20)
		frame:Hide()
		frame.instance_texture = frame:CreateTexture(nil, "OVERLAY")
		frame.instance_texture:SetDrawLayer("OVERLAY", 7)
		frame.instance_texture:SetVertexColor(1, 1, 1, 1)
		frame.instance_texture:SetPoint("TOPLEFT", frame, "TOPLEFT", 0, 0)
		frame.instance_texture:SetParent(frame)
		frame.instance_texture:SetDesaturated(true)
		--frame.instance_texture:Hide()

		-- image as icon
		---@type AceGUIIcon
		local spellIcon = AceGUI:Create("Icon")
		spellIcon:SetWidth(16)
		spellIcon:SetHeight(16)
		spellIcon:SetImage(LB_CustomFunctions:GetClassIcon("DRUID"))
		spellIcon:SetImageSize(16, 16)
		spellIcon:SetPoint("TOPLEFT", criticsWindowFrame.frame, "TOPLEFT", -20, -10)
		spellIcon:SetCallback("OnEnter", function()
			GameTooltip:SetOwner(UIParent, "ANCHOR_CURSOR")
			GameTooltip:SetText("Druid")
			GameTooltip:Show()
		end)
		spellIcon:SetCallback("OnLeave", function()
			GameTooltip:Hide()
		end)
		criticsWindowFrame:AddChild(spellIcon)]]
end
