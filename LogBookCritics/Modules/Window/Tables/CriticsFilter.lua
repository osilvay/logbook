---@class LBC_CriticsFilter
local LBC_CriticsFilter = LB_ModuleLoader:CreateModule("LBC_CriticsFilter")

---@type LBC_CriticsWindow
local LBC_CriticsWindow = LB_ModuleLoader:ImportModule("LBC_CriticsWindow")

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
function LBC_CriticsFilter:ContainerFilterFrame(containerTable, parentFrame)
  -- table
  local tableData = containerTable.table

  -- container
  ---@type AceGUIInlineGroup
  local filterContainer = AceGUI:Create("InlineGroup")
  filterContainer:SetFullWidth(true)
  filterContainer:SetWidth(460)
  filterContainer:SetHeight(140)
  filterContainer:SetTitle("Filter")
  filterContainer:SetLayout("Flow")
  filterContainer:SetPoint("TOPLEFT", parentFrame.frame, "TOPLEFT", 20, -40)
  parentFrame:AddChild(filterContainer)

  local selected_character = LogBookCritics.db.char.general.critics.filter.select_character
  --Character dropdown
  ---@type AceGUIDropdown
  local characterDropdown = AceGUI:Create("Dropdown")
  characterDropdown:SetRelativeWidth(0.45)
  characterDropdown:SetText(LogBookCritics:i18n('Character'))
  characterDropdown:SetLabel(LogBookCritics:i18n('Character'))
  characterDropdown:SetList(LBC_CriticsFilter:CreateCharactersDropdown())
  characterDropdown:SetCallback("OnValueChanged", function(widget, event, value)
    LogBookCritics.db.char.general.critics.filter.select_character = value
    LBC_CriticsWindow:RedrawCriticsWindowFrame()
  end)
  characterDropdown:SetValue(selected_character)
  filterContainer:AddChild(characterDropdown)

  --Separator
  ---@type AceGUILabel
  local separatorH1 = AceGUI:Create("Label")
  separatorH1:SetRelativeWidth(0.1)
  separatorH1:SetText("")
  filterContainer:AddChild(separatorH1)

  local select_type = LogBookCritics.db.char.general.critics.filter.select_type
  --Type dropdown
  ---@type AceGUIDropdown
  local typeDropdown = AceGUI:Create("Dropdown")
  typeDropdown:SetRelativeWidth(0.45)
  typeDropdown:SetText(LogBookCritics:i18n('Type'))
  typeDropdown:SetLabel(LogBookCritics:i18n('Type'))
  typeDropdown:SetList(LBC_CriticsFilter:CreateTypeDropdown())
  typeDropdown:SetCallback("OnValueChanged", function(widget, event, value)
    LogBookCritics.db.char.general.critics.filter.select_type = value
    LBC_CriticsWindow:RedrawCriticsWindowFrame()
  end)
  typeDropdown:SetValue(select_type)
  filterContainer:AddChild(typeDropdown)

  --Search criteria
  ---@type AceGUIEditBox
  local searchCriteriaInput = AceGUI:Create("EditBox")
  searchCriteriaInput:SetRelativeWidth(1)
  searchCriteriaInput:DisableButton(true)
  searchCriteriaInput:SetLabel(LogBookCritics:i18n('Search criteria'))
  searchCriteriaInput:SetText(LogBookCritics.db.char.general.critics.filter.search_criteria)
  searchCriteriaInput:SetCallback("OnTextChanged", function(widget, event, value)
    LogBookCritics.db.char.general.critics.filter.search_criteria = value
    LBC_CriticsWindow:RedrawCriticsWindowFrame()
  end)
  filterContainer:AddChild(searchCriteriaInput)
end

---Create character dropdown
function LBC_CriticsFilter:CreateCharactersDropdown()
  local r = {
    ["all"] = LogBookCritics:i18n("All"),
  }
  local characters = LogBookCritics.db.global.data.characters
  for k, v in pairs(characters) do
    local info = LogBook.db.global.characters[k].info
    if info then
      local realm = LB_CustomColors:GetColoredFaction(info.realm, info.factionName)
      local name = LB_CustomColors:GetColoredClass(info.name, info.classFilename)
      r[k] = string.format("%s - %s", realm, name)
    end
  end
  return r
end

---Create type dropdown
function LBC_CriticsFilter:CreateTypeDropdown()
  return {
    ["all"] = LogBookCritics:i18n("All"),
    ["hit"] = LB_CustomColors:Colorize(LB_CustomColors:CustomColors("HIT_NORMAL"), LogBookCritics:i18n("Harmful")),
    ["heal"] = LB_CustomColors:Colorize(LB_CustomColors:CustomColors("HEAL_NORMAL"), LogBookCritics:i18n("Healings")),
  }
end
