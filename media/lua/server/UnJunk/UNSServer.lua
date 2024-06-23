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

UNSServer = UNSServer or {}
UNSServer.DEBUG = getDebug() or false

--
-- This override can break the car door's lock if the args.breakLocked is set and is true
-- This override cannot fix a broken lock, i.e. can't setLockBroken(false)
-- @param String The name of the module for this client command.
-- @param String The text of the actual client command.
-- @param IsoPlayer The player who initiated the client command.
-- @param KahluaTable The arguments of the client command.
--
function UNSServer.onClientCommand(module, command, player, args)
  if module == 'vehicle' and command == 'setDoorLocked' then
    -- VehicleCommands will handle the door locking part
    local vehicle = getVehicleById(args.vehicle)
    if vehicle then
      local part = vehicle:getPartById(args.part)
      if not part then
        if UNSServer.DEBUG then print('no such part '..tostring(args.part)) end
        return
      end
      if not part:getDoor() then
        if UNSServer.DEBUG then print('part ' .. args.part .. ' has no door') end
        return
      end
      if args.breakLocked and not part:getDoor():isLockBroken() then
        part:getDoor():setLockBroken(args.locked)
      end
      --vehicle:toggleLockedDoor(part, player, args.locked)
      vehicle:transmitPartDoor(part)
    else
      if UNSServer.DEBUG then print('no such vehicle id='..tostring(args.vehicle)) end
    end
  end
end
Events.OnClientCommand.Add(UNSServer.onClientCommand)

function UNSServer.unlockDoorOpen(lockableObject, player)
  if instanceof(lockableObject, "IsoDoor") then
    lockableObject:setLockedByKey(false)

    local doubleDoorObjects = buildUtil.getDoubleDoorObjects(lockableObject)

    for i = 1, #doubleDoorObjects do
      local object = doubleDoorObjects[i]
      object:setLockedByKey(false)
    end

    local garageDoorObjects = buildUtil.getGarageDoorObjects(lockableObject)

    for i = 1, #garageDoorObjects do
      local object = garageDoorObjects[i]
      object:setLockedByKey(false)
      player:getXp():AddXP(Perks.Nimble, 2.5)
    end

    ISTimedActionQueue.add(ISOpenCloseDoor:new(player, lockableObject, 0))
    --scrapingWood
    UNSSoundUtils.playSoundClip(player, "SlidingGlassDoorOpen")
    player:getXp():AddXP(Perks.Nimble, 2.5)
  end
end

function UNSServer.breakLockDoor(worldObjects, lockableObject, player)
  if instanceof(lockableObject, "IsoDoor") then
    lockableObject:setLockedByKey(true)
    lockableObject:setKeyId(0x0BADDEAD)

    local doubleDoorObjects = buildUtil.getDoubleDoorObjects(lockableObject)

    for i = 1, #doubleDoorObjects do
      local object = doubleDoorObjects[i]
      object:setLockedByKey(true)
      object:setKeyId(0x0BADDEAD)
    end

    local garageDoorObjects = buildUtil.getGarageDoorObjects(lockableObject)

    for i = 1, #garageDoorObjects do
      local object = garageDoorObjects[i]
      object:setLockedByKey(true)
      object:setKeyId(0x0BADDEAD)
      player:getXp():AddXP(Perks.Nimble, 5)
    end

    ISTimedActionQueue.add(ISOpenCloseDoor:new(player, lockableObject, 0))
    UNSSoundUtils.playSoundClip(player, "BreakObject")
    player:getXp():AddXP(Perks.Nimble, 7)
  end
end