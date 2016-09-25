require('wifi')
require('wm')
hs.timer.doEvery(hs.timer.days(1), function()
  hs.timer.doAfter(30, function()
    hs.reload() -- Reload config to workaround bug where hammerspoon watchers don't fire
  end)
end)
