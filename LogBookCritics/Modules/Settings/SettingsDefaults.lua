---@class LBC_SettingsDefaults
local LBC_SettingsDefaults = LB_ModuleLoader:CreateModule("LBC_SettingsDefaults");

function LBC_SettingsDefaults:Load()
	return {
		global = {
			data = {
				characters = {
				},
				spells = { -- all spells
				}
			},
			characters = {
				char = {
					info = {
					},
					spells = { -- personal spells
					},
				},
			},
		},
		char = {
			general = {
				trackCritics = true,
				critics = {
					filter = {
						select_character = "all",
						select_type = "all",
						select_realm = "all"
					},
				},
			},
		},
	}
end
