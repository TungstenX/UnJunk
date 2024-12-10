--[[
┌────────────────────────────────────────────────────────────────────────────────────────────────────┐
│ _/_/_/_/_/  _/    _/  _/      _/    _/_/_/    _/_/_/  _/_/_/_/_/  _/_/_/_/  _/      _/  _/      _/ │    
│    _/      _/    _/  _/_/    _/  _/        _/            _/      _/        _/_/    _/    _/  _/    │   
│   _/      _/    _/  _/  _/  _/  _/  _/_/    _/_/        _/      _/_/_/    _/  _/  _/      _/       │   
│  _/      _/    _/  _/    _/_/  _/    _/        _/      _/      _/        _/    _/_/    _/  _/      │   
│ _/        _/_/    _/      _/    _/_/_/  _/_/_/        _/      _/_/_/_/  _/      _/  _/      _/     │   
├────────────────────────────────────────────────────────────────────────────────────────────────────┤
│ © Copyright 2024                                                                                   │ 
├────────────────────────────────────────────────────────────────────────────────────────────────────┤
│ Credits:                                                                                           │
│   El1oN's Building Menu mod                                                                        │
│   Workshop ID: 3067798182                                                                          │
│   Mod ID: BuildingMenu                                                                             │
└────────────────────────────────────────────────────────────────────────────────────────────────────┘
]]

UNSUtils = UNSUtils or {}
 
-- Rounds a number to a specified number of decimal places
-- If `numDecimalPlaces` is not provided or less than 1, the number is rounded to the nearest integer
-- @param num number The number to round
-- @param numDecimalPlaces number|nil The number of decimal places to round to. Optional; if nil or less than 1, rounds to the nearest integer
-- @return number num The rounded number
function UNSUtils.round(num, numDecimalPlaces)
  if numDecimalPlaces and numDecimalPlaces > 0 then
    local multiplier = 10 ^ numDecimalPlaces;
    return math.floor(num * multiplier + 0.5) / multiplier;
  end

  local roundedNum = math.floor(num + 0.5);
  return math.max(roundedNum, 1);
end

function UNSUtils.safeCallMethod(object, methodName, ...)
  if type(object[methodName]) == "function" then
    return object[methodName](object, ...)
  end
end

-- Predicate function to check if an item is not broken
-- @param item InventoryItem
-- @return boolean
function UNSUtils.predicateNotBroken(item)
    return not item:isBroken()
end

-- Predicate function to check if an item has a specific tag
-- @param item InventoryItem
-- @param tag string
-- @return boolean
function UNSUtils.predicateHasTag(item, tag)
    return not item:isBroken() and item:hasTag(tag)
end

function UNSUtils.hasUseDelta(name)
	if name == 'Base.Wire' or name == 'Base.BlowTorch' or name == 'Base.WeldingRods' or name == 'Base.SandBag' then
		return true
	end
	return false
end

function UNSUtils.printObject(object)
  
  print("\tObject")
  if not object then
    print("\t\tNo Object")
    return
  end
  object:debugPrintout()
  print("\t\tName:                       ", tostring(object:getName()))
  print("\t\tObject Index:               ", tostring(object:getObjectIndex()))
  print("\t\tObject Name:                ", tostring(object:getObjectName()))
  print("\t\tcanAddSheetRope:            ", tostring(object:canAddSheetRope()))
  print("\t\tgetDamage:                  ", tostring(object:getDamage()))
  print("\t\tgetDir:                     ", tostring(object:getDir()))
  print("\t\tgetIsSurfaceNormalOffset:   ", tostring(object:getIsSurfaceNormalOffset()))
  print("\t\tgetMovingObjectIndex:       ", tostring(object:getMovingObjectIndex()))
  print("\t\tgetOffsetX:                 ", tostring(object:getOffsetX()))
  print("\t\tgetOffsetY:                 ", tostring(object:getOffsetY()))
  print("\t\tgetOutlineHighlightCol:     ", tostring(object:getOutlineHighlightCol()))
  print("\t\tgetOverlaySprite:           ", tostring(object:getOverlaySprite()))

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
  
  print("\t\tScript Name:                ", tostring(object:getScriptName()))
  print("\t\tSpecial Object Index:       ", tostring(object:getSpecialObjectIndex()))
  local sprite = object:getSprite()
  if sprite then
    print("\t\tSprite Name:              ", tostring(object:getSprite():getName()))
  end  
  local childSprites = object:getChildSprites()
  if childSprites then
    print("\t\tChild Sprites:")
    for i = 0, childSprites:size() - 1, 1 do
      local childSprite = childSprites:get(i)
      print("\t\t\tSprite Name: ", tostring(childSprite:getName()))
    end
  end
  
  print("\t\tgetStaticMovingObjectIndex: ", tostring(object:getStaticMovingObjectIndex()))
  print("\t\tgetTextureName:             ", tostring(object:getTextureName()))
  print("\t\tgetThumpCondition:          ", tostring(object:getThumpCondition()))
  print("\t\tgetTile:                    ", tostring(object:getTile()))
  print("\t\tType:                       ", tostring(object:getType()))
  print("\t\tWorld Object Index:         ", tostring(object:getWorldObjectIndex()))
  print("\t\thasModData:                 ", tostring(object:hasModData()))
  print("\t\tis Exist In The World:      ", tostring(object:isExistInTheWorld()))
  print("\t\tisFloor:                    ", tostring(object:isFloor()))
  
end

function UNSUtils.dumpTable(o)
  if type(o) == 'table' then
    local s = '{ '
    --if next(o) ~= nil then
    for k,v in pairs(o) do
      if type(k) ~= 'number' then k = '"'..k..'"' end
      s = s .. '['..k..'] = ' .. dumpTable(v) .. ','
    end
    --end      
    return s .. '} '
  else
    return tostring(o)
  end
end

function UNSUtils.printTable(t, level)
  if level >= 3 then
    return
  end
  local msg = ""
  local indent = ""
  for i = 0, level do
    indent = indent .. "  "
  end
  msg = msg .. "\n" .. indent
  msg = msg .. "[TABLE BEGIN]"
  for k, v in pairs(t) do
    if type(v) == "table" then
      msg = msg .. "\n" .. indent
      msg = msg .. "[" .. tostring(k) .. "] (" .. type(v) .. ")"
      local nextLevel = level + 1
      UNSMenuLightBulb.printTable(v, nextLevel)
    else
      msg = msg .. "\n" .. indent
      msg = msg .. "[" .. tostring(k) .. "] (" .. type(v) .. ") " .. tostring(v)
    end
  end
  msg = msg .. "\n" .. indent
  msg = msg .. "[TABLE END]"
  print(msg)
end


function UNSUtils.startsWith(needle, haystack)
  if needle == nil or haystack == nil then
    return false
  end
 return string.sub(haystack, 1, string.len(needle)) == needle
end