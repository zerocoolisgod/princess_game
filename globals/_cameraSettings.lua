-- Global Camera Settings
local Camera = require "class.camera_class"


-- local love calls
local lgsc=love.graphics.setColor
local lgr=love.graphics.rectangle
 

-- 16:9 res 256 x 144
-- NES res 256 x 240
local w = 'w960x540'
local f = 'w1920x1080'

if _BUILD_FOR_PI then 
  w = "s1024x768"
  f = "s1024x768"
end

C_SIZE = C_RES[w].base

if not G then G = {} end
G.camera = Camera:new()
G.camera:set_view_size(C_RES[w].base.x,C_RES[w].base.y)
G.camera:set_windowed_zoom(C_RES[w].zoom)
G.camera:set_fullscreen_zoom(C_RES[f].zoom)
G.camera:set_mode('window')


-------------------------------------------------------------------------------
-- Global Camera Functions
-------------------------------------------------------------------------------
function G.set_camera_focus (o)
  G.camera:set_focus(o)
end

function G.set_camera_reset ()
  G.camera:unset_focus()
end

function G.set_camera_limit (r,b)
  G.camera:set_limit(r,b)
end

function G.draw_camera_boundary()
  local cp = G.camera:get_pos()
  lgsc(255, 0, 0, 255)
  lgr("line", cp.x, cp.y, C_SIZE.x, C_SIZE.y)
  lgsc(255, 255, 255, 255)
end