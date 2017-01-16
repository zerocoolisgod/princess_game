local Class     = require 'lib.middleclass'
local Entity    = require "class.entity_class"
local Sprite    = require 'class.sprite_class'


--[[
Localized Framework Calls
--]]
local m_abs = math.abs


-- Inputs
local left, right, down, select, jump, act_1

--[[Begin Class]]--
local Player = Class('Player Top Down',Entity)

function Player:initialize (x,y)
  left  = G.inputs.left
  right = G.inputs.right
  up  = G.inputs.up
  down  = G.inputs.down
  select = G.inputs.select
  jump  = G.inputs.jump
  act_1 = G.inputs.act_1

  -- init super class
  Entity.initialize(self,x,y,6,14,'player top down')

  self.group = 'player'
  self.debug = false

  self.camera_focus = true

  local spd = 100
  local acl = .2
  self.speed.x = spd
  self.accel.x = acl
  self.speed.y = spd
  self.accel.y = acl
  
  self.solid = true

  self.animation_direction = 2 -- up=1, down=2, horz=3

  self.sprite = Sprite:new('player top down sprite','beth_top_down_strip',16,16,0,0)
  self.sprite:add_animation('idle_up',{8},1)
  self.sprite:add_animation('idle_down',{4},1)
  self.sprite:add_animation('idle_horz',{1},1)
  self.sprite:add_animation('walk_up',{8,9,8,10},8)
  self.sprite:add_animation('walk_down',{4,5,4,6},8)
  self.sprite:add_animation('walk_horz',{1,2,1,3},8)
  self.sprite:set_animation('idle_down')

  self.states = true
  self:set_state('idle')

  self:set_collision_filter('solid','slide')
  self:set_collision_filter('event','cross')

  if G.spawn then self.pos = G.spawn end
end



function Player:on_update_first (dt)
  self:db_update(self.debug,dt)
end




-------------------------
-- Collision Functions --
-------------------------
function Player:on_collision(cols, len)
  if self.current_state ~= 'death' then
    for i=1,len do
      local o = cols[i].other
      self:collision_select(o)
    end
  end
end

function Player:collision_select (other)
  if other.group == 'event' then
    self:collide_event(other)
  end
end

--------
-- ENEMY
function Player:collide_event (other)
  
end

---
-- Debug Functions
---
function Player:db_update(db,dt)
  if db then
    G.debug_manager:watch('Player State : '..self.current_state)
    G.debug_manager:watch('Player vel.x: '..self.velocity.x)
    G.debug_manager:watch('player vel.y: '..self.velocity.y)
  end
end



--------------------------------------------------------------------------
-- STATES --
--------------------------------------------------------------------------
function Player:init_state (s)
  -- State prep work and setting animation
  local anm = {"idle_up","idle_down","idle_horz"}

  if s == 'idle' then
    anm = {"idle_up","idle_down","idle_horz"}
  elseif s == 'walk' then
    anm = {"walk_up","walk_down","walk_horz"}
  elseif s == 'death' then
    self.timers.death = 1.5
    self.timers.hit = 1
    self.timers.flicker = 1
  end
  self:set_animation(anm[self.animation_direction])
end

function Player:set_animation(a)
  -- Special override for sprite:set_animation
  -- fall animation only starts if we ar actually
  -- moving down.
  if a == 'fall' and self.velocity.y < 0 then
    a = 'jump'
  end

  self.sprite:set_animation(a)
end


--------------------------------------------------------------------------
-- STAND --
--------------------------------------------------------------------------
function Player:idle (dt)
  local tgs_x = 0
  local tgs_y = 0

  if up:down() then
    self:set_state('walk')
    self.animation_direction = 1
  elseif down:down() then
    self:set_state('walk')
    self.animation_direction = 2
  elseif right:down() or left:down() then
    self:set_state('walk')
    self.animation_direction = 3
  end

  self:move(tgs_x, tgs_y, dt)
end

--------------------------------------------------------------------------
-- WALK --
--------------------------------------------------------------------------
function Player:walk(dt)
  local x_speed = self.speed.x or 150
  local y_speed = self.speed.y or 150
  
  local tgs_x = 0
  local tgs_y = 0

  if left:down() then
    self.direction.x = -1
    tgs_x = -x_speed
  elseif right:down() then
    self.direction.x = 1
    tgs_x = x_speed
  end

  if up:down() then
    self.direction.y = -1
    tgs_y = -y_speed
  elseif down:down() then
    self.direction.y = 1
    tgs_y = y_speed
  end
  
  if up:released() or
     down:released() or
     left:released() or
     right:released() then
    self:set_state('idle')
  end

  self:move(tgs_x, tgs_y, dt)
end





--------------------------------------------------------------------------
-- DEATH --
--------------------------------------------------------------------------
function Player:death (dt)
  self.health = 0
  if self.timers.death <=0 then
    self.remove = true
    G.change_state('player_died_state')
  end
end


return Player
