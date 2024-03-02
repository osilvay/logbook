---@class LBL_ConfigGroups
local LBL_ConfigGroups = LB_ModuleLoader:CreateModule("LBL_ConfigGroups");

---@type LBL_TooltipGroup
local LBL_TooltipGroup = LB_ModuleLoader:ImportModule("LBL_TooltipGroup")

---@type LBL_DatabaseGroup
local LBL_DatabaseGroup = LB_ModuleLoader:ImportModule("LBL_DatabaseGroup")

---Get
---@param key string
---@param method string
---@return function|table
function LBL_ConfigGroups:Get(key, method)
  if key == "tooltips" then
    return LBL_ConfigGroups:Method(LBL_TooltipGroup, method)
  elseif key == "database" then
    return LBL_ConfigGroups:Method(LBL_DatabaseGroup, method)
  end
  return {}
end

---Get method
---@param class any
---@param method string
---@return function|table
function LBL_ConfigGroups:Method(class, method)
  if method == "header" then
    return class:Header()
  elseif method == "config" then
    return class:Config()
  end
  return {}
end
