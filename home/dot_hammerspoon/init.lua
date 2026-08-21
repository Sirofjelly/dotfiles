function launchOrFocus(app)
  return function()
    hs.application.launchOrFocus(app)
  end
end

function runCommand(command)
  return function()
    hs.task.new(command, nil):start()
  end
end

local bindings = {
  [{'alt', 'cmd', 'ctrl', 'shift'}] = {
    c = launchOrFocus('Brave Browser'),
    f = launchOrFocus('Finder'),
    i = launchOrFocus('Visual Studio Code'),
    o = launchOrFocus('KeePassXC'),
    t = launchOrFocus('Ghostty'),
    w = launchOrFocus('WhatsApp'),
    y = launchOrFocus('System Preferences'),
  },
}

for modifier, keyActions in pairs(bindings) do
  for key, action in pairs(keyActions) do
    hs.hotkey.bind(modifier, tostring(key), action)
  end
end

-- Restore a minimized window when its application is activated.
local appWatcher = hs.application.watcher.new(function(_, event, app)
  if event == hs.application.watcher.activated then
    local windows = app:allWindows()

    local hasVisibleWindow = false
    for _, win in ipairs(windows) do
      if not win:isMinimized() then
        hasVisibleWindow = true
        break
      end
    end

    if not hasVisibleWindow then
      for _, win in ipairs(windows) do
        if win:isMinimized() then
          win:unminimize()
          win:focus()
          break
        end
      end
    end
  end
end)

appWatcher:start()

--
-- Auto-reload config on change.
--

function reloadConfig(files)
  for _, file in pairs(files) do
    if file:sub(-4) == '.lua' then
      hs.reload()
    end
  end
end

hs.pathwatcher.new(os.getenv('HOME') .. '/.hammerspoon/', reloadConfig):start()
