local wezterm = require 'wezterm'

local config = wezterm.config_builder()

config.color_scheme = 'Ayu Dark (Gogh)'

-- Font is manually installed, sorry
config.font = wezterm.font 'BerkeleyMono Nerd Font'

-- OpenGL frontend is broken on NixOS right now, but WebGpu works great instead!
config.front_end = 'WebGpu'

config.use_fancy_tab_bar = false;
config.tab_bar_at_bottom = true; 

return config

