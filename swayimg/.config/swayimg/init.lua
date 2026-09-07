swayimg.mode = "viewer"  
swayimg.decoration = 0

swayimg.text.font = "JetBrainsMono Nerd Font"
swayimg.text.size = 18
swayimg.text.color = 0xffb4befe
swayimg.text.background = 0x801e1e2e
swayimg.text.timeout = 0

swayimg.viewer.default_scale = "optimal"
swayimg.viewer.set_window_background(0xff1e1e2e)
swayimg.viewer.set_text("topleft", {
  "File: {name}",
  "File size: {sizehr}",
  "Format: {format}"
})
swayimg.viewer.set_text("topright", {
  "Image: {list.index} of {list.total}"
})
swayimg.viewer.set_text("bottomleft", {
  "{frame.width}x{frame.height}, {scale}"
})


swayimg.viewer.on_key("q", function() swayimg.exit() end)
swayimg.viewer.on_key("Home", function() swayimg.viewer.open("first") end)
swayimg.viewer.on_key("End", function() swayimg.viewer.open("last") end)
swayimg.viewer.on_key("Prior", function() swayimg.viewer.open("prev") end)
swayimg.viewer.on_key("Next", function() swayimg.viewer.open("next") end)
swayimg.viewer.on_key("f", function() swayimg.fullscreen = not swayimg.fullscreen end)
swayimg.viewer.on_key("0", function() swayimg.viewer.set_fix_scale("real") end)
swayimg.viewer.on_key("w", function() swayimg.viewer.set_fix_scale("width") end)
swayimg.viewer.on_key("i", function() swayimg.text.visible = not swayimg.text.visible end)
swayimg.viewer.on_key("Shift+i", function() swayimg.text.show() end)
swayimg.viewer.on_key("slash", function() swayimg.viewer.set_fix_scale("fit") end)
swayimg.viewer.on_key("period", function() swayimg.viewer.set_fix_scale("real") end)
swayimg.viewer.on_key("1", function() swayimg.viewer.set_abs_scale(1.0) end)
swayimg.viewer.on_key("2", function() swayimg.viewer.set_abs_scale(2.0) end)

swayimg.viewer.on_mouse("ScrollUp", function() swayimg.viewer.open("prev") end)
swayimg.viewer.on_mouse("ScrollDown", function() swayimg.viewer.open("next") end)

swayimg.viewer.on_key("Left", function()
  local wnd = swayimg.get_window_size()
  local pos = swayimg.viewer.get_position()
  swayimg.viewer.set_abs_position(math.floor(pos.x + wnd.width / 10), pos.y);
end)

swayimg.viewer.on_key("Right", function()
  local wnd = swayimg.get_window_size()
  local pos = swayimg.viewer.get_position()
  swayimg.viewer.set_abs_position(math.floor(pos.x - wnd.width / 10), pos.y);
end)

swayimg.viewer.on_key("Up", function()
  local wnd = swayimg.get_window_size()
  local pos = swayimg.viewer.get_position()
  swayimg.viewer.set_abs_position(pos.x, math.floor(pos.y + wnd.height / 10));
end)

swayimg.viewer.on_key("Down", function()
  local wnd = swayimg.get_window_size()
  local pos = swayimg.viewer.get_position()
  swayimg.viewer.set_abs_position(pos.x, math.floor(pos.y - wnd.height / 10));
end)

swayimg.on_window_resize(function()
  swayimg.viewer.set_fix_scale("optimal")
end)
