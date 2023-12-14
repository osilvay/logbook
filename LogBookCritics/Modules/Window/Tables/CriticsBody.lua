---@class LBC_CriticsBody
local LBC_CriticsBody = LB_ModuleLoader:CreateModule("LBC_CriticsBody")

---@type LB_CustomColors
local LB_CustomColors = LB_ModuleLoader:ImportModule("LB_CustomColors")

---@type LB_CustomFunctions
local LB_CustomFunctions = LB_ModuleLoader:ImportModule("LB_CustomFunctions")

---@type LB_CustomFrames
local LB_CustomFrames = LB_ModuleLoader:ImportModule("LB_CustomFrames")

local LibStub = LibStub
local AceGUI = LibStub("AceGUI-3.0")
local bodyContainer

---Redraw body container
---@param containerTable table
---@param parentFrame AceGUIFrame
---@param redraw boolean
function LBC_CriticsBody:RedrawCriticsWindowBody(containerTable, parentFrame, redraw)
	bodyContainer:ReleaseChildren()
	LBC_CriticsBody:ContainerBodyFrame(containerTable, parentFrame, redraw)
end

---Create critics container body frame
function LBC_CriticsBody:ContainerBodyFrame(containerTable, parentFrame, redraw)
	-- table
	local tableData = containerTable.table

	if not bodyContainer then
		-- container
		---@type AceGUIInlineGroup
		bodyContainer = AceGUI:Create("InlineGroup")
		bodyContainer:SetFullWidth(true)
		bodyContainer:SetWidth(460)
		bodyContainer:SetHeight(240)
		bodyContainer:SetTitle(LogBookCritics:i18n("Spell list"))
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
			local rgb = LB_CustomColors:HexToRgb(header.color)
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
	tableContainer:SetWidth(460)
	tableContainer:SetHeight(240)
	tableContainer:SetLayout("Fill")
	tableContainer:SetPoint("TOPLEFT", bodyContainer.frame, "TOPLEFT", 0, -60)
	bodyContainer:AddChild(tableContainer)

	-- scroll frame
	---@type AceGUIScrollFrame
	local scrollContainer = AceGUI:Create("ScrollFrame")
	scrollContainer:SetFullWidth(true)
	scrollContainer:SetWidth(460)
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
			spellIDLabel:SetText(LB_CustomColors:Colorize(LB_CustomColors:CustomColors("SPELLID_COLOR"), spellDetails.spellID))
			spellIDLabel:SetColor(224, 224, 224)
			rowContainer:AddChild(spellIDLabel)

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
			spellNameLabel:SetWidth(200)
			spellNameLabel:SetHeight(80)
			spellNameLabel:SetPoint("LEFT", rowContainer.frame, "LEFT", 0, -50)
			spellNameLabel:SetText(" " .. rowSpellName)
			spellNameLabel:SetColor(128, 241, 255)
			rowContainer:AddChild(spellNameLabel)

			-- normal
			local normalLowestValue, normalHighestValue = "", ""
			if spellValues.isHeal then
				normalLowestValue = LB_CustomColors:Colorize(LB_CustomColors:CustomColors("LOWEST_COLOR"), spellValues
					.lowestHeal)
				normalHighestValue = LB_CustomColors:Colorize(LB_CustomColors:CustomColors("HIGHEST_COLOR"),
					spellValues.highestHeal)
				if spellValues.lowestHeal == 0 then
					normalLowestValue = LB_CustomColors:Colorize(
						LB_CustomColors:CustomColors("UNDEFINED_COLOR"), "-")
				end
				if spellValues.highestHeal == 0 then
					normalHighestValue = LB_CustomColors:Colorize(LB_CustomColors:CustomColors("UNDEFINED_COLOR"),
						"-")
				end
			else
				normalLowestValue = LB_CustomColors:Colorize(LB_CustomColors:CustomColors("LOWEST_COLOR"), spellValues.lowestHit)
				normalHighestValue = LB_CustomColors:Colorize(LB_CustomColors:CustomColors("HIGHEST_COLOR"),
					spellValues.highestHit)
				if spellValues.lowestHit == 0 then
					normalLowestValue = LB_CustomColors:Colorize(
						LB_CustomColors:CustomColors("UNDEFINED_COLOR"), "-")
				end
				if spellValues.highestHit == 0 then
					normalHighestValue = LB_CustomColors:Colorize(
						LB_CustomColors:CustomColors("UNDEFINED_COLOR"), "-")
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
				normalLowestCritValue = LB_CustomColors:Colorize(LB_CustomColors:CustomColors("LOWEST_COLOR"),
					spellValues.lowestHealCrit)
				normalHighestCritValue = LB_CustomColors:Colorize(LB_CustomColors:CustomColors("HIGHEST_COLOR"),
					spellValues.highestHealCrit)
				if spellValues.lowestHealCrit == 0 then
					normalLowestCritValue = LB_CustomColors:Colorize(
						LB_CustomColors:CustomColors("UNDEFINED_COLOR"), "-")
				end
				if spellValues.highestHealCrit == 0 then
					normalHighestCritValue = LB_CustomColors:Colorize(
						LB_CustomColors:CustomColors("UNDEFINED_COLOR"), "-")
				end
			else
				normalLowestCritValue = LB_CustomColors:Colorize(LB_CustomColors:CustomColors("LOWEST_COLOR"),
					spellValues.lowestHitCrit)
				normalHighestCritValue = LB_CustomColors:Colorize(LB_CustomColors:CustomColors("HIGHEST_COLOR"),
					spellValues.highestHitCrit)
				if spellValues.lowestHitCrit == 0 then
					normalLowestCritValue = LB_CustomColors:Colorize(
						LB_CustomColors:CustomColors("UNDEFINED_COLOR"), "-")
				end
				if spellValues.highestHitCrit == 0 then
					normalHighestCritValue = LB_CustomColors:Colorize(
						LB_CustomColors:CustomColors("UNDEFINED_COLOR"), "-")
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
		end
	end
end
