-- Workaround for "Computer's local hostname has already been taken"
-- when Ethernet and WiFi are connected to the same network

local toggler = hs.configdir .. '/wifi_toggle.sh'

hs.usb.watcher.new(function(device)
  if device.productName == 'Apple Thunderbolt Display' then
    if string.match(device.eventType, 'added') then
      hs.task.new(toggler, nil, {'off'}):start()
    elseif string.match(device.eventType, 'removed') then
      hs.task.new(toggler, nil, {'on'}):start()
    end
  end
end):start()
