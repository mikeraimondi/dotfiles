hs.usb.watcher.new(function(device)
  if device.productName == 'Apple Thunderbolt Display' then
    if string.match(device.eventType, 'added') then
      hs.task.new(hs.configdir .. '/wifi_off.sh', nil):start()
    elseif string.match(device.eventType, 'removed') then
      hs.task.new(hs.configdir .. '/wifi_on.sh', nil):start()
    end
  end
end):start()
