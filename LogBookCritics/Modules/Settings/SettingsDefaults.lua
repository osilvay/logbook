---@class LBC_SettingsDefaults
local LBC_SettingsDefaults = LB_ModuleLoader:CreateModule("LBC_SettingsDefaults");

function LBC_SettingsDefaults:Load()
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
					spells = { -- personal spells
					},
				},
			},
		},
		char = {
			general = {
				critics = {
					trackingEnabled = true,
					trackHits = true,
					trackHeals = true,
					trackSwings = true,
					
					trackNormalHeals = true,
					trackCriticHeals = true,
					trackLowestHeals = true,
					trackHighestHeals = true,

					trackCriticalHits = true,
					trackNormalHits = true,
					trackLowestHits = true,
					trackHighestHits = true,

					trackCriticalSwings = true,
					trackNormalSwings = true,
					trackLowestSwings = true,
					trackHighestSwings = true,

					unlockTextFrame = false,
					textFrameBgColorAlpha = 0,
					splashFrameOffset = {
						xOffset = 0,
						yOffset = 200
					},
					lowestHitColor = {
						red = 0.886,
						green = 0.250,
						blue = 0.250,
						alpha = 1,
					},
					highestHitColor = {
						red = 0.250,
						green = 0.886,
						blue = 0.337,
						alpha = 1,
					},
					lowestHealColor = {
						red = 0.886,
						green = 0.250,
						blue = 0.250,
						alpha = 1,
					},
					highestHealColor = {
						red = 0.250,
						green = 0.886,
						blue = 0.337,
						alpha = 1,
					},

					lowestSwingColor = {
						red = 0.886,
						green = 0.250,
						blue = 0.250,
						alpha = 1,
					},
					highestSwingColor = {
						red = 0.250,
						green = 0.886,
						blue = 0.337,
						alpha = 1,
					},

					hitCriticalColor = {
						red = 0.960,
						green = 0.913,
						blue = 0.121,
						alpha = 1,
					},
					hitNormalColor = {
						red = 1,
						green = 0.960,
						blue = 0.600,
						alpha = 1,
					},
					healCriticalColor = {
						red = 0.313,
						green = 0.941,
						blue = 0.121,
						alpha = 1,
					},
					healNormalColor = {
						red = 0.694,
						green = 1,
						blue = 0.6,
						alpha = 1,
					},

					swingCriticalColor = {
						red = 0.760,
						green = 0.760,
						blue = 0.860,
						alpha = 1,
					},
					swingNormalColor = {
						red = 0.560,
						green = 0.560,
						blue = 0.660,
						alpha = 1,
					},

					filter = {
						search_criteria = "",
						select_character = "all",
						select_type = "all",
						select_realm = "all"
					},
				},
			},
		},
	}
end