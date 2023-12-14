-- The only public class except for LogBook
---@class LB_ModuleLoader
LB_ModuleLoader = {}

local modules = {}

LB_ModuleLoader._modules = modules -- store reference so modules can be iterated for profiling

---@generic T
---@param name `T` @Module name
---@return T|{ private: table } @Module reference
function LB_ModuleLoader:CreateModule(name)
  if (not modules[name]) then
    modules[name] = { private = {} }
    return modules[name]
  else
    return modules[name]
  end
end

---@generic T
---@param name `T` @Module name
---@return T|{ private: table } @Module reference
function LB_ModuleLoader:ImportModule(name)
  if (not modules[name]) then
    modules[name] = { private = {} }
    return modules[name]
  else
    return modules[name]
  end
end
