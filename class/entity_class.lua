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


local ENT = Class('Entity')


function ENT:initialize (x,y,w,h,id)
  self.pos = {x = x or 0, y = y or 0}
  self.size = {x = w or 0, y = h or 0}
  self.id = id or 'no_id'
  self.group = 'no_group'
  self.velocity = {x=0,y=0}
  self.direction = {x=0,y=0}
  self.speed = {x=0,y=0}
  self.accel = {x=1,y=1}
  self.camera_focus = false
  self.direction = {x=1,y=1}
  self.states = false
  self.next_state = ''
  self.current_state = ''
  self.previous_state = ''
  self.collision_types = {}
  self.timers = {}
  self.timers.flicker = 0
  self.remove = false
  self.debug = false
  self._move_acum = 0 --acumulator for move function
  self.health = 1
end

---
-- If you need something other than the default
-- simply override load, update and draw in the object



function ENT:update (dt)
  if self.on_update_first then self:on_update_first(dt) end
  
  if self.has_states then self:update_states(dt) end
  if self.sprite then self.sprite:update(dt) end
  if self.timers then self:update_timers(dt) end
  self:flicker_check(dt)

  if self.on_update_last then self:on_update_last(dt) end
end


function ENT:update_states(dt)
  if self.current_state ~= self.next_state then
    if not self[self.next_state] then
      local msg  = 'Object '..self.id..' has no state '..self.next_state
      G.error(msg)
    end
    self.current_state = self.next_state
    self:init_state(self.current_state)
  end

  self[self.current_state] (self, dt)
end


function ENT:flicker_check (dt)
  if self.timers.flicker > 0 then
    if self.alpha == 255 then
      self.alpha = 32
    else
      self.alpha = 255
    end
  else
    self.alpha = 255
  end
end


function ENT:update_timers(dt)
  -- Count down timers if they exist
  for timer,v in pairs(self.timers) do
    if v > 0 then
      self.timers[timer] = v - dt
    else
      self.timers[timer] = 0
    end
  end
end


function ENT:draw ()
  if self.on_draw_first then self:on_draw_first() end
  if self.sprite then self:draw_sprite() end
  if self.on_draw_last then self:on_draw_last() end

  if G.debug then self:draw_bounding_box() end
end

function ENT:draw_sprite()
  local sx,sy,x,y, alph
  alph = self.alpha or 255
  sx = math.sign(self.direction.x)
  sy = 1
  x,y = self:get_pos()
  self.sprite:draw(sx,sy,x,y,alph)
end

function ENT:draw_bounding_box()
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

function ENT:off_screen_update (dt)
  -- called while object is off screen
end

function ENT:get_pos ()
  -- returns center of object and or hitbox
  return self.pos.x + (self.size.x / 2), self.pos.y + (self.size.y / 2)
end


function ENT:get_true_pos ()
  -- returns top left of object and or hitbox
  return self.pos.x, self.pos.y
end

function ENT:get_size ()
  return self.size.x, self.size.y
end

function ENT:set_pos(x,y)
  -- sets position relative to center of object
  self.pos.x = x - (self.size.x / 2)
  self.pos.y = y - (self.size.y / 2)
end


function ENT:set_true_pos(x,y)
  -- set position of top left of object and or hitbox
  self.pos.x = x
  self.pos.y = y
end

--------------------------------------------------------------------------
-- State Functions --
--------------------------------------------------------------------------
function ENT:get_state ()
  return self.current_state
end

function ENT:set_state (s)
  if not self.has_states then self.has_states = true end
  self.next_state = s
end

function ENT:init_state (s)
  -- Overide in the entity for one time state initialization
  -- on the first update of a state switch.
end

function ENT:set_direction (x,y)
  self.direction.x = x or self.direction.x
  self.direction.y = y or self.direction.y
end


function ENT:set_collision_filter (group,type)
  -- keyed table for the type of collision
  -- to return based on others group value
  self.collision_types[group] = type
end


function ENT:is_on_screen (buffer)
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


--------------------
-- State Methods
--------------------


function ENT:add_animation (id,obj)
  if not self.sprite then
    local msg = self.id ..' has no Sprite!'
    G.error(msg)
  else
    self.sprite:add_animation(id,frames,fps)
  end

end


function ENT.col_filter(self, other)
  --[[ Example
  if  other.ID == 'enemy'  then return 'cross'
  elseif other.isWall   then return 'slide'
  elseif other.isExit   then return 'touch'
  elseif other.isSpring then return 'bounce'
  end
  --]]
  local og=other.group
  if self.collision_types.all then
    return self.collision_types.all
  else
    return self.collision_types[og]
  end
end

---
-- Takes target_speed, a rate of acceleration and delta time
-- a linear interpolation between the current velocity and the target
-- velocity by an acceleration percentage accel of 1 changes immediately,
-- 0 is never, .5 half's the difference each tick.
function ENT:move(tgs_x, tgs_y, dt)
  self._move_acum = self._move_acum + dt

  if self._move_acum >= tfps then
    self._move_acum = self._move_acum-tfps
    local cur_speed_x = self.velocity.x
    local cur_speed_y = self.velocity.y
    local threshold = 2   -- Lower to make more 'floaty'
    local accel_x = self.accel.x
    local accel_y = self.accel.y

    cur_speed_x = accel_x * tgs_x + (1 - accel_x) * cur_speed_x
    cur_speed_y = accel_y * tgs_y + (1 - accel_y) * cur_speed_y
    if (math.abs(cur_speed_x)) < threshold then
      cur_speed_x = 0
    end

    if (math.abs(cur_speed_y)) < threshold then
      cur_speed_y = 0
    end

    self.velocity.x = cur_speed_x
    self.velocity.y = cur_speed_y
  end

  self.pos.y = self.pos.y + self.velocity.y *dt
  self.pos.x = self.pos.x + self.velocity.x *dt
end

function ENT:check_ground(group)
  local g = group or 'solid'
  -- Check for Ground
  local l,t,w,h,rtn
  l = self.pos.x
  
  t = self.pos.y + self.size.y
  w = self.size.x
  
  h = 1

  return G.world_check_area(l,t,w,h,g)
end

function ENT:check_face(group)
  local g = group or 'solid'
  -- Check for walkng into wall
  local l,t,w,h
  l = self.pos.x + self.direction.x
  t = self.pos.y
  w = self.size.x
  h = self.size.y
  return G.world_check_area(l,t,w,h,g)
end
return ENT
