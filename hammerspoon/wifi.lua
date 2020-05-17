-- WiFi triggers

local homeSSID = 'strato-5G'
local speakers = hs.audiodevice.findOutputByName('Built-in Output')

hs.wifi.watcher.new(function()
  local previousSSID = hs.settings.get('previousSSID')
  local newSSID = hs.wifi.currentNetwork()
  local previouslyMuted = hs.settings.get('previouslyMuted')

  if newSSID == homeSSID and previousSSID ~= homeSSID then
    -- We just joined our home WiFi network
    speakers:setMuted(previouslyMuted)
  elseif newSSID ~= homeSSID and previousSSID == homeSSID then
    -- We just departed our home WiFi network
    hs.settings.set('previouslyMuted', speakers:muted())
    speakers:setMuted(true)
  end

  hs.settings.set('previousSSID', newSSID)
end):start()
