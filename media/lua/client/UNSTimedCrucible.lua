--[[
┌────────────────────────────────────────────────────────────────────────────────────────────────────┐
│ _/_/_/_/_/  _/    _/  _/      _/    _/_/_/    _/_/_/  _/_/_/_/_/  _/_/_/_/  _/      _/  _/      _/ │    
│    _/      _/    _/  _/_/    _/  _/        _/            _/      _/        _/_/    _/    _/  _/    │   
│   _/      _/    _/  _/  _/  _/  _/  _/_/    _/_/        _/      _/_/_/    _/  _/  _/      _/       │   
│  _/      _/    _/  _/    _/_/  _/    _/        _/      _/      _/        _/    _/_/    _/  _/      │   
│ _/        _/_/    _/      _/    _/_/_/  _/_/_/        _/      _/_/_/_/  _/      _/  _/      _/     │   
├────────────────────────────────────────────────────────────────────────────────────────────────────┤
│ © Copyright 2024                                                                                   │ 
└────────────────────────────────────────────────────────────────────────────────────────────────────┘
]]

require "TimedActions/ISBaseTimedAction"
UNSTimedCrucible = ISBaseTimedAction:derive("UNSTimedCrucible")
UNSTimedCrucible.DEBUG = UNSTimedCrucible.DEBUG or {}
UNSTimedCrucible.DEBUG.info = getDebug() or false
UNSTimedCrucible.DEBUG.trace = false -- true

-- Trigger every game update when the action is perform
function UNSTimedCrucible:update() 
    -- print("Action is update");
end

-- Wait until return false
function UNSTimedCrucible:waitToStart() 
  return false;
end

-- Equips a primary tool for the player
-- @param object any
-- @param playerNum number
-- @param tool string
-- @return InventoryItem|nil
function UNSTimedCrucible.equipToolPrimary(player, playerNum, tool)
  local item = nil
  local inv = player:getInventory()
  item = UNSTools.getAvailableTool(inv, tool)
  if not item then return end

  if instanceof(item, "Clothing") then
    if not item:isEquipped() then
      ISInventoryPaneContextMenu.wearItem(item, playerNum)
    end
  else
    ISInventoryPaneContextMenu.equipWeapon(item, true, item:isTwoHandWeapon(), playerNum)
  end
  return item
end

-- Equips a secondary tool for the player
-- @param object any
-- @param playerNum number
-- @param tool string
-- @return InventoryItem|nil
function UNSTimedCrucible.equipToolSecondary(player, playerNum, tool)
  local item = nil
  local inv = player:getInventory()
  item = UNSTools.getAvailableTool(inv, tool)
  if not item then return end

  if instanceof(item, "Clothing") then
    if not item:isEquipped() then
      ISInventoryPaneContextMenu.wearItem(item, playerNum)
    end
  end
  return item
end


function UNSTimedCrucible:isValid()
  -- print("isValid")
  return true
end


function UNSTimedCrucible:start()
  if UNSTimedCrucible.DEBUG.info then print("start") end
  self:setActionAnim("BlowTorch")
  self:setAnimVariable("LootPosition", "Low")
  self.character:getEmitter():playSound("DigFurrowWithTrowel")
  --self.character:getEmitter():playSound("BlowTorch")
end

-- TODO: Play sound BuildMetalStructureMedium
function UNSTimedCrucible:stop()
  if UNSTimedCrucible.DEBUG.info then print("stop") end
  ISBaseTimedAction.stop(self)
end

function UNSTimedCrucible:perform()
  if UNSTimedCrucible.DEBUG.info then print("perform") end
  if self.item then
    local useWater = self.item:getType() == "Mugl" or self.item:getType() == "MugRed" or self.item:getType() == "MugWhite" or self.item:getType() == "MugSpiffo"
    local newItem = nil
  
    if self.which >= 1 and self.which <= 10 then
      local allGood = true
      --Tools
      local neededTools = UNSRecipe.CRUCIBLE.neededTools
      if neededTools and #neededTools >= 1 then
        local item = UNSTimedCrucible.equipToolPrimary(self.character, self.character:getPlayerNum(), neededTools[1])

        if not item or not instanceof(item, "InventoryItem") then
          error("[UNS ERROR] " .. string.format("No tool for: %s", neededTools[1] or "nil"))
          return
        end

        if neededTools[2] then
          local secondItem = UNSTimedCrucible.equipToolSecondary(self.character, self.character:getPlayerNum(), neededTools[2])

          if not secondItem or not instanceof(secondItem, "InventoryItem") then
            error("[UNS ERROR] " .. string.format("No tool for: %s", neededTools[2] or "nil"))
            return
          end
        end
      end
      -- TODO: maybe test before use?
      if UNSRecipe.CRUCIBLE.useConsumable then
        for _, consumable in pairs(UNSRecipe.CRUCIBLE.useConsumable) do
          if consumable.Consumable ~= "Base.Water" or (consumable.Consumable == "Base.Water" and useWater) then
            local ok = UNSMenuAmmo.useMaterial(self.character, consumable.Consumable, consumable.Amount)
            if not ok then
              error("[UNS ERROR] " .. string.format("Could not consume item for: %s", consumable.Consumable or "nil"))
              allGood = false
            end
          end
        end
      end
      if not allGood then
        ISBaseTimedAction.perform(self)
        return
      end
      if UNSRecipe.CRUCIBLE.skills then
        for _, skill in pairs(UNSRecipe.CRUCIBLE.skills) do
          -- Increa players's skill
        end
      end
      newItem = InventoryItemFactory.CreateItem(UNSMenuAmmo.TYPE_OF_CRUCIBLES[self.which])
      if newItem then
        self.character:getInventory():Remove(self.item)
        self.character:getInventory():AddItem(newItem)
      else
        error("[UNS ERROR] " .. string.format("Could not make new item for: %s", itemTypes[self.which] or "nil"))
      end      
    end
    
    if UNSTimedCrucible.DEBUG.trace then print("") end
  end
  ISBaseTimedAction.perform(self)
end

function UNSTimedCrucible:new(character, item, which, time)
  
  local o = {}
  setmetatable(o, self)
  self.__index = self
  o.character = character
  o.item = item
  o.which = which
  o.stopOnWalk = true
	o.stopOnRun = true
  o.maxTime = time -- Time take by the action
  if o.character:isTimedActionInstant() then o.maxTime = 1 end
  if UNSTimedCrucible.DEBUG.trace then print("UNSTA done") end
  return o
end