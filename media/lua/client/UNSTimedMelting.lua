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
UNSTimedMelting = ISBaseTimedAction:derive("UNSTimedMelting")
UNSTimedMelting.LOG = UNSTimedMelting.LOG or {}
UNSTimedMelting.LOG.debug = getDebug() or false
UNSTimedMelting.LOG.trace = false -- true

function UNSTimedMelting:start()
  UNSSoundUtils.playSoundClip(self.character, "BlowTorch")
  self:setActionAnim("BlowTorch")
  self:setAnimVariable("LootPosition", "Low")
  self.character:faceThisObject(self.furnace)
end

function UNSTimedMelting:stop() 
  UNSSoundUtils.stopSoundClip(self.character, "BlowTorch")
  ISBaseTimedAction.stop(self)
end

function UNSTimedMelting:update() 
  self.character:faceThisObject(self.furnace)
end

function UNSTimedMelting:waitToStart() 
  self.character:faceThisObject(self.furnace)
  return self.character:shouldBeTurning()
end

-- Equips a primary tool for the player
-- @param object any
-- @param playerNum number
-- @param tool string
-- @return InventoryItem|nil
function UNSTimedMelting.equipToolPrimary(player, playerNum, tool)
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
function UNSTimedMelting.equipToolSecondary(player, playerNum, tool)
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


function UNSTimedMelting:isValid()
  return true
end

function UNSTimedMelting:perform()
  if UNSTimedMelting.LOG.debug then print("perform") end
  UNSSoundUtils.stopSoundClip(self.character, "BlowTorch")
  if self.item then    
    local newItems = {}
    local metalValue = self.item:getMetalValue()
    if metalValue == 1 then
      table.insert(newItems, InventoryItemFactory.CreateItem("ScrapMetal"))
    elseif metalValue > 1 then 
      for i = 0, (metalValue / 2) - 1 do
        table.insert(newItems, InventoryItemFactory.CreateItem("ScrapMetal"))
      end
    end
    if #newItems > 0 then
      self.character:getInventory():Remove(self.item)
      self.character:getInventory():Remove(self.charcoal)
      for _, newItem in pairs(newItems) do
        if #newItems < 10 then
          self.character:getInventory():AddItem(newItem)
        else
          self.character:getCurrentSquare():AddWorldInventoryItem(newItem, 0, 0, 0)
        end
      end
    else
      error("[UNS ERROR] " .. string.format("Could not make new item for: %s", newItemName or "nil"))
    end   
  end
  ISBaseTimedAction.perform(self)
end

function UNSTimedMelting.new(self, character, item, charcoal, furnace, time)
  local o = {}
  setmetatable(o, self)
  self.__index = self
  o.character = character
  o.item = item
  o.charcoal = charcoal
  o.furnace = furnace
  o.stopOnWalk = true
	o.stopOnRun = true
  o.maxTime = time -- Time take by the action
  if o.character:isTimedActionInstant() then o.maxTime = 1 end
  if UNSTimedMelting.LOG.trace then print("UNSTAC done") end
  return o
end