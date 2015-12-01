local moveCombo = {"ctrl", "alt"}
local bigPanel = 2 / 3

local smallPanel = 1 - bigPanel
local previousUnitRect = nil
local windowMovedAt = 0

local function moveFocusedWindow(unitRect)
  local window = hs.window.frontmostWindow()
  if window == nil then return end
  if unitRect == previousUnitRect and hs.timer.secondsSinceEpoch() - windowMovedAt <= 2 then
    window:move(unitRect, window:screen():next(), nil, 0)
  else
    window:move(unitRect, nil, nil, 0)
  end
  windowMovedAt = hs.timer.secondsSinceEpoch()
  previousUnitRect = unitRect
end

hs.hotkey.bind(moveCombo, "Q", function()
  moveFocusedWindow(hs.geometry(0, 0, 0.5, 0.5))
end)
hs.hotkey.bind(moveCombo, "W", function()
  moveFocusedWindow(hs.geometry(0, 0, 1, 0.5))
end)
hs.hotkey.bind(moveCombo, "E", function()
  moveFocusedWindow(hs.geometry(0.5, 0, 0.5, 0.5))
end)
hs.hotkey.bind(moveCombo, "R", function()
  moveFocusedWindow(hs.geometry(0, 0, bigPanel, 0.5))
end)
hs.hotkey.bind(moveCombo, "T", function()
  moveFocusedWindow(hs.geometry(bigPanel, 0, smallPanel, 0.5))
end)
hs.hotkey.bind(moveCombo, "A", function()
  moveFocusedWindow(hs.geometry(0, 0, 0.5, 1))
end)
hs.hotkey.bind(moveCombo, "S", function()
  moveFocusedWindow(hs.layout.maximized)
end)
hs.hotkey.bind(moveCombo, "D", function()
  moveFocusedWindow(hs.geometry(0.5, 0, 0.5, 1))
end)
hs.hotkey.bind(moveCombo, "F", function()
  moveFocusedWindow(hs.geometry(0, 0, bigPanel, 1))
end)
hs.hotkey.bind(moveCombo, "G", function()
  moveFocusedWindow(hs.geometry(bigPanel, 0, smallPanel, 1))
end)
hs.hotkey.bind(moveCombo, "Z", function()
  moveFocusedWindow(hs.geometry(0, 0.5, 0.5, 0.5))
end)
hs.hotkey.bind(moveCombo, "X", function()
  moveFocusedWindow(hs.geometry(0, 0.5, 1, 0.5))
end)
hs.hotkey.bind(moveCombo, "C", function()
  moveFocusedWindow(hs.geometry(0.5, 0.5, 0.5, 0.5))
end)
hs.hotkey.bind(moveCombo, "V", function()
  moveFocusedWindow(hs.geometry(0, 0.5, bigPanel, 0.5))
end)
hs.hotkey.bind(moveCombo, "B", function()
  moveFocusedWindow(hs.geometry(bigPanel, 0.5, smallPanel, 0.5))
end)
