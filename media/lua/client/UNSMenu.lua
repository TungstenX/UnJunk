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
-- This handles the OnFillWorldObjectContextMenu event as well as the radial menu (outside the vehicle)

UNSMenu = UNSMenu or {}
UNSMenu.DEBUG = getDebug() or false

function UNSMenu.calcTime(player)
  return 190 / (player:getPerkLevel(Perks.Nimble) + 1)
end

function UNSMenu.Loop(worldobjects, player, lockedObject, actionType, toolID, toolContainer)
  if not player:hasEquipped(toolID) then
    UNSUtils.delayFunction(function()
        if not player:hasEquipped(toolID) then
          UNSMenu.Loop(worldobjects, player, lockedObject, actionType, toolID, toolContainer)
        else
          if(actionType == UnJunk.BYPASS_DOOR) then
            luautils.walkAdjWindowOrDoor(player, lockedObject:getSquare(), lockedObject)
            ISTimedActionQueue.add(UNSTimedAction.bypassDoor(lockedObject, player, toolContainer, UNSMenu.calcTime(player)))
          elseif(actionType == UnJunk.BYPASS_VEHICLE_DOOR) then
            ISTimedActionQueue.add(UNSTimedAction.bypassVehicleDoor(worldobjects, lockedObject, player, toolContainer, UNSMenu.calcTime(player)))
          end
        end
      end, 10, true)
  end
end

function UNSMenu.bypassVehicleOpenLock(vehicle, vehiclePart, player, bypassKey)
  if not bypassKey then return end
  local toolID = bypassKey:getFullType()
  local toolContainer = nil
  ISInventoryPaneContextMenu.transferIfNeeded(player, bypassKey)

  if not player:hasEquipped(toolID) then
    ISInventoryPaneContextMenu.equipWeapon(bypassKey, true, true,  player:getPlayerNum())
    toolContainer = bypassKey:getContainer()
  end

  if not player:hasEquipped(toolID) then
    UNSMenu.Loop(vehicle,  player, vehiclePart, UnJunk.BYPASS_VEHICLE_DOOR, toolID, toolContainer)
  else
    ISTimedActionQueue.add(UNSTimedAction.bypassVehicleDoor(vehicle, vehiclePart,  player, toolContainer, UNSMenu.calcTime(player)))
  end
end

function UNSMenu.isNotBroken(item)
	return not item:isBroken()
end

local function getBypassKey(playerInv)
  local bypassKey = nil

	for _, v in pairs(UnJunk.BYPASS_TOOLS) do
    bypassKey = playerInv:getFirstTypeEvalRecurse(v, UNSMenu.isNotBroken)
    if bypassKey then
      return bypassKey
    end
 	end
  return bypassKey
end

--- Call this function when Player is opening the Radial Menu outside a Vehicle.
function UNSMenu.showRadialMenuOutside(player)
  if not SandboxVars.UnJunk.Bypass then return end

	local vehicle =  player:getNearVehicle() if not vehicle then return end
	local menu = getPlayerRadialMenu( player:getPlayerNum())
  local playerInv =  player:getInventory()
  local bypassKey = getBypassKey(playerInv)
  
  if not bypassKey then return end

  local doorPart = vehicle:getUseablePart(player)

  if doorPart and doorPart:getDoor() and doorPart:getInventoryItem() then
    if not doorPart:getDoor():isLocked() or doorPart:getDoor():isLockBroken() then return end
    local isHood = doorPart:getId() == "EngineDoor"

    if not (isHood) then
      menu:addSlice(getText("ContextMenu_Use_Skelenton"), getTexture("media/ui/vehicles/BypassKey.png"), UNSMenu.bypassVehicleOpenLock, vehicle, doorPart,  player, bypassKey)
    end
  end
end

