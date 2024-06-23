-- ┌────────────────────────────────────────────────────────────────────────────────────────────────────┐                                                                                                     
-- │ _/_/_/_/_/  _/    _/  _/      _/    _/_/_/    _/_/_/  _/_/_/_/_/  _/_/_/_/  _/      _/  _/      _/ │    
-- │    _/      _/    _/  _/_/    _/  _/        _/            _/      _/        _/_/    _/    _/  _/    │   
-- │   _/      _/    _/  _/  _/  _/  _/  _/_/    _/_/        _/      _/_/_/    _/  _/  _/      _/       │   
-- │  _/      _/    _/  _/    _/_/  _/    _/        _/      _/      _/        _/    _/_/    _/  _/      │   
-- │ _/        _/_/    _/      _/    _/_/_/  _/_/_/        _/      _/_/_/_/  _/      _/  _/      _/     │   
-- ├────────────────────────────────────────────────────────────────────────────────────────────────────┤
-- │ © Copyright 2024                                                                                   │ 
-- ├────────────────────────────────────────────────────────────────────────────────────────────────────┤
-- │ Credits:                                                                                           │
-- │   Braven's CommonSense mod                                                                         │
-- │   Workshop ID: 2875848298                                                                          │
-- │   Mod ID: BB_CommonSense                                                                           │
-- └────────────────────────────────────────────────────────────────────────────────────────────────────┘
--
-- TODO:
-- 1. Pick sounds
-- 2. Pick animations

require "TimedActions/ISBaseTimedAction"
UNSTimedAction = ISBaseTimedAction:derive("UNSTimedAction")
UNSTimedAction.DEBUG = UNSTimedAction.DEBUG or {}
UNSTimedAction.DEBUG.info = getDebug() or false
UNSTimedAction.DEBUG.trace = true

UNSTimedAction.isValid = function(self)
  return true
end

-- TODO: Animations and Util functions
UNSTimedAction.start = function(self)
  if UNSTimedAction.DEBUG.trace then print("UNSTimedAction.start") end
  
  UNSSoundUtils.playSoundClip(self.character, "WindowRattle")
  self:setActionAnim("BlowTorchFloor")
  self.character:faceThisObject(self.lockedObject)
end

-- TODO: Animations and Util functions
UNSTimedAction.stop = function(self)
  if UNSTimedAction.DEBUG.trace then print("UNSTimedAction.stop") end  
  UNSSoundUtils.stopSoundClip(self.character, "WindowRattle")
  ISBaseTimedAction.stop(self)
end

local function isSuccessfull(player, nimbleLevel, failBoost)
  if player:HasTrait("Burglar") then
    return (ZombRand(10) > 1)
  end

  local succeedChance = ZombRand(100)
  local failChance = (180 / nimbleLevel) + failBoost

  failChance = failChance * SandboxVars.UnJunk.BypassChanceMultiplier
  return (succeedChance > failChance)
end

local function returnTool(self)
  if self.container == nil then return end
  local tool = self.character:getPrimaryHandItem(); if not tool then return end
  local currentToolContainer = tool:getContainer(); if not currentToolContainer then return end
  if self.container ~= currentToolContainer then
    ISTimedActionQueue.add(ISInventoryTransferAction:new(self.character, tool, currentToolContainer, self.container))
  elseif tool:isEquipped() then
    ISTimedActionQueue.add(ISUnequipAction:new(self.character, tool, 50))
  end
end

local function removeTool(self)
  local tool = self.character:getPrimaryHandItem(); if not tool then return end
  self.character:setPrimaryHandItem(nil)
end

UNSTimedAction.update = function(self)
  self.character:faceThisObject(self.lockedObject)
  UNSSoundUtils.playSoundClip(self.character, "WindowRattle")
end

UNSTimedAction.waitToStart = function(self)
  self.character:faceThisObject(self.lockedObject)
  return self.character:shouldBeTurning()
end

