---@class LBZ_SettingsDefaults
local LBZ_SettingsDefaults = LB_ModuleLoader:CreateModule("LBZ_SettingsDefaults");

function LBZ_SettingsDefaults:Load()
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
					zones = { -- personal spells
					},
				},
			},
		},
		char = {
			general = {
				zones = {
				},
			},
		},
	}
end
