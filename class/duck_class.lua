-- run duck, basic enemy

local Class     = require 'lib.middleclass'
local Entity    = require "class.entity_class"


local e = Class('duck',Entity)

function e:initialize (x,y,w,h,id)
  --init super class
  Entity.initialize(self,x,y,w,h,id)
  self.group = 'enemy'
  self.solid = true

  self:set_collision_filter('solid','slide')
  --self:set_collision_filter('passable','slide')
  self:set_collision_filter('onewayplatform','onewayplatformSlide')
  self:set_collision_filter('bubble','cross')

  self.health = 1
  self.damage = 1
  self.timers.hit = 0
end

-- Overide super
-- function e:update (dt)
--   if self.on_update_first then self:on_update_first(dt) end

--   if self.has_states then self:update_states(dt) end
--   if self.sprite then self.sprite:update(dt) end
--   if self.timers then self:update_timers(dt) end
--   self:flicker_check(dt)

--   if self.on_update_last then self:on_update_last(dt) end
-- end


function e:off_screen_update (dt)
end

-------------------------
-- Collision Functions --
-------------------------

function e:on_collision (cols, len)
  for i = 1, len do
    local o = cols[i].other
    if o.group == 'bubble' then
      self:collide_bubble(o)
    elseif o.group == 'enemy' then
      self:collide_enemy(o)
    end
  end
end

------------
-- BULLETS
function e:collide_bubble (other)
  self:take_damage(other)
  local dead = (self.health <= 0)

  if dead then
    if other.id == 'bubble' then
      self:killed_by_bubble(other)
    elseif other.id == 'fire_bubble' or other.id == 'fired_enemy' then
      self:killed_by_fire(other)
    end
  else
    other:take_damage(self)
  end
end

function e:killed_by_bubble (other)
  local x,y = self:get_pos()
  local o = G.resource_manager:get_new_object('ent_bubbled_enemy',x,y)
  local respawn = "ent_"..self.id
  o:owner_init(self, self.direction.x, 1,respawn)
  G.add_object(o)
  self:set_state("bubbled")
  other:take_damage(self,true)
end

function e:killed_by_fire (other)
  local x,y = self:get_pos()
  local o = G.resource_manager:get_new_object('ent_fired_enemy',x,y)
  
  o:owner_init(self, self.direction.x, 1)
  G.add_object(o)
  self:set_state("bubbled")
  other:take_damage(self,true)
end

----------
-- ENEMY
function e:collide_enemy(other)
  local d,cx,cy,dx,dy
  d = self.direction.x * -1
  cx,cy = self:get_true_pos()
  dx = cx + 3 * d
  dy = cy
  self.direction.x = d
  self:set_true_pos(dx,dy)
end

function e:take_damage (o)
  G.resource_manager:play_sound('hit')

  if self.timers.hit <= 0 then
    self.timers.hit= .1
    self.timers.flicker = .3
    self.health = self.health - o.damage
  end
  if (self.health <= 0) then self:set_state('death') end
end

--------------------------------------------------------------------------
-- STATES --
--------------------------------------------------------------------------
--state initation functions
function e:init_state(s)
  if s == "death" then
    self:death_init()
  end
end


--------------------------------------------------------------------------
-- DEATH --
--------------------------------------------------------------------------
function e:death_init ()
  self.damage = 0
  G.remove_hitbox(self)
  self.timers.death = 1
  self.sprite:set_animation("death")
end

function e:death (dt)
  if self.timers.death <=0 then
    self.remove = true
  end
end

--[[BUBBLED]]--
function e:bubbled(dt)
  self.damage = 0
  self.remove = true
end


return e
