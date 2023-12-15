---@class LBC_CriticsWindow
local LBC_CriticsWindow = LB_ModuleLoader:CreateModule("LBC_CriticsWindow")

---@type LB_CustomColors
local LB_CustomColors = LB_ModuleLoader:ImportModule("LB_CustomColors")

---@type LB_CustomFunctions
local LB_CustomFunctions = LB_ModuleLoader:ImportModule("LB_CustomFunctions")

---@type LB_CustomFrames
local LB_CustomFrames = LB_ModuleLoader:ImportModule("LB_CustomFrames")

---@type LBC_CriticsHeader
local LBC_CriticsHeader = LB_ModuleLoader:ImportModule("LBC_CriticsHeader")

---@type LBC_CriticsBody
local LBC_CriticsBody = LB_ModuleLoader:ImportModule("LBC_CriticsBody")

---@type LBC_CriticsFilter
local LBC_CriticsFilter = LB_ModuleLoader:ImportModule("LBC_CriticsFilter")

-- Forward declaration
CriticsWindowFrame = nil

local LibStub = LibStub
local AceGUI = LibStub("AceGUI-3.0")

local tableData = {}

---Initilize
function LBC_CriticsWindow:Initialize()
	if not CriticsWindowFrame then
		LBC_CriticsWindow:CreateCriticsWindowTable()
		--LogBook:Debug("Creating critics window frame")

		---@type AceGUIFrame, AceGUIFrame
		local criticsWindowFrame = AceGUI:Create("Frame");
		criticsWindowFrame:SetWidth(500)
		criticsWindowFrame:SetHeight(520)
		criticsWindowFrame:SetLayout("Fill")
		criticsWindowFrame:SetTitle("|cffffffffLog|r|cff57b6ffBook|r |cfffff757Critics|r |cff57ff68v0.0.1|r")
		criticsWindowFrame:SetStatusText(LogBookCritics:i18n("LogBook critics management window"))
		criticsWindowFrame:EnableResize(false)
		criticsWindowFrame:Hide()

		criticsWindowFrame:SetCallback("OnClose", function(widget)
			PlaySound(840)
		end)

		-- header
		LBC_CriticsHeader:ContainerHeaderFrame(tableData, criticsWindowFrame)
		-- filter
		LBC_CriticsFilter:ContainerFilterFrame(criticsWindowFrame)
		-- table
		LBC_CriticsBody:ContainerBodyFrame(tableData, criticsWindowFrame)

		criticsWindowFrame:Hide()
		CriticsWindowFrame = criticsWindowFrame;

		-- Add the frame as a global variable under the name `MyGlobalFrameName`
		_G["LogBookCriticsWindowFrame"] = CriticsWindowFrame.frame
		-- Register the global variable `MyGlobalFrameName` as a "special frame"
		-- so that it is closed when the escape key is pressed.
		table.insert(UISpecialFrames, "LogBookCriticsWindowFrame")
	end
end

---Create critics window table data
function LBC_CriticsWindow:CreateCriticsWindowTable()
	if LB_CustomFunctions:EmptyOrNil(LogBookCritics.db.char.general.critics.filter.select_character) then
		LogBookCritics.db.char.general.critics.filter.select_character = "all"
	end
	if LB_CustomFunctions:EmptyOrNil(LogBookCritics.db.char.general.critics.filter.select_type) then
		LogBookCritics.db.char.general.critics.filter.select_type = "all"
	end
	if LB_CustomFunctions:EmptyOrNil(LogBookCritics.db.char.general.critics.filter.selected_realm) then
		LogBookCritics.db.char.general.critics.filter.selected_realm = "all"
	end

	tableData = {
		table = {
			header = {
				{
					text = LogBookCritics:i18n("ID"),
					description = LogBookCritics:i18n("ID of the spell."),
					order = 1,
					width = 60,
					height = 60,
					color = "FFFFCC00",
				},
				{
					text = LogBookCritics:i18n("Spell name"),
					description = LogBookCritics:i18n("Spell name and rank."),
					order = 2,
					width = 232,
					height = 60,
					color = "FFFFCC00",
				},
				{
					text = LogBookCritics:i18n("Normal"),
					description = LogBookCritics:i18n("Normal hit or heal."),
					order = 3,
					width = 60,
					height = 60,
					color = "FFFFCC00",
				},
				{
					text = LogBookCritics:i18n("Critic"),
					description = LogBookCritics:i18n("Critic hit or heal."),
					order = 4,
					width = 60,
					height = 60,
					color = "FFFFCC00",
				},
			},
			data = {
				rows = LBC_CriticsWindow:GenerateSpellList()
			}
		},
	}
