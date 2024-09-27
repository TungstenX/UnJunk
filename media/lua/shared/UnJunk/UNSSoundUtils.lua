--[[
┌────────────────────────────────────────────────────────────────────────────────────────────────────┐
│ _/_/_/_/_/  _/    _/  _/      _/    _/_/_/    _/_/_/  _/_/_/_/_/  _/_/_/_/  _/      _/  _/      _/ │    
│    _/      _/    _/  _/_/    _/  _/        _/            _/      _/        _/_/    _/    _/  _/    │   
│   _/      _/    _/  _/  _/  _/  _/  _/_/    _/_/        _/      _/_/_/    _/  _/  _/      _/       │   
│  _/      _/    _/  _/    _/_/  _/    _/        _/      _/      _/        _/    _/_/    _/  _/      │   
│ _/        _/_/    _/      _/    _/_/_/  _/_/_/        _/      _/_/_/_/  _/      _/  _/      _/     │ ├────────────────────────────────────────────────────────────────────────────────────────────────────┤
│ © Copyright 2024                                                                                   │ 
├────────────────────────────────────────────────────────────────────────────────────────────────────┤
│ Credits:                                                                                           │
│   Braven's CommonSense mod                                                                         │
│   Workshop ID: 2875848298                                                                          │
│   Mod ID: BB_CommonSense                                                                           │
└────────────────────────────────────────────────────────────────────────────────────────────────────┘

┌─────────────────┐
│ UNS Sound Utils │
└─────────────────┘
]]
UNSSoundUtils = UNSSoundUtils or {}
UNSSoundUtils.LOG = UNSSoundUtils.LOG or {}
UNSSoundUtils.LOG.debug = getDebug() or false

-- Play either one of two  fail sounds for skelenton ket
function UNSSoundUtils.playFailSoundClip(obj)
  local soundName = "SkelentonKeyFail1"
  if ZombRand(2) == 1 then
    soundname = "SkelentonKeyFail2"
  end        
  UNSSoundUtils.playSoundClip(obj, soundName)
end

function UNSSoundUtils.playSoundClip(obj, soundName)
	if obj and obj:getEmitter() and obj:getEmitter():isPlaying(soundName) then return end
  if not obj or not obj:getEmitter() then return end
  local sound = obj:getEmitter():playSoundImpl(soundName, nil)
  if sound == 0 and UNSSoundUtils.LOG.debug then
    print("Sound " .. soundName .. " could not be played")
  end
  return sound  
end

function UNSSoundUtils.stopSoundClip(obj, soundName)
	if not obj:getEmitter():isPlaying(soundName) then return end
	local sound = obj:getEmitter():stopSoundByName(soundName)
  if sound == 0 and UNSSoundUtils.LOG.debug then
    print("Sound " .. soundName .. " could not be stopped")
  end
  return sound
end
