---@class LBC_CriticsBody
local LBC_CriticsBody = LB_ModuleLoader:CreateModule("LBC_CriticsBody")

---@type LB_CustomColors
local LB_CustomColors = LB_ModuleLoader:ImportModule("LB_CustomColors")

---@type LB_CustomFunctions
local LB_CustomFunctions = LB_ModuleLoader:ImportModule("LB_CustomFunctions")

---@type LB_CustomFrames
local LB_CustomFrames = LB_ModuleLoader:ImportModule("LB_CustomFrames")

---@type LB_CustomPopup
local LB_CustomPopup = LB_ModuleLoader:ImportModule("LB_CustomPopup")

---@type LBC_CriticsFilter
local LBC_CriticsFilter = LB_ModuleLoader:ImportModule("LBC_CriticsFilter")

---@type LBC_CriticsWindow
local LBC_CriticsWindow = LB_ModuleLoader:ImportModule("LBC_CriticsWindow")

---@type LB_CustomMedias
local LB_CustomMedias = LB_ModuleLoader:ImportModule("LB_CustomMedias")

local LibStub = LibStub
local AceGUI = LibStub("AceGUI-3.0")
local bodyContainer

---Redraw body container
---@param containerTable table
---@param parentFrame AceGUIFrame
function LBC_CriticsBody:RedrawCriticsWindowBody(containerTable, parentFrame)
  bodyContainer:ReleaseChildren()
  LBC_CriticsBody:ContainerBodyFrame(containerTable, parentFrame)
end

