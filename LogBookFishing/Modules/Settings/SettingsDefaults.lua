---@class LBF_SettingsDefaults
local LBF_SettingsDefaults = LB_ModuleLoader:CreateModule("LBF_SettingsDefaults");

function LBF_SettingsDefaults:Load()
	return {
		global = {
			data = {
				characters = {
				},
				fishing = { -- all fishing
				},
				locale = {
				}
			},
			characters = {
				char = {
					info = {
					},
					fishing = { -- personal fishing
					},
				},
			},
		},
		char = {
			general = {
				fishing = {
					trackingEnabled = true,
				},
			},
		},
	}
end
