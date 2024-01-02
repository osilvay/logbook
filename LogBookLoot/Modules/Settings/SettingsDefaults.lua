---@class LBL_SettingsDefaults
local LBL_SettingsDefaults = LB_ModuleLoader:CreateModule("LBL_SettingsDefaults");

function LBL_SettingsDefaults:Load()
	return {
		global = {
			data = {
				characters = {
				},
				spells = { -- all spells
				},
				locale = {
				}
			},
			characters = {
				char = {
					info = {
					},
					loot = { -- personal spells
					},
				},
			},
		},
		char = {
			general = {
				loot = {
				},
			},
		},
	}
end
