--[[
┌────────────────────────────────────────────────────────────────────────────────────────────────────┐
│ _/_/_/_/_/  _/    _/  _/      _/    _/_/_/    _/_/_/  _/_/_/_/_/  _/_/_/_/  _/      _/  _/      _/ │    
│    _/      _/    _/  _/_/    _/  _/        _/            _/      _/        _/_/    _/    _/  _/    │   
│   _/      _/    _/  _/  _/  _/  _/  _/_/    _/_/        _/      _/_/_/    _/  _/  _/      _/       │   
│  _/      _/    _/  _/    _/_/  _/    _/        _/      _/      _/        _/    _/_/    _/  _/      │   
│ _/        _/_/    _/      _/    _/_/_/  _/_/_/        _/      _/_/_/_/  _/      _/  _/      _/     │ ├────────────────────────────────────────────────────────────────────────────────────────────────────┤
│ © Copyright 2024                                                                                   │ 
└────────────────────────────────────────────────────────────────────────────────────────────────────┘

┌─────────────────────┐
│ UNS Menu Light Bulb │
└─────────────────────┘

- This handles the OnPreFillInventoryObjectContextMenu event for more info on light bulbs
]]

require "UNSUtils"
UNSMenuLightBulb = UNSMenuLightBulb or {}
UNSMenuLightBulb.LOG = UNSMenuLightBulb.LOG or {}
UNSMenuLightBulb.LOG.debug = getDebug() or false
UNSMenuLightBulb.LOG.trace = false

function UNSMenuLightBulb.scanItems(items)
  if items == nil then
    return
  end
  local size = items:size()
  for k = 0, size - 1 do --k, v in ipairs(items) do
    local v = items:get(k)
    if not instanceof(v, "InventoryItem") then
      if #v.items == 2 then
        tempItem = v.items[1]
      end
      tempItem = v.items[1]
    else
      tempItem = v
    end

    if tempItem then
      if UNSMenuLightBulb.LOG.trace then
        local msg = "InventoryItem: "
        msg = msg .. "\nCategory     = " .. tostring(tempItem:getCategory())
        msg = msg .. "\nCondition    = " .. tostring(tempItem:getCondition())
        msg = msg .. "\nConditionMax = " .. tostring(tempItem:getConditionMax())
        msg = msg .. "\nCount        = " .. tostring(tempItem:getCount())
        msg = msg .. "\nDescription  = " .. tostring(tempItem:getDescription())
        msg = msg .. "\nDisplayName  = " .. tostring(tempItem:getDisplayName())
        msg = msg .. "\nFullType     = " .. tostring(tempItem:getFullType())
        msg = msg .. "\nMechanicType = " .. tostring(tempItem:getMechanicType())
        msg = msg .. "\nName         = " .. tostring(tempItem:getName())
        if tempItem:getTags() == nil then
          msg = msg .. "\nTags:"
          local size = tempItem:getTags():size()
          for i = 0, size - 1 do
            msg = msg .. "\n\t" .. tempItem:getTags():get(i)
          end
        else
          msg = msg .. "\nTags         = nil"
        end
        msg = msg .. "\nTooltip      = " .. tostring(tempItem:getTooltip())
        msg = msg .. "\nType         = " .. tostring(tempItem:getType())
        print(msg)
      end
      if UNSUtils.startsWith("LightBulb", tempItem:getType()) then
        local tt = getText("IGUI_invpanel_Condition") .. ": " .. tostring(tempItem:getCondition()) .. " / " .. tostring(tempItem:getConditionMax())
        if tempItem:getConditionMax() < 100 then
          tt = tt .. getText("IGUI_Light_Bulb_Not_Car") --" (Not for vehicle)"
        end
        tempItem:setTooltip(tt)
      end
    end
  end
end

function UNSMenuLightBulb.OnRefreshInventoryWindowContainers(iSInventoryPage, state)
  -- `begin`, `beforeFloor`, `buttonsAdded`, or `end`
  if state == "begin" then
    if iSInventoryPage == nil then
      if UNSMenuLightBulb.LOG.debug then print("iSInventoryPage is nil") end
      return
    end
    if iSInventoryPage.inventoryPane == nil then
      if UNSMenuLightBulb.LOG.debug then print("iSInventoryPage.inventoryPane is nil") end
      return
    end
    if iSInventoryPage.inventoryPane.inventory == nil then
      if UNSMenuLightBulb.LOG.debug then print("iSInventoryPage.inventoryPane.inventory is nil") end
      return
    end
    if iSInventoryPage.inventoryPane.inventory:getItems() == nil then
      if UNSMenuLightBulb.LOG.debug then print("iSInventoryPage.inventoryPane.inventory:getItems() is nil") end
      return
    end
    
    UNSMenuLightBulb.scanItems(iSInventoryPage.inventoryPane.inventory:getItems())  
  end
