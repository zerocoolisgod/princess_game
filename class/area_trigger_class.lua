local Class = require 'lib.middleclass'

--[[
Localized Framework Calls
--]]
local lg = love.graphics
local lgd = love.graphics.draw
local lgr = love.graphics.rectangle
local lgp = love.graphics.print
local lgsc = love.graphics.setColor
local m_fl = math.floor
local m_abs = math.abs
local key_down = love.keyboard.isDown
local tfps=(1/60)


local AREA = Class('Area')


function AREA:initialize (x,y,w,h,id)
  self.pos = {x = x or 0, y = y or 0}
  self.size = {x = w or 1, y = h or 1}
  self.id = id or 'no_id_area'
  self.group = 'no_group'
  self.solid = true
  self.collision_types = {}
  self.timers = {}
  self.remove = false
  self.debug = false
end

---
-- If you need something other than the default
-- simply override load, update and draw in the object



function AREA:update (dt)
  if self.on_update_first then self:on_update_first(dt) end

  -- Count down timers if they exist
  for timer,v in pairs(self.timers) do
    if v > 0 then
      self.timers[timer] = v - dt
    else
      self.timers[timer] = 0
    end
  end

  if self.on_update_last then self:on_update_last(dt) end
end


function AREA:draw ()
  if self.on_draw then self:on_draw() end
end

function AREA:off_screen_update (dt)
  -- called while object is off screen
end

function AREA:get_pos()
  -- returns center of object and or hitbox
  return self.pos.x + (self.size.x / 2), self.pos.y + (self.size.y / 2)
end


function AREA:get_true_pos()
  -- returns top left of object and or hitbox
  return self.pos.x, self.pos.y
end

function AREA:set_pos(x,y)
  -- sets position relative to center of object
  self.pos.x = x - (self.size.x / 2)
  self.pos.y = y - (self.size.y / 2)
end


function AREA:set_true_pos()
  -- set position of top left of object and or hitbox
  return self.pos.x, self.pos.y
end

function AREA:set_collision_filter (group,type)
  -- keyed table for the type of collision
  -- to return based on others group value
  self.collision_types[group] = type
end


function AREA:is_on_screen (buffer)
  local cam_pos = G.camera:get_pos()
  local v_frame = {l,r,t,b}
  local s_buff = buffer or 16 -- just a little past the screen edge
  v_frame.l = cam_pos.x - s_buff
  v_frame.r = cam_pos.x + (C_SIZE.x + s_buff)
  v_frame.t = cam_pos.y - s_buff
  v_frame.b = cam_pos.y + (C_SIZE.y + s_buff)

  if (self.pos.x > v_frame.l and
      self.pos.x < v_frame.r and
      self.pos.y > v_frame.t and
      self.pos.y < v_frame.b) then

    return true
  else
    return false
  end
end

function AREA.col_filter(self, other)
  --[[ Example
  if  other.ID == 'enemy'  then return 'cross'
  elseif other.isWall   then return 'slide'
  elseif other.isExit   then return 'touch'
  elseif other.isSpring then return 'bounce'
  end
  --]]

  if self.collision_types.all then
    return self.collision_types.all
  else
    return self.collision_types[other.group]
  end
end


function AREA:on_draw()
  if G.debug then self:draw_bounding_box() end
end


function AREA:draw_bounding_box()
  --draws a yellow box of self.size at self.position
  local x,y,w,h, vel
  x = self.pos.x
  y = self.pos.y
  w = self.size.x
  h = self.size.y

  lgsc(255, 64, 156, 128)
  lgr("fill", x, y, w, h)
  lgsc(255, 255, 0,255)
  lgr("line", x, y, w, h)
  lgsc(255, 255, 255,255)
end

return AREA
