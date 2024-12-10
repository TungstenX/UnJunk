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
      if UNSMenuLightBulb.LOG.debug then
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