end

---Hide crit window frame
function LBC_CriticsWindow:HideCriticsWindowFrame()
	if CriticsWindowFrame and CriticsWindowFrame:IsShown() then
		CriticsWindowFrame:Hide();
	end
end

---Open crit window
function LBC_CriticsWindow:OpenCriticsWindowFrame()
	if not CriticsWindowFrame then return end
	if not CriticsWindowFrame:IsShown() then
		PlaySound(882)
		--LogBook:Debug("Show CriticsWindow frame")
		LBC_CriticsWindow:GenerateSpellList()
		CriticsWindowFrame:Show()
	else
		--LogBook:Debug("Hide CriticsWindow frame")
		CriticsWindowFrame:Hide()
	end
end

---Redraw critics window frame
function LBC_CriticsWindow:RedrawCriticsWindowFrame()
	if not CriticsWindowFrame then return end
	if CriticsWindowFrame:IsShown() then
		tableData.table.data.rows = LBC_CriticsWindow:GenerateSpellList()
		LBC_CriticsBody:RedrawCriticsWindowBody(tableData, CriticsWindowFrame)
	end
end

---Generate spell list
---@return table
function LBC_CriticsWindow:GenerateSpellList()
	local r = {}
	local select_character = LogBookCritics.db.char.general.critics.filter.select_character
	local select_type = LogBookCritics.db.char.general.critics.filter.select_type
	local search_criteria = LogBookCritics.db.char.general.critics.filter.search_criteria
	--LogBook:Debug("Generating data..." .. select_character .. " - " .. select_type)

	-- filter by character
	local personal_spell_list = {}
	if select_character and select_character ~= "all" then
		personal_spell_list = LogBookCritics.db.global.characters[select_character].spells
	else
		local characters = LogBookCritics.db.global.data.characters
		for charKey, _ in pairs(characters) do
			if charKey ~= nil then
				local charData = LogBookCritics.db.global.characters[charKey]
				--LogBook:Debug("KEY = " .. charKey)
				if charData.spells ~= nil then
					for k, spells in pairs(charData.spells) do
						personal_spell_list[k] = spells
					end
				end
			end
		end
	end

	-- filter by type
	if select_type ~= "all" then
		local new_personal_spell_list = {}
		for k, v in pairs(personal_spell_list) do
			if select_type == "heal" and v.isHeal then
				new_personal_spell_list[k] = v
			elseif select_type == "hit" and not v.isHeal then
				new_personal_spell_list[k] = v
			end
		end
		personal_spell_list = new_personal_spell_list
	end

	-- filter by search criteria
	if search_criteria ~= nil and search_criteria ~= "" then
		local new_personal_spell_list = {}
		for k, v in pairs(personal_spell_list) do
			if string.match(string.upper(v.spellName), string.upper(search_criteria)) then
				new_personal_spell_list[k] = v
			end
		end
		personal_spell_list = new_personal_spell_list
	end
	if personal_spell_list ~= nil and select_character ~= nil then
		local index = 1
		for _, v in pairs(personal_spell_list) do
			--LogBook:Debug(string.format("%s - %d", v.spellName, v.spellID))
			local savedSpell = LogBookCritics.db.global.data.spells[v.spellName]
			r[v.spellName] = {
				details = savedSpell,
				values = v
			}
			index = index + 1
		end
	end
	return r
end
