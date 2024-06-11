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

UNSUtils = UNSUtils or {}
UNSUtils.DEBUG = getDebug() or false

function UNSUtils.delayFunction(func, delay, adaptToSpeed)
  delay = delay or 1
  local multiplier = 1
  local ticks = 0
  local canceled = false

  local function onTick()
    if adaptToSpeed then multiplier = UNSUtils.getGameSpeed() end
    if not canceled and ticks < delay then
      ticks = ticks + multiplier
      return
    end

    Events.OnTick.Remove(onTick)
    if not canceled then func() end
  end

  Events.OnTick.Add(onTick)
  return function()
    canceled = true
  end
end

function UNSUtils.getGameSpeed()
  local speedControl = UIManager.getSpeedControls():getCurrentGameSpeed()
  local gameSpeed = 1

  if speedControl == 2 then
    gameSpeed = 5
  elseif speedControl == 3 then
    gameSpeed = 20
  elseif speedControl == 4 then
    gameSpeed = 40
  end

  return gameSpeed
end