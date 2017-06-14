-- WiFi triggers

local homeSSID = 'strato-5G'
local vpnName  = 'Primary'

local speakers = hs.audiodevice.findOutputByName('Built-in Output')

hs.wifi.watcher.new(function()
  local previousSSID = hs.settings.get('previousSSID')
  local newSSID = hs.wifi.currentNetwork()
  local previouslyMuted = hs.settings.get('previouslyMuted')
  local previouslyPublic = hs.settings.get('previouslyPublic')

  if newSSID == homeSSID and previousSSID ~= homeSSID then
    -- We just joined our home WiFi network
    speakers:setMuted(previouslyMuted)
  elseif newSSID ~= homeSSID and previousSSID == homeSSID then
    -- We just departed our home WiFi network
    hs.settings.set('previouslyMuted', speakers:muted())
    speakers:setMuted(true)
  end

  if newSSID and hs.wifi.interfaceDetails()['security'] == 'None' then
    hs.settings.set('previouslyPublic', true)
    -- Wait for network to be joined
    hs.timer.doAfter(5, function()
      hs.osascript.applescript('tell application "Viscosity" to connect "' .. vpnName .. '"')
    end):start()
  else
    hs.settings.set('previouslyPublic', false)
    if previouslyPublic then
      hs.osascript.applescript('tell application "Viscosity" to disconnect "' .. vpnName .. '"')
    end
  end

  hs.settings.set('previousSSID', newSSID)
end):start()
