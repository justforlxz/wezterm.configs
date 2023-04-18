local w = require 'wezterm';

-- Equivalent to POSIX basename(3)
-- Given "/foo/bar" returns "bar"
-- Given "c:\\foo\\bar" returns "bar"
local function basename(s)
  return string.gsub(s, '(.*[/\\])(.*)', '%2')
end

local function is_vim(pane)
  local process_name = basename(pane:get_foreground_process_name())
  return process_name == 'nvim' or process_name == 'vim'
end

local direction_keys = {
  Left = 'h',
  Down = 'j',
  Up = 'k',
  Right = 'l',
  -- reverse lookup
  h = 'Left',
  j = 'Down',
  k = 'Up',
  l = 'Right',
}

local function split_nav(resize_or_move, key)
  return {
    key = key,
    mods = resize_or_move == 'resize' and 'META' or 'CTRL',
    action = w.action_callback(function(win, pane)
      if is_vim(pane) then
        -- pass the keys through to vim/nvim
        win:perform_action({
          SendKey = { key = key, mods = resize_or_move == 'resize' and 'META' or 'CTRL' },
        }, pane)
      else
        if resize_or_move == 'resize' then
          win:perform_action({ AdjustPaneSize = { direction_keys[key], 3 } }, pane)
        else
          win:perform_action({ ActivatePaneDirection = direction_keys[key] }, pane)
        end
      end
    end),
  }
end

local keys = {
    -- move between split panes
    split_nav('move', 'h'),
    split_nav('move', 'j'),
    split_nav('move', 'k'),
    split_nav('move', 'l'),
    -- resize panes
    split_nav('resize', 'h'),
    split_nav('resize', 'j'),
    split_nav('resize', 'k'),
    split_nav('resize', 'l'),


      {
    key = "z", mods = "LEADER",
    action = "TogglePaneZoomState"
  },
  {
    key = "b", mods = "LEADER|CTRL",
    action = w.action {
      SendKey = {
        key = "b",
        mods = "CTRL",
      },
    },
  },
  {
    key = "-", mods = "LEADER",
    action = w.action{
      SplitVertical = {
        domain = "CurrentPaneDomain"
      }
    }
  },
  {
    key = "\\", mods = "LEADER",
    action = w.action{
      SplitHorizontal = {
        domain = "CurrentPaneDomain"
      }
    }
  },
  {
    key = "h", mods = "LEADER",
    action = w.action{
      ActivatePaneDirection="Left"
    }
  },
  {
    key = "l", mods = "LEADER",
    action = w.action{
      ActivatePaneDirection = "Right"
    }
  },
  {
    key = "k", mods = "LEADER",
    action = w.action{
      ActivatePaneDirection = "Up"
    }
  },
  {
    key = "j", mods = "LEADER",
    action = w.action{
      ActivatePaneDirection = "Down"
    }
  },
  {
    key = "c", mods = "LEADER",
    action = w.action{
      SpawnTab = "CurrentPaneDomain"
    }
  },
  {
    key = ";", mods = "LEADER",
    action = w.action{
      SpawnCommandInNewTab = {
        args = {"nvim", "{{ .chezmoi.homeDir }}/.config/w.w.lua"}
      },
    }
  },
  {
    key = "Tab", mods = "LEADER",
    action = w.action{
      ActivateTabRelative=1,
    }
  },
  {
    key = "Tab", mods = "LEADER|SHIFT",
    action = w.action{
      ActivateTabRelative=-1,
    }
  },
  {
    key="w", mods="CTRL|SHIFT",
    action=w.action{
      CloseCurrentPane={confirm=true}
    }
  },
  {
    key="v", mods="SHIFT|CTRL",
    action=w.action.PasteFrom 'Clipboard'
  },
  {
    key="c", mods="SHIFT|CTRL",
    action=w.action.CopyTo 'ClipboardAndPrimarySelection'
  },
  {
    key="Enter", mods="ALT",
    action="ToggleFullScreen"
  },
}

for i = 1, 9 do
  table.insert(
    keys, {
      key = tostring(i),
      mods = "LEADER",
      action = w.action{ ActivateTab = i-1 },
    }
  )
end

return {
  leader = {
    key="a", mods="CTRL",
    timeout_milliseconds=900
  },
  keys = keys,
}
