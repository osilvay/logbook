---@class LB_SettingsDefaults
local LB_SettingsDefaults = LB_ModuleLoader:CreateModule("LB_SettingsDefaults");

function LB_SettingsDefaults:Load()
	return {
		global = {
			data = {
				characters = {
				},
				locale = {
				}
			},
			characters = {
				char = {
					info = {
					},
				},
			},
		},
		char = {
			general = {
				criticalsModule = false,
			},
		},
	}
end