UNSTimedAction.perform = function(self)
  if UNSTimedAction.DEBUG.trace then print("UNSTimedAction.perform") end
  local nimbleLevel = self.character:getPerkLevel(Perks.Nimble) + 1
  if self.typeTimeAction == UnJunk.BYPASS_DOOR then
    local success = true --isSuccessfull(self.character, nimbleLevel, 0)
    if success then
      UNSServer.unlockDoorOpen(self.lockedObject, self.character)
      returnTool(self)
    else
      if nimbleLevel < 6 and ZombRand(10) > 5 then
        -- Oops broke the skelenton key off in the lock
        self.character:Say(getText("IGUI_Skelenton_fail_2"))
        -- break lock
        UNSServer.breakLockDoor(self.worldObjects, self.lockedObject, self.character)
        -- remove tool
        removeTool(self)
      else
        self.character:Say(getText("IGUI_Skelenton_fail_1"))
        self.character:getXp():AddXP(Perks.Nimble, 0.25)
        -- TODO: Figure out what sound
        --if BB_CS_Utils.GetProperSound(self.lockedObject, true) == "Wooden" then
        --  BB_CS_Utils.TryplaySoundClip(self.character, "BreakLockOnWindow")
        --else
        --  BB_CS_Utils.TryplaySoundClip(self.character, "MetalBarBreak")
        --end
      end
    end
  else
    -- TODO: Figure out what sound
    --UNSSoundUtils.stopSoundClip(self.character, BB_CS_Utils.GetProperSound(self.lockedObject, false))

    if isSuccessfull(self.character, nimbleLevel, 20) == true then
      local args = {vehicle = self.vehicleID, part = self.lockedObjectID, locked = false, open = true}
      sendClientCommand(self.character, 'vehicle', 'setDoorLocked', args)
      sendClientCommand(self.character, 'vehicle', 'setDoorOpen', args)

      local isTrunk = self.lockedObjectID == "TrunkDoor" or self.lockedObjectID == "DoorRear"
      if not (isTrunk) then
        --BB_CS_Utils.TryplaySoundClip(self.character, "VehicleDoorOpen")
      else
        --BB_CS_Utils.TryplaySoundClip(self.character, "VehicleTrunkOpen")
      end

      self.character:getXp():AddXP(Perks.Nimble, 10)
      returnTool(self)
    else
      if nimbleLevel < 6 and ZombRand(10) > 5 then
        -- Oops broke the skelenton key off in the lock
        self.character:Say(getText("IGUI_Skelenton_fail_2"))
        -- break lock
        local args = {vehicle = self.vehicleID, part = self.lockedObjectID, locked = true, open = false, breakLocked = true}        
        sendClientCommand(self.character, 'vehicle', 'setDoorOpen', args)
        sendClientCommand(self.character, 'vehicle', 'setDoorLocked', args)
        -- remove tool
        removeTool(self)
      else
        self.character:Say(getText("IGUI_Skelenton_fail_2"))
        self.character:getXp():AddXP(Perks.Nimble, 0.25)
        -- TODO: Figure out what sound
        --if BB_CS_Utils.GetProperSound(self.lockedObject, true) == "Wooden" then
        --  BB_CS_Utils.TryplaySoundClip(self.character, "BreakLockOnWindow")
        --else
        --  BB_CS_Utils.TryplaySoundClip(self.character, "MetalBarBreak")
        --end
      end
    end
  end

  ISBaseTimedAction.perform(self)
end

function UNSTimedAction.bypass(self, character, container, time, typeTimeAction)
  if UNSTimedAction.DEBUG.trace then print("bypass: character      ", character) end
  if UNSTimedAction.DEBUG.trace then print("bypass: container      ", container) end
  if UNSTimedAction.DEBUG.trace then print("bypass: time           ", time) end
  if UNSTimedAction.DEBUG.trace then print("bypass: typeTimeAction ", typeTimeAction) end
  local o = {}
  setmetatable(o, self)
  self.__index = self
  o.character = character
  o.container = container
  o.stopOnWalk = true
	o.stopOnRun = true
--  o.fromHotbar = false
  o.typeTimeAction = typeTimeAction
  o.maxTime = time -- Time take by the action
  if o.character:isTimedActionInstant() then o.maxTime = 1 end
  if UNSTimedAction.DEBUG.trace then print("UNSTimedAction done") end
  return o
end

function UNSTimedAction:bypassDoor(worldobjects, lockedObject, character, container, time)
  if UNSTimedAction.DEBUG.trace then print("UNSTimedAction.bypassDoor: worldobjects ", worldobjects) end
  if UNSTimedAction.DEBUG.trace then print("UNSTimedAction.bypassDoor: lockedObject ", lockedObject) end
  if UNSTimedAction.DEBUG.trace then print("UNSTimedAction.bypassDoor: character    ", character) end
  if UNSTimedAction.DEBUG.trace then print("UNSTimedAction.bypassDoor: container    ", container) end
  if UNSTimedAction.DEBUG.trace then print("UNSTimedAction.bypassDoor: time         ", time) end
  local action = UNSTimedAction.bypass(self, character, container, time, UnJunk.BYPASS_DOOR)
  action.worldObjects = worldObjects
  action.lockedObject = lockedObject
  return action
end

function UNSTimedAction.bypassVehicleDoor(lockedObject, character, container, time)
  local action = UNSTimedAction:bypass(self, character, container, time, UnJunk.BYPASS_VEHICLE_DOOR)
  action.vehicleID = vehicle:getId()
  action.lockedObjectID = lockedObject:getId()
  return action
end

return TimeAction
                                                                                                     

