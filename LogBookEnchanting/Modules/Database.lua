---@class LBE_Database
local LBE_Database = LB_ModuleLoader:CreateModule("LBE_Database")

---@type LB_CustomColors
local LB_CustomColors = LB_ModuleLoader:ImportModule("LB_CustomColors")

---@type LB_CustomFunctions
local LB_CustomFunctions = LB_ModuleLoader:ImportModule("LB_CustomFunctions")

local essences = {}
local items = {}

function LBE_Database:Initialize()
  C_Timer.After(0.1, function()
    LBE_Database:UpdateDatabase(false)
  end)
end

local updateDbTimeoutTicker = nil
---Starts auto update database
function LBE_Database:StartAutoUpdateDatabase()
  local updateDbTimeout = LogBookEnchanting.db.char.general.enchanting.updateDbTimeout
  if updateDbTimeoutTicker == nil then
    local message = string.format(LogBook:LB_i18n("Starting database auto update: %s"), LogBookEnchanting:MessageWithAddonColor(LogBookEnchanting:LBE_i18n("Enchanting")))
    LogBook:Print(message)
    updateDbTimeoutTicker = C_Timer.NewTicker(updateDbTimeout * 60, function()
      LBE_Database:UpdateDatabase()
    end)
  end
end

---Cancels auto update database
function LBE_Database:CancelAutoUpdateDatabase()
  if updateDbTimeoutTicker ~= nil then
    local message = string.format(LogBook:LB_i18n("Cancelling database auto update: %s"), LogBookEnchanting:MessageWithAddonColor(LogBookEnchanting:LBE_i18n("Enchanting")))
    LogBook:Print(message)
    updateDbTimeoutTicker:Cancel()
    updateDbTimeoutTicker = nil
  end
end

---Update enchanting database
---@param silent? boolean
function LBE_Database:UpdateDatabase(silent)
  if silent == nil then silent = false end
  local lootDb = LogBookLoot.db.global.data.loot
  essences = {}
  items = {}

  -- leo esencias
  for itemID, currentEssence in pairs(lootDb) do
    local isTradeSkill = currentEssence["IsTradeSkill"] or false
    local tradeSkillInfo = currentEssence["TradeSkillInfo"] or {}
    local tradeSkillName = tradeSkillInfo.name or ""

    -- si es encantamiento la proceso
    if isTradeSkill and tradeSkillInfo ~= nil and tradeSkillName == "Enchanting" then
      local _, eItemLink, eItemQuality, eItemLevel, eItemMinLevel = GetItemInfo(itemID)

      currentEssence.Quality                                      = eItemQuality
      currentEssence.ItemLink                                     = eItemLink
      currentEssence.ItemLevel                                    = eItemLevel
      currentEssence.ItemMinLevel                                 = eItemMinLevel

      -- leo objetos de esencias
      local from                                                  = tradeSkillInfo.from or {}
      for currentItemID, itemInEssence in pairs(from) do
        local _, itemLink, itemQuality, itemLevel, itemMinLevel = GetItemInfo(currentItemID)
        itemInEssence.Quality = itemQuality
        itemInEssence.ItemLink = itemLink
        itemInEssence.ItemLevel = itemLevel
        itemInEssence.ItemMinLevel = itemMinLevel

        -- añado a bbdd de objetos y esencias
        essences[itemID] = LBE_Database:UpdateEssenceWithItems(itemID, itemInEssence, currentEssence)
        items[currentItemID] = LBE_Database:UpdateItemWithEssences(currentItemID, itemInEssence, currentEssence)
      end
    end
  end
  LogBookEnchanting.db.global.data.items = items
  LogBookEnchanting.db.global.data.essences = essences

  if not silent then
    local message = string.format(LogBook:LB_i18n("%s database update: %s"), LogBookEnchanting:MessageWithAddonColor(LogBookEnchanting:LBE_i18n("Enchanting")), string.format("|cff03f303%s|r", LogBook:LB_i18n("Done!")))
    LogBook:Print(message)
  end
end

---Table lenth
function LBE_Database:GetNumEntries()
  local itemsDb = LogBookEnchanting.db.global.data.items
  local essencesDb = LogBookEnchanting.db.global.data.essences
  if itemsDb == nil then itemsDb = {} end
  if essencesDb == nil then essencesDb = {} end
  return {
    [LogBookEnchanting:LBE_i18n("Items")] = LB_CustomFunctions:TableLength(itemsDb),
    [LogBookEnchanting:LBE_i18n("Essences")] = LB_CustomFunctions:TableLength(essencesDb),
  }
end

---Item exists in database
---@param itemID number
---@return table|nil itemInfo
function LBE_Database:EntryExistsInItemsDatabase(itemID)
  if itemID == nil then return end
  if items[itemID] ~= nil then
    return items[itemID]
  else
    return nil
  end
