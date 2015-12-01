local homeSSID = 'strato-n.wifis.org'

local lastSSID = hs.wifi.currentNetwork()
local homeVolume = hs.audiodevice.defaultOutputDevice():volume()

local function ssidChangedCallback()
  local newSSID = hs.wifi.currentNetwork()

  if newSSID == homeSSID and lastSSID ~= homeSSID then
    -- We just joined our home WiFi network
    hs.audiodevice.defaultOutputDevice():setVolume(homeVolume)
  elseif newSSID ~= homeSSID and lastSSID == homeSSID then
    -- We just departed our home WiFi network
    homeVolume = hs.audiodevice.defaultOutputDevice():volume()
    hs.audiodevice.defaultOutputDevice():setVolume(0)
  end

  lastSSID = newSSID
end

hs.wifi.watcher.new(ssidChangedCallback):start()
