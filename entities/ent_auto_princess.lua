local Class     = require 'lib.middleclass'
local Entity    = require "class.entity_class"
local Sprite    = require 'class.sprite_class'


--[[
Localized Framework Calls
--]]
local m_abs = math.abs

-- Automatic scrolling Princess for cinimatics


--[[Begin Class]]--
local Player = Class('Player',Entity)

function Player:initialize (x,y)
  -- init super class
  Entity.initialize(self,x,y,6,14,'player')
  self.camera_focus = false

  self.speed.x = 90
  self.accel.x = .09
  self.accel.y = .02

  self.jump_force = 310
  self.gravity = 600

  self.solid = true

  self.on_ground = false

  local sprt = "beth_blue_strip"
  self.sprite = Sprite:new('player sprite',sprt,16,16,0,1)
  self.sprite:add_animation('stand',{1,1,1,1,1,1,1,1,1,1,1,1,6,1},4)
  self.sprite:add_animation('walk',{3,1,2,1},6)
  self.sprite:add_animation('step',{1},1)
  self.sprite:add_animation('jump',{4},1)
  self.sprite:add_animation('fall',{5},1)
  self.sprite:add_animation('hit',{7,8},15)
  self.sprite:add_animation('death',{7,8},15)

  self.sprite:set_animation('walk')

  self.states = false

end



function Player:on_update_first (dt)
  
end

function Player:on_update_last(dt)
  
end


-------------------------
-- Collision Functions --
-------------------------
function Player:on_collision(cols, len)
  
end

function Player:collision_select (other)
  if other.group == 'enemy' then
    self:collide_enemy(other)
  elseif other.group == 'hazard' then
    self:collide_hazard(other)
  elseif other.group == 'bullet' then
    self:collide_bullet(other)
  elseif other.group == 'pickup' then
    self:collide_pickup(other)
  end
end

--------
-- ENEMY
function Player:collide_enemy (other)
  local ox, oy = other:get_pos()
  local sx, sy = self:get_pos()
  if sy < (oy-10) and self.can_stomp then -- more than 10 pixles above
    self:head_bonce(other)
  else
    self:take_damage(other)
  end
  --self:take_damage(other)
end

----------
-- BULLETS
function Player:collide_bullet (other)
  if other.parent ~= self then
    self:collide_enemy(other)
    other:take_damage(self)
  end
end

----------
-- HAZARDS
function Player:collide_hazard (other)
  if self.timers.hit <= 0 then
    self:take_damage (other)
  end
end

----------
-- PICKUPS
function Player:collide_pickup (other)
  if other.heal then G.player_heal(other.heal) end
  if other.id == 'coin' then G.coin_collected() end
  if other.id == 'bubble jar' then G.add_sub_power(other:pickup()) end
  if other.id == 'sub fire' then G.set_subweapon("fire") end

  other.remove = true
  G.resource_manager:play_sound('ge_pickup')
end



function Player:head_bonce (other)
  other:take_damage(self)

  if jump:down() then
    self:set_state('jump')
  else
    self.on_ground = false
    self.velocity.y = -(self.jump_force / 2)
    G.resource_manager:play_sound('jump')
    self:set_state('fall')
  end
end


function Player:take_damage (other)
  local health = G.get_player_health()
  if self.timers.hit <= 0 then
    -- set direction reletive to other
    local dir = 1
    local sx,sy = self:get_pos()
    local ox,oy = other:get_pos()

    if sx > ox then dir = -1 end
    self.direction.x = dir

    G.resource_manager:play_sound('hit')
    health = health - other.damage

    if health <= 0 then
      self:set_state('death')
    else
      self:set_state('hit')
    end
    G.player_hurt(other.damage)
  end
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
  local jump_force = self.jump_force
  if s == 'stand' or s == 'walk' then
    self.velocity.y = 60
  elseif s == 'jump' then
    self.timers.can_jump=0
    self.on_ground = false
    self.velocity.y = -jump_force
    G.resource_manager:play_sound('jump')
  elseif s == 'hit' then
    local d = -self.direction.x
    self.timers.hit = 1.5
    self.timers.flicker = 1.5
    self.velocity.x = 200 * d
    self.velocity.y = 0
    self.pos.y = self.pos.y -1
  elseif s == 'death' then
    self.timers.death = 1.5
    self.timers.hit = 1
    self.timers.flicker = 1
  end
  self:set_animation(s)
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
function Player:stand (dt)
  local jump_force = self.jump_force
  local gravity = 60
  local tgs_x = 0
  local tgs_y = gravity

  if right:down() or left:down() then
    self:set_state('walk')
  end

  if not self.on_ground then
    self:set_state('fall')
  end

  if jump:pressed() then
    if down:down() then
      self:set_state('fall')
    else
      self:set_state('jump')
    end
  end
  self:move(tgs_x, tgs_y, dt)