end

---Item exists in essences database
---@param itemID number
---@return table|nil itemInfo
function LBE_Database:EntryExistsInEssencesDatabase(itemID)
  if itemID == nil then return end
  if essences[itemID] ~= nil then
    return essences[itemID]
  else
    return nil
  end
end

---Update essences in item
---@param currentItemID number
---@param itemInEssence table
---@return table essencesInItem
function LBE_Database:UpdateItemWithEssences(currentItemID, itemInEssence, currentEssence)
  local savedItem = items[currentItemID] or {
    ItemName = itemInEssence.ItemName,
    ItemID = itemInEssence.ItemID,
    Quality = itemInEssence.Quality,
    Quantity = itemInEssence.Quantity,
    ItemLink = itemInEssence.ItemLink,
    ItemLevel = itemInEssence.ItemLevel,
    ItemMinLevel = itemInEssence.ItemMinLevel,
    ItemIcon = GetItemIcon(itemInEssence.ItemID)
  }

  if savedItem.Items ~= nil then savedItem.Items = nil end
  local savedEssences = savedItem.Essences or {}
  local currentEssenceItemID = currentEssence.ItemID
  local currentSavedEssence = savedEssences[currentEssenceItemID] or {}
  local newQuantity = (itemInEssence.Quantity or 0) + (currentSavedEssence.Quantity or 0)

  savedEssences[currentEssenceItemID] = {
    Items = itemInEssence.Items,
    ItemID = currentEssence.ItemID,
    ItemName = currentEssence.ItemName,
    Quantity = newQuantity,
    Quality = currentEssence.Quality,
    ItemLink = currentEssence.ItemLink,
    ItemLevel = currentEssence.ItemLevel,
    ItemMinLevel = currentEssence.ItemMinLevel,
    ItemIcon = GetItemIcon(currentEssence.ItemID)
  }
  savedItem.Essences = savedEssences
  return savedItem
end

---Update essences in item
---@param itemID number
---@param itemInEssence table
---@return table essencesInItem
function LBE_Database:UpdateEssenceWithItems(itemID, itemInEssence, currentEssence)
  local savedEssence = essences[itemID] or {
    ItemName = currentEssence.ItemName,
    ItemID = currentEssence.ItemID,
    Quantity = currentEssence.Quantity,
    Quality = currentEssence.Quality,
    ItemLink = currentEssence.ItemLink,
    ItemLevel = currentEssence.ItemLevel,
    ItemMinLevel = currentEssence.ItemMinLevel,
    ItemIcon = GetItemIcon(currentEssence.ItemID)
  }
  local savedItems = savedEssence.Items or {}
  local currentItemID = itemInEssence.ItemID
  local currentSavedItem = savedItems[currentItemID] or {}

  local newQuantity = (itemInEssence.Items or 0) + (currentSavedItem.Quantity or 0)
  savedItems[currentItemID] = {
    ItemID = itemInEssence.ItemID,
    ItemName = itemInEssence.ItemName,
    Quantity = newQuantity,
    Quality = itemInEssence.Quality,
    ItemLink = itemInEssence.ItemLink,
    ItemLevel = itemInEssence.ItemLevel,
    ItemMinLevel = itemInEssence.ItemMinLevel,
    ItemIcon = GetItemIcon(itemInEssence.ItemID)
  }
  savedEssence.Items = savedItems
  return savedEssence
end