end
Events.OnRefreshInventoryWindowContainers.Add(UNSMenuLightBulb.OnRefreshInventoryWindowContainers)



--[[   ************************          


function printObject(object)  
  print("\tObject")
  if not object then
    print("\t\tNo Object")
    return
  end
  print("\t\tName:         ", object:getName())
  print("\t\tObject Index: ", object:getObjectIndex())
  print("\t\tObject Name:  ", object:getObjectName())
  local properties = object:getProperties()
  if properties then
    print("\t\tProperties")  
    if properties:getFlagsList() then
      print("\t\t\tFlags List")  
      for i = 0, properties:getFlagsList():size() - 1, 1 do
        local flag = properties:getFlagsList():get(i)
        print("\t\t\t\tFlag: ", flag:toString())  
      end
    end
    print("\t\t\tItem height:       ", properties:getItemHeight())
    if properties:getPropertyNames() then
      print("\t\t\tProperty names") 
      for i = 0, properties:getPropertyNames():size() - 1, 1 do
        print("\t\t\t\tName: " .. properties:getPropertyNames():get(i) .. " = " .. properties:Val(properties:getPropertyNames():get(i)))  
      end
    end
    print("\t\t\tis Surface Offset: ", properties:isSurfaceOffset())
    print("\t\t\tis Table:          ", properties:isTable())
    print("\t\t\tis Table Top:      ", properties:isTableTop())
  end
  
  print("\t\tScript Name:           ", object:getScriptName())
  print("\t\tSpecial Object Index:  ", object:getSpecialObjectIndex())
  local sprite = object:getSprite()
  if sprite then
    print("\t\tSprite Name:           ", object:getSprite():getName())
  end  
  print("\t\tType:                  ", object:getType())
  print("\t\tWorld Object Index:    ", object:getWorldObjectIndex())
  print("\t\tis Exist In The World: ", object:isExistInTheWorld())
  
end

function Test1MenuEntry()
  print("GM test 1 start")
  local player = getPlayer()
  local sq0 = player:getCurrentSquare()
  local sqXP1 = getSquare(sq0:getX() + 1, sq0:getY(), sq0:getZ())
  local sqXM1 = getSquare(sq0:getX() - 1, sq0:getY(), sq0:getZ())
  local sqYP1 = getSquare(sq0:getX(), sq0:getY() + 1, sq0:getZ())
  local sqYM1 = getSquare(sq0:getX(), sq0:getY() - 1, sq0:getZ())
  local sqs = {
    {"SQ 000", sq0},
    {"SQ X+1", sqXP1},
    {"SQ X-1", sqXM1},
    {"SQ Y+1", sqYP1},
    {"SQ Y-1", sqYM1},
  }
  print("Player (x, y, z): (" .. tostring(sq0:getX()) .. ", " .. tostring(sq0:getY()) .. ", " .. tostring(sq0:getZ()) .. ")")
  local cell = player:getCell()
  
  print("Player Cell: world (x, y) min (x, y, z) max (x, y, z): (" .. tostring(cell:getWorldX()) .. ", " .. tostring(cell:getWorldY()) .. ") (" .. tostring(cell:getMinX()) .. ", " .. tostring(cell:getMinY()) .. ", " .. tostring(cell:getMinZ()) .. ") (" .. tostring(cell:getMaxX()) .. ", " .. tostring(cell:getMaxY()) .. ", " .. tostring(cell:getMaxZ()) .. ")")
  
  for _,v in pairs(sqs) do
    local roomName = "NOT ROOM"
    local isoRoom = v[2]:getRoom()
    if isoRoom then 
      roomName = isoRoom:getName()
    end    
    print(v[1] .. " " .. roomName)  
    for i = 0, v[2]:getObjects():size() - 1, 1 do
      printObject(v[2]:getObjects():get(i))
    end
  end  
  print("GM test 1 end")
end



local function testContextMenu(playerIndex, context, worldObjects, test)
	context:addOption("Test 1 - Scan player squares", getSpecificPlayer(playerIndex), Test1MenuEntry)
end
Events.OnFillWorldObjectContextMenu.Add(testContextMenu)

]]