function UNSMenu.bypassLock(worldobjects, lockedObject, player, bypassKey, doorType, vehicleDoor)
  print("bypassLock: worldobjects   ", worldobjects)
  print("bypassLock: lockedObject   ", lockedObject)
  print("bypassLock: player         ", player)
  print("bypassLock: bypassKey      ", bypassKey)
  print("bypassLock: doorType       ", doorType)
  print("bypassLock: vehicleDoor    ", vehicleDoor)
  
  
  if not bypassKey then return end
  local toolID = bypassKey:getFullType()
  local toolContainer = nil

  ISInventoryPaneContextMenu.transferIfNeeded(player, bypassKey)

  if not player:hasEquipped(toolID) then
    ISInventoryPaneContextMenu.equipWeapon(bypassKey, true, true, player:getPlayerNum())
    toolContainer = bypassKey:getContainer()
    print("bypassLock: not player:hasEquipped(toolID)")
  end

  if not player:hasEquipped(toolID) then
    print("bypassLock: not player:hasEquipped(toolID)")
    --UNSMenu.Loop(worldobjects, player, lockedObject, doorType, toolID, toolContainer)
  else
    luautils.walkAdjWindowOrDoor(player, lockedObject:getSquare(), lockedObject)
    print("UNSMenu.bypassLock calcTime", tostring(UNSMenu.calcTime(player)))
    if vehicleDoor then       
       ISTimedActionQueue.add(UNSTimedAction.bypassVehicleDoor(worldobjects, lockedObject, player, toolContainer, UNSMenu.calcTime(player)))
    else
      ISTimedActionQueue.add(UNSTimedAction:bypassDoor(worldobjects, lockedObject, player, toolContainer, UNSMenu.calcTime(player)))
    end    
  end
end

function UNSMenu.bypassDoor(worldobjects, lockedObject, player, bypassKey)
  UNSMenu.bypassLock(worldobjects, lockedObject, player, bypassKey, UnJunk.BYPASS_DOOR, false)
end

function UNSMenu.bypassVehicleOpen(vehicle, vehiclePart, player, bypassKey)
  UNSMenu.bypassLock(vehicle, vehiclePart, player, bypassKey, UnJunk.BYPASS_VEHICLE_DOOR, true)
end

UNSMenu.OnFillWorldObjectContextMenuBypass = function(playerSup, context, worldobjects, test)
  if not SandboxVars.UnJunk.Bypass then return end

  local player = getSpecificPlayer(playerSup)
  if player:getVehicle() then return end

  local playerInv =  player:getInventory()
  local bypassKey = getBypassKey(playerInv)

  if not bypassKey then return end

  local lockedObject = nil

  for _, v in ipairs(worldobjects) do
    if ISWorldObjectContextMenu.isThumpDoor(v) == true then
      lockedObject = v
    end
  end

  -- door interaction
	if lockedObject ~= nil then
    -- Prevent bypassing reinforced doors.
    if not SandboxVars.UnJunk.BypassAllDoors then
      local sprite = lockedObject:getSprite()
      if sprite then
        if player:getPerkLevel(Perks.Nimble) < 8 then
          -- Code snippet thanks to "UnCheat"!
          local spriteName = sprite:getName()
          if spriteName and
            spriteName == "fixtures_doors_01_32" or
            spriteName == "fixtures_doors_01_33" or
            spriteName == "location_community_police_01_4" or
            spriteName == "location_community_police_01_5" then
            return
          end
          -- End of snippet 
        end
      end
    end

    -- Is it a door, is it not barricaded, is lock and not by the BADDEAD key (broken IsoDoor lock)
		if instanceof(lockedObject, "IsoDoor") and lockedObject:isBarricaded() == false and lockedObject:isLocked() == true and lockedObject:getKeyId() ~= 0x0BADDEAD then
      context:addOptionOnTop(getText("ContextMenu_Use_Skelenton"), worldobjects, UNSMenu.bypassDoor, lockedObject,  player, bypassKey)
		end
	end
end

Events.OnFillWorldObjectContextMenu.Add(UNSMenu.OnFillWorldObjectContextMenuBypass)

-- 
local OnShowRadialMenuOutside = ISVehicleMenu.showRadialMenuOutside

ISVehicleMenu.showRadialMenuOutside = function(playerObj)
	if playerObj:getVehicle() then return end
	OnShowRadialMenuOutside(playerObj)
  UNSMenu.showRadialMenuOutside(playerObj)
end