--[[
    https://wowwiki-archive.fandom.com/wiki/Disenchanting_tables
    UNCOMMON

  5-15	[Strange Dust]	80,00 %	1-2x	[Lesser Magic Essence]	20,00 %	1-2x			1-2x
  16-20	[Strange Dust]	75,00 %	2-3x	[Greater Magic Essence]	20,00 %	1-2x	[Small Glimmering Shard]	5,00 %	1-2x
  21-25	[Strange Dust]	75,00 %	4-6x	[Lesser Astral Essence]	15,00 %	1-2x	[Small Glimmering Shard]	10,00 %	1-2x
  26-30	[Soul Dust]	75,00 %	1-2x	[Greater Astral Essence]	20,00 %	1-2x	[Large Glimmering Shard]	5,00 %	1-2x

  26-30	[Strange Dust]	20,00 %	1-2x	[Lesser Magic Essence]	80,00 %	1-2x			
  21-25	[Strange Dust]	20,00 %	2-3x	[Greater Magic Essence]	75,00 %	1-2x	[Small Glimmering Shard]	5,00 %	1x
  16-20	[Strange Dust]	15,00 %	4-6x	[Lesser Astral Essence]	75,00 %	1-2x	[Small Glimmering Shard]	10,00 %	1x
  26-30	[Soul Dust]	20,00 %	1-2x	[Greater Astral Essence]	75,00 %	1-2x	[Large Glimmering Shard]	5,00 %	1x

  RARE
  1-25 	[Small Glimmering Shard] 	100% 	1x
  26-30 	[Large Glimmering Shard] 	100% 	1x
  31-35 	[Small Glowing Shard] 	100% 	1x

  [10940] = { --strange-dust
  [11083] = { --soul-dust
  [10938] = { -- lesser-magic-essence
  [10939] = { -- greater-magic-essence
  [10998] = { --lesser-astral-essence
  [11082] = { --greater-astral-essence
  [10978] = { --small-glimmering-shard
  [11084] = { --large-glimmering-shard
  [11138] = { --small-glowing-shard
]]
function LBE_Database:GetExpectedDisenchantData()
  return {
    UNCOMMON = {
      [LogBookEnchanting:LBE_i18n("Armor")] = {
        {
          MinILevel = 5,
          MaxILevel = 15,
          ItemIDs = {
            [10940] = { --strange-dust
              Percent = 80,
              QuantityText = "1-2x"
            },
            [10938] = { -- lesser-magic-essence
              Percent = 20,
              QuantityText = "1-2x"
            },
          }
        },
        {
          MinILevel = 16,
          MaxILevel = 20,
          ItemIDs = {
            [10940] = { --strange-dust
              Percent = 75,
              QuantityText = "2-3x"
            },
            [10939] = { -- greater-magic-essence
              Percent = 20,
              QuantityText = "1-2x"
            },
            [10978] = { --small-glimmering-shard
              Percent = 5,
              QuantityText = "1-2x"
            }
          }
        },
        {
          MinILevel = 21,
          MaxILevel = 25,
          ItemIDs = {
            [10940] = { --strange-dust
              Percent = 75,
              QuantityText = "4-6x"
            },
            [10998] = { -- lesser-astral-essence
              Percent = 15,
              QuantityText = "1-2x"
            },
            [10978] = { --small-glimmering-shard
              Percent = 10,
              QuantityText = "1-2x"
            }
          }
        },
        {
          MinILevel = 26,
          MaxILevel = 30,
          ItemIDs = {
            [11083] = { --soul-dust
              Percent = 75,
              QuantityText = "1-2x"
            },
            [11082] = { -- greater-astral-essence
              Percent = 20,
              QuantityText = "1-2x"
            },
            [11084] = { --large-glimmering-shard
              Percent = 5,
              QuantityText = "1-2x"
            }
          }
        },
      },
      [LogBookEnchanting:LBE_i18n("Weapon")] = {
        {
          MinILevel = 5,
          MaxILevel = 15,
          ItemIDs = {
            [10940] = { --strange-dust
              Percent = 20,
              QuantityText = "1-2x"
            },
            [10938] = { -- lesser-magic-essence
              Percent = 80,
              QuantityText = "1-2x"
            },
          }
        },
        {
          MinILevel = 16,
          MaxILevel = 20,
          ItemIDs = {
            [10940] = { --strange-dust
              Percent = 20,
              QuantityText = "2-3x"
            },
            [10939] = { -- greater-magic-essence
              Percent = 75,
              QuantityText = "1-2x"
            },
            [10978] = { --small-glimmering-shard
              Percent = 5,
              QuantityText = "1x"
            }
          }
        },
        {
          MinILevel = 21,
          MaxILevel = 25,
          ItemIDs = {
            [10940] = { --strange-dust
              Percent = 15,
              QuantityText = "4-6x"
            },
            [10998] = { -- lesser-astral-essence
              Percent = 75,
              QuantityText = "1-2x"
            },
            [10978] = { --small-glimmering-shard
              Percent = 10,
              QuantityText = "1x"
            }
          }
        },
        {
          MinILevel = 26,
          MaxILevel = 30,
          ItemIDs = {
            [11083] = { --soul-dust
              Percent = 20,
              QuantityText = "1-2x"
            },
            [11082] = { -- greater-astral-essence
              Percent = 75,
              QuantityText = "1-2x"
            },
            [11084] = { --large-glimmering-shard
              Percent = 5,
              QuantityText = "1x"
            }
          }
        },
      }
    },
    RARE = {
      [LogBook:LB_i18n("All")] = {
        {
          MinILevel = 1,
          MaxILevel = 25,
          ItemIDs = {
            [10978] = {
              Percent = 100,
              QuantityText = "1x"
            },
          },
        },
        {
          MinILevel = 26,
          MaxILevel = 30,
          ItemIDs = {
            [11084] = {
              Percent = 100,
              QuantityText = "1x"
            },
          },
        },
        {
          MinILevel = 31,
          MaxILevel = 35,
          ItemIDs = {
            [11138] = {
              Percent = 100,
              QuantityText = "1x"
            },
          },
        },
      },
    },
  }
end