---Create critics container body frame
function LBC_CriticsBody:ContainerBodyFrame(containerTable, parentFrame)
  -- table
  local tableData = containerTable.table

  if not bodyContainer then
    -- container
    ---@type AceGUIInlineGroup
    bodyContainer = AceGUI:Create("InlineGroup")
    bodyContainer:SetFullWidth(true)
    bodyContainer:SetWidth(500)
    bodyContainer:SetHeight(240)
    bodyContainer:SetTitle(LogBookCritics:LBC_i18n("Spell list"))
    bodyContainer:SetLayout("Flow")
    bodyContainer:SetPoint("TOPLEFT", parentFrame.frame, "TOPLEFT", 20, -180)
    parentFrame:AddChild(bodyContainer)
  end

  -- drawing header
  table.sort(tableData, function(k1, k2) return k1.order < k2.order end)
  local currentPositionX = 0
  for _, header in pairs(tableData.header) do
    if header ~= nil then
      ---@type AceGUILabel
      local label = AceGUI:Create("InteractiveLabel")
      label:SetWidth(header.width)
      label:SetHeight(header.height)
      label:SetText(header.text)
      local rgb = LB_CustomColors:HexToRgb(header.color, false)
      label:SetColor(rgb.r, rgb.g, rgb.b)
      label:SetPoint("LEFT", bodyContainer.frame, "LEFT", currentPositionX, 0)
      label:SetCallback("OnEnter", function()
        GameTooltip:SetOwner(UIParent, "ANCHOR_CURSOR")
        GameTooltip:SetText(header.description)
        GameTooltip:Show()
      end)
      label:SetCallback("OnLeave", function()
        GameTooltip:Hide()
      end)

      bodyContainer:AddChild(label)
      currentPositionX = currentPositionX + header.width
      --LogBook:Debug("Post X = " .. tostring(currentPositionX))
    end
  end

  -- table frame
  ---@type AceGUIInlineGroup
  local tableContainer = AceGUI:Create("SimpleGroup")
  tableContainer:SetFullWidth(true)
  --tableContainer:SetFullHeight(true)
  tableContainer:SetWidth(500)
  tableContainer:SetHeight(240)
  tableContainer:SetLayout("Fill")
  tableContainer:SetPoint("TOPLEFT", bodyContainer.frame, "TOPLEFT", 0, -60)
  bodyContainer:AddChild(tableContainer)

  -- scroll frame
  ---@type AceGUIScrollFrame
  local scrollContainer = AceGUI:Create("ScrollFrame")
  scrollContainer:SetFullWidth(true)
  scrollContainer:SetWidth(500)
  scrollContainer:SetHeight(240)
  scrollContainer:SetLayout("Flow")
  scrollContainer:SetPoint("TOPLEFT", tableContainer.frame, "TOPLEFT", 0, -50)
  tableContainer:AddChild(scrollContainer)

  -- drawing rows
  local rows = tableData.data.rows
  if rows == nil then return end
  -- sorting
  local sortedRows = {}
  for _, k in pairs(rows) do
    table.insert(sortedRows, k.details.spellName)
  end
  table.sort(sortedRows, function(v1, v2) return v1 < v2 end)
  for _, rowIndex in pairs(sortedRows) do
    if rowIndex ~= nil then
      local row = rows[rowIndex]
      local spellDetails = row.details
      local spellValues = row.values
      if spellDetails == nil then spellDetails = {} end
      if spellValues == nil then spellValues = {} end

      -- row container
      ---@type AceGUISimpleGroup
      local rowContainer = AceGUI:Create("SimpleGroup")
      rowContainer:SetFullWidth(true)
      rowContainer:SetHeight(80)
      rowContainer:SetPoint("TOPLEFT", 0, -60)
      rowContainer:SetLayout("Flow")
      scrollContainer:AddChild(rowContainer)

      -- cells

      -- spellID
      ---@type AceGUILabel
      local spellIDLabel = AceGUI:Create("Label")
      spellIDLabel:SetWidth(60)
      spellIDLabel:SetHeight(80)
      spellIDLabel:SetPoint("LEFT", rowContainer.frame, "LEFT", 0, -50)
      spellIDLabel:SetText(LB_CustomColors:Colorize(LB_CustomColors:CustomColors("ROWID"), spellDetails.spellID))
      spellIDLabel:SetColor(224, 224, 224)
      rowContainer:AddChild(spellIDLabel)

      -- image as class
      ---@type AceGUIIcon
      local classIcon = AceGUI:Create("Icon")
      local className = "ALL"
      local tooltip = LogBookCritics:LBC_i18n("Various classes")
      local classes = spellDetails.class
      if #classes == 1 then
        className = classes[1]
        local classID = LB_CustomFunctions:GetClassInfoByClassFilename(className)
        local className, _, _ = GetClassInfo(classID)
        tooltip = className
      end

      classIcon:SetWidth(16)
      classIcon:SetHeight(16)
      classIcon:SetImage(LB_CustomFunctions:GetClassIcon(className))
      classIcon:SetImageSize(16, 16)
      classIcon:SetPoint("TOPLEFT", parentFrame.frame, "TOPLEFT", 0, -50)
      classIcon:SetCallback("OnEnter", function()
        GameTooltip:SetOwner(UIParent, "ANCHOR_CURSOR")
        GameTooltip:SetText(tooltip)
        GameTooltip:Show()
      end)
      classIcon:SetCallback("OnLeave", function()
        GameTooltip:Hide()
      end)
      rowContainer:AddChild(classIcon)

      -- Spell name and icon
      local name, rank, icon, castTime, minRange, maxRange = GetSpellInfo(spellDetails.spellID)
      -- image as icon
      ---@type AceGUIIcon
      local spellIcon = AceGUI:Create("Icon")
      spellIcon:SetWidth(32)
      spellIcon:SetHeight(32)
      spellIcon:SetImage(icon)
      spellIcon:SetImageSize(28, 28)
      spellIcon:SetCallback("OnEnter", function()
        GameTooltip:SetOwner(UIParent, "ANCHOR_CURSOR")
        GameTooltip:SetHyperlink(spellDetails.spellLink)
        GameTooltip:Show()
      end)
      spellIcon:SetCallback("OnLeave", function()
        GameTooltip:Hide()
      end)
      rowContainer:AddChild(spellIcon)

      --spell name
      local rowSpellName = ""
      if spellValues.isHeal then
        rowSpellName = LB_CustomColors:Colorize(LB_CustomColors:CustomColors("HEAL_NORMAL"), spellDetails.spellName)
      else
        rowSpellName = LB_CustomColors:Colorize(LB_CustomColors:CustomColors("HIT_NORMAL"), spellDetails.spellName)
      end

      ---@type AceGUILabel
      local spellNameLabel = AceGUI:Create("Label")
      spellNameLabel:SetWidth(184)
      spellNameLabel:SetHeight(80)
      spellNameLabel:SetPoint("LEFT", rowContainer.frame, "LEFT", 0, -50)
      spellNameLabel:SetText(" " .. rowSpellName)
      spellNameLabel:SetColor(128, 241, 255)
      rowContainer:AddChild(spellNameLabel)

      -- normal
      local normalLowestValue, normalHighestValue = "", ""
      if spellValues.isHeal then
        normalLowestValue = LB_CustomColors:Colorize(LB_CustomColors:CustomColors("LOWEST_HEAL"), spellValues.lowestHeal)
        normalHighestValue = LB_CustomColors:Colorize(LB_CustomColors:CustomColors("HIGHEST_HEAL"), spellValues.highestHeal)
        if spellValues.lowestHeal == 0 then
          normalLowestValue = LB_CustomColors:Colorize(LB_CustomColors:CustomColors("UNDEFINED"), "-")
        end
        if spellValues.highestHeal == 0 then
          normalHighestValue = LB_CustomColors:Colorize(LB_CustomColors:CustomColors("UNDEFINED"), "-")
        end
      else
        normalLowestValue = LB_CustomColors:Colorize(LB_CustomColors:CustomColors("LOWEST_HEAL"), spellValues.lowestHit)
        normalHighestValue = LB_CustomColors:Colorize(LB_CustomColors:CustomColors("HIGHEST_HEAL"), spellValues.highestHit)
        if spellValues.lowestHit == 0 then
          normalLowestValue = LB_CustomColors:Colorize(LB_CustomColors:CustomColors("UNDEFINED"), "-")
        end
        if spellValues.highestHit == 0 then
          normalHighestValue = LB_CustomColors:Colorize(LB_CustomColors:CustomColors("UNDEFINED"), "-")
        end
      end

      ---@type AceGUILabel
      local normalLabel = AceGUI:Create("Label")
      normalLabel:SetWidth(60)
      normalLabel:SetHeight(80)
      normalLabel:SetPoint("LEFT", rowContainer.frame, "LEFT", 0, -50)
      normalLabel:SetText(normalLowestValue .. "\n" .. normalHighestValue)
      normalLabel:SetColor(255, 255, 255)
      rowContainer:AddChild(normalLabel)

      -- critical
      local normalLowestCritValue, normalHighestCritValue = "", ""
      if spellValues.isHeal then
        normalLowestCritValue = LB_CustomColors:Colorize(LB_CustomColors:CustomColors("LOWEST_HIT"), spellValues.lowestHealCrit)
        normalHighestCritValue = LB_CustomColors:Colorize(LB_CustomColors:CustomColors("HIGHEST_HIT"), spellValues.highestHealCrit)
        if spellValues.lowestHealCrit == 0 then
          normalLowestCritValue = LB_CustomColors:Colorize(LB_CustomColors:CustomColors("UNDEFINED"), "-")
        end
        if spellValues.highestHealCrit == 0 then
          normalHighestCritValue = LB_CustomColors:Colorize(LB_CustomColors:CustomColors("UNDEFINED"), "-")
        end
      else
        normalLowestCritValue = LB_CustomColors:Colorize(LB_CustomColors:CustomColors("LOWEST_HEAL"), spellValues.lowestHitCrit)
        normalHighestCritValue = LB_CustomColors:Colorize(LB_CustomColors:CustomColors("HIGHEST_HEAL"), spellValues.highestHitCrit)
        if spellValues.lowestHitCrit == 0 then
          normalLowestCritValue = LB_CustomColors:Colorize(LB_CustomColors:CustomColors("UNDEFINED"), "-")
        end
        if spellValues.highestHitCrit == 0 then
          normalHighestCritValue = LB_CustomColors:Colorize(LB_CustomColors:CustomColors("UNDEFINED"), "-")
        end
      end

      ---@type AceGUILabel
      local criticalLabel = AceGUI:Create("Label")
      criticalLabel:SetWidth(60)
      criticalLabel:SetHeight(80)
      criticalLabel:SetPoint("LEFT", rowContainer.frame, "LEFT", 0, -50)
      criticalLabel:SetText(normalLowestCritValue .. "\n" .. normalHighestCritValue)
      criticalLabel:SetColor(255, 255, 255)
      rowContainer:AddChild(criticalLabel)

      if LogBookCritics.db.char.general.critics.filter.select_character ~= "all" then
        --Options button
        ---@type AceGUIInteractiveLabel
        local deleteButton = AceGUI:Create("InteractiveLabel")
        local deleteIcon = LB_CustomMedias:GetIconFileAsLink("delete", 24, 24)
        local deleteIcon_a = LB_CustomMedias:GetIconFileAsLink("delete_a", 24, 24)
        deleteButton:SetWidth(32)
        deleteButton:SetPoint("LEFT", rowContainer.frame, "LEFT", 0, -50)
        deleteButton:SetText(deleteIcon_a)
        deleteButton:SetCallback("OnEnter", function(current)
          current:SetText(deleteIcon)
        end)
        deleteButton:SetCallback("OnLeave", function(current)
          current:SetText(deleteIcon_a)
        end)
        deleteButton:SetCallback("OnClick", function(current)
          --local _selected_character = LogBookCritics.db.char.general.critics.filter.select_character
          --LogBookCritics.db.global.characters[_selected_character].spells[current.rowIndex] = nil
          --LBC_CriticsFilter:RedrawCriticsWindowFilter(parentFrame)
          --LBC_CriticsWindow:RedrawCriticsWindowFrame()
          LB_CustomPopup:CreatePopup(LogBookCritics:LBC_i18n("Delete entry"), LogBookCritics:LBC_i18n("Are you sure you want to delete this entry?"), function()
            local _selected_character = LogBookCritics.db.char.general.critics.filter.select_character
            LogBookCritics.db.global.characters[_selected_character].spells[current.rowIndex] = nil
            LBC_CriticsFilter:RedrawCriticsWindowFilter(parentFrame)
            LBC_CriticsWindow:RedrawCriticsWindowFrame()
          end)
        end)
        deleteButton.rowIndex = rowIndex
        rowContainer:AddChild(deleteButton)
      end
    end
  end
end