end

--------------------------------------------------------------------------
-- WALK --
--------------------------------------------------------------------------
function Player:walk(dt)
  local x_speed = self.speed.x or 150
  local jump_force = self.jump_force
  local gravity = 60
  local tgs_x = 0
  local tgs_y = gravity

  if left:down() then
    self.direction.x = -1
    tgs_x = -x_speed
  elseif right:down() then
    self.direction.x = 1
    tgs_x = x_speed
  elseif m_abs(self.velocity.x) < 3 then
    self:set_state('stand')
  end

  if not self.on_ground then
    self:set_state('fall')
  end

  if jump:pressed() then
    if down:down() then
      self:set_state('fall')
    else
      self:set_state('jump')
    end
  end

  if self:check_face() then
    tgs_x = 0
  end

  self:move(tgs_x, tgs_y, dt)
end


--------------------------------------------------------------------------
-- JUMP --
--------------------------------------------------------------------------
function Player:jump(dt)
  local x_speed = self.speed.x
  local jump_force = self.jump_force or 250
  local gravity = self.gravity or 300
  local tgs_x = 0
  local tgs_y = gravity

  if left:down() then
    self.direction.x = -1
    tgs_x = -x_speed
  elseif right:down() then
    self.direction.x = 1
    tgs_x = x_speed
  end

  if jump:released() then
    self.velocity.y = self.velocity.y * .50
    self:set_state('fall')
  end
  if self.velocity.y >= 0 then
    self:set_state('fall')
  end

  -- check for head bonk
  local l,t,w,h
  l = self.pos.x
  t = self.pos.y - 1
  w = self.size.x
  h = self.size.y
  local head_bonk = G.world_check_area(l,t,w,h, 'solid')
  if head_bonk then
    self.velocity.y = 2
    self:set_state('fall')
  end

  if self:check_face() then
    tgs_x = 0
  end
  self:move(tgs_x, tgs_y, dt)
end


--------------------------------------------------------------------------
-- FALL --
--------------------------------------------------------------------------
function Player:fall(dt)
  local x_speed = self.speed.x
  local gravity = self.gravity or 300
  local tgs_x = 0
  local tgs_y = gravity
  local c_anm = self.sprite:get_current_animation()

  -- use THIS sprite:set_animation overide
  if c_anm ~= 'fall' then self:set_animation('fall') end

  if left:down() then
    self.direction.x = -1
    tgs_x = -x_speed
  elseif right:down() then
    self.direction.x = 1
    tgs_x = x_speed
  end

  if self:check_face() then
    tgs_x = 0
  end

  self:move(tgs_x, tgs_y, dt)

  if self.on_ground then
    self:set_state('walk')
  end


  
  if self.can_jump and jump:pressed() then self:set_state('jump') end
end


--------------------------------------------------------------------------
-- SHOOT --
--------------------------------------------------------------------------



--------------------------------------------------------------------------
-- HIT --
--------------------------------------------------------------------------
function Player:hit (dt)
  local d = -self.direction.x
  if self.timers.hit < 1.3 then self:set_state('fall') end
  self:move(20 *d,300,dt)
end


--------------------------------------------------------------------------
-- DEATH --
--------------------------------------------------------------------------
function Player:death (dt)
  G.set_player_health(0)
  if self.timers.death <=0 then
    self.remove = true
    G.change_state('player_died_state')
  end
end


return Player
