local Class = require 'lib.middleclass'

--[[
Localized Framework Calls
--]]
local lg        = love.graphics
local pop       = lg.pop
local push      = lg.push
local translate = lg.translate
local rotate    = lg.rotate
local scale     = lg.scale
local m_floor   = math.floor




local Camera = Class('Camera')

function Camera:initialize ()
  local w, h = love.graphics.getDimensions()
  self.pos = {x=0,y=0}
  self.scale = {x=1,y=1}
  self.rot = 0
  self.focus = nil
  self.limit = {l=0,r=64000,t=0,b=64000}
  --needs setters
  self.flags = {vsync=false, fullscreen = false, fullscreentype = "exclusive"}
  self.view_size = {x=w, y=h}   -- Game Resolution
  self.window_size = {x=w,y=h}  -- Screen Resolution
  self.zoom_w = {x=1,y=1}       -- Windowed zoom factor
  self.zoom_f = {x=1,y=1}       -- Fullscreen zoom factor
  self.half_view = {x = w/2, y = h/2}

end

function Camera:update(dt)
  if self.focus then
    local cam_pos_x, cam_pos_y
    -- ADD size to position because cameras translate
    -- is the reverse of it position
    cam_pos_x = self.focus.pos.x + (self.focus.size.x / 2)
    cam_pos_y = self.focus.pos.y + (self.focus.size.y / 2)
    self:center_on(cam_pos_x,cam_pos_y,dt)
    self:clamp()
  end
end

function Camera:set ()
  self.scale = self.zoom_w
  if self.flags.fullscreen then self.scale = self.zoom_f end
  push()
  rotate(-self.rot)
  scale(self.scale.x, self.scale.y)
  translate(-self.pos.x, -self.pos.y)
end

function Camera:unset ()
  pop()
end

function Camera:set_gui ()
  self.scale = self.zoom_w
  if self.flags.fullscreen then self.scale = self.zoom_f end
  push()
  --rotate(-self.rot)
  scale(self.scale.x, self.scale.y)
  --translate(-self.pos.x, -self.pos.y)
end


function Camera:center_on (pos_x, pos_y,dt)
  -- sets position to be centered on pos
  -- size is the constant resolution that we are working from
  self.pos.x = pos_x - self.half_view.x
  self.pos.y = pos_y - self.half_view.y
end

function Camera:set_pos(x,y)
  -- sets position of top left corner
  self.pos.x = x
  self.pos.y = y
end

function Camera:get_pos()
  return self.pos
end

function Camera:reset_pos ()
  self.pos.x = 0
  self.pos.y = 0
end

function Camera:toggle_fullscreen ()
  local mode = 'full'
  if self.flags.fullscreen then mode = 'window' end


  self:set_mode(mode)
  --[[
  love.window.setMode(self.view_size.x * self.scale.x,
    self.view_size.y * self.scale.y, self.flags)
  self.window_size.x = love.graphics.getWidth()
  self.window_size.y = love.graphics.getHeight()
  --]]
end

function Camera:set_focus (obj)
    self.focus = obj
end

function Camera:unset_focus (obj)
    self.focus = nil
    self:reset_pos()
end

function Camera:set_limit (xr,yb)
    self.limit.r = xr - self.view_size.x
    self.limit.b = yb - self.view_size.y
end

function Camera:clamp ()
    -- make sure camera stays inside its limits
    local lim = self.limit
    local x, y = self.pos.x, self.pos.y
    if x < lim.l then x = lim.l end
    if x > lim.r then x = lim.r end
    if y < lim.t then y = lim.t end
    if y > lim.b then y = lim.b end
    self:set_pos(x,y)
end

-------------------------------------------------------------------------------
-- Setters
-------------------------------------------------------------------------------
function Camera:set_view_size (x,y)
  self.view_size.x = x
  self.view_size.y = y

  self.half_view.x = x/2
  self.half_view.y = y/2
end

function Camera:set_window_size (x,y)
  -- sets display resolution
  -- sets zoom based on window/game res

  -- self.window_size.x = x
  -- self.window_size.y = y
  self:set_windowed_zoom (x / self.view_size.x, y / self.view_size.y)
end

function Camera:set_mode (m)
  if m == 'window' then
    self.scale = self.zoom_w
    self.flags.fullscreen = false
  elseif m == 'full' then
    self.flags.fullscreen = true
    self.scale = self.zoom_f
  end

  love.window.setMode(self.view_size.x * self.scale.x,
    self.view_size.y * self.scale.y, self.flags)

  self.window_size.x = love.graphics.getWidth()
  self.window_size.y = love.graphics.getHeight()
end

function Camera:set_windowed_zoom (x,y)
  self.zoom_w.x = x
  self.zoom_w.y = y or x
end

function Camera:set_fullscreen_zoom (x,y)
  self.zoom_f.x = x
  self.zoom_f.y = y or x
end

return Camera
