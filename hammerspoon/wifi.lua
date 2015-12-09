-- WiFi triggers

local homeSSID = 'strato-n.wifis.org'

local previousSSID = hs.wifi.currentNetwork()
local previouslyMuted = false

local function ssidChangedCallback()
  local newSSID = hs.wifi.currentNetwork()

  if newSSID == homeSSID and previousSSID ~= homeSSID then
    -- We just joined our home WiFi network
    hs.audiodevice.defaultOutputDevice():setMuted(previouslyMuted)
  elseif newSSID ~= homeSSID and previousSSID == homeSSID then
    -- We just departed our home WiFi network
    previouslyMuted = hs.audiodevice.defaultOutputDevice():muted()
    hs.audiodevice.defaultOutputDevice():setMuted(true)
  end

  previousSSID = newSSID
end

hs.wifi.watcher.new(ssidChangedCallback):start()
