---@class LBL_DatabaseGroup
local LBL_DatabaseGroup = LB_ModuleLoader:CreateModule("LBL_DatabaseGroup");

---@type LB_CustomConfig
local LB_CustomConfig = LB_ModuleLoader:ImportModule("LB_CustomConfig")

---@type LBL_Database
local LBL_Database = LB_ModuleLoader:ImportModule("LBL_Database")

---@type LB_CustomFrames
local LB_CustomFrames = LB_ModuleLoader:ImportModule("LB_CustomFrames")

---@type LB_CustomPopup
local LB_CustomPopup = LB_ModuleLoader:ImportModule("LB_CustomPopup")

function LBL_DatabaseGroup:Header()
  return LB_CustomConfig:CreateHeaderConfig(LogBook:LB_i18n("Database"), 88, LogBookLoot:GetAddonColor())
end

function LBL_DatabaseGroup:Config()
  return {
    type = "group",
    order = 89,
    inline = true,
    name = "",
    args = {
      autoUpdateDb = {
        type = "toggle",
        order = 1,
        name = LogBook:LB_i18n("Auto update database"),
        desc = LogBook:LB_i18n("Toggle update database automatically."),
        width = "full",
        disabled = false,
        get = function() return LogBookEnchanting.db.char.general.enchanting.autoUpdateDb end,
        set = function(info, value)
          LogBookEnchanting.db.char.general.enchanting.autoUpdateDb = value
          if value then
            C_Timer.After(0.1, function()
              LBL_Database:StartAutoUpdateDatabase()
            end)
          else
            C_Timer.After(0.1, function()
              LBL_Database:CancelAutoUpdateDatabase()
            end)
          end
        end,
      },
      updateDbTimeout = {
        type = "range",
        order = 2,
        name = LogBook:LB_i18n("Database update time"),
        desc = LogBook:LB_i18n("Sets how often the database is updated (in minutes)."),
        width = "full",
        min = 5,
        max = 60,
        step = 1,
        disabled = function() return (not LogBookEnchanting.db.char.general.enchanting.autoUpdateDb); end,
        get = function() return LogBookEnchanting.db.char.general.enchanting.updateDbTimeout end,
        set = function(info, value)
          LogBookEnchanting.db.char.general.enchanting.updateDbTimeout = value
        end,
      },
      separator_1 = LB_CustomFrames:Spacer(2.5, false),
      executeUpdateDb = {
        type = "execute",
        order = 3,
        name = LogBook:LB_i18n("Manual update"),
        desc = LogBook:LB_i18n("Update database manually."),
        width = 2,
        disabled = false,
        func = function() return LBL_Database:UpdateDatabase() end,
      },
      cleanUpDb = {
        type = "execute",
        order = 4,
        name = LogBook:LB_i18n("Clean up database"),
        desc = LogBook:LB_i18n("Clean up all database."),
        width = 1,
        disabled = false,
        func = function() return nil end,
      },
      purgeDb = {
        type = "execute",
        order = 5,
        name = LogBook:LB_i18n("Purge database"),
        desc = LogBook:LB_i18n("Purge all database entries."),
        width = 1,
        disabled = false,
        func = function()
          LB_CustomPopup:CreatePopup(
            LogBook:LB_i18n("Purge database"),
            LogBook:LB_i18n("Are you sure you want to purge entire database?") .. "\n\n" .. " |cffff3300" .. LogBook:LB_i18n("This operation can not be undone...") .. "|r",
            function()
              return nil
            end)
        end,
      },
    }
  }
end
