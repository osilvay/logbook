---@class LBF_SettingsDefaults
local LBF_SettingsDefaults = LB_ModuleLoader:CreateModule("LBF_SettingsDefaults");

function LBF_SettingsDefaults:Load()
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
					fishing = { -- personal spells
					},
				},
			},
		},
		char = {
			general = {
				fishing = {
				},
			},
		},
	}
end
