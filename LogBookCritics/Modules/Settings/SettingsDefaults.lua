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
					trackAttacks = true,
					trackNormalHeals = true,
					trackCriticHeals = true,
					trackLowestHeals = true,
					trackHighestHeals = true,
					trackCriticalHits = true,
					trackNormalHits = true,
					trackLowestHits = true,
					trackHighestHits = true,
					trackCriticalAttacks = true,
					trackNormalAttacks = true,
					trackLowestAttacks = true,
					trackHighestAttacks = true,
					unlockTextFrame = false,
					textFrameBgColorAlpha = 0,
					splashFrameOffset = {
						xOffset = 0,
						yOffset = 200
					},
					lowestHitColor = {
					},
					highestHitColor = {
					},
					lowestHealColor = {
					},
					highestHealColor = {
					},
					lowestAttackColor = {
					},
					highestAttackColor = {
					},
					hitCriticalColor = {
					},
					hitNormalColor = {
					},
					healCriticalColor = {
					},
					healNormalColor = {
					},
					attackCriticalColor = {
					},
					attackNormalColor = {
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
