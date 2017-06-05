-- run duck, basic enemy

local Class     = require 'lib.middleclass'
local Duck      = require "class.duck_class"
local Sprite    = require 'class.sprite_class'

local e = Class('duck_wiz',Duck)

function e:initialize (x,y)
  -- init super class
  Duck.initialize(self,x,y,16,16,'duck_wiz')
  self.direction.x = -1
  self.timers.shoot = 2
  self.timers.idle = 2
  self.health = 1
  self.damage = 1


  self.sprite = Sprite:new('duck shoot sprite','duck_wiz',16,16,0,0)
  self.sprite:add_animation('idle',{1},999)
  self.sprite:add_animation('power',{2},999)
  self.sprite:add_animation('shoot',{3},999)
  self.sprite:add_animation('death',{1,4},24)
  self.sprite:set_animation('idle')

  self:set_state("idle")
end

function e:on_update_first (dt)
  self:move(0, 1, dt)
  local x,y = G.get_player_position()
  local dx = -1
  local grounded = self:check_ground('solid') or self:check_ground('hazard') or self:check_ground('onewayplatform')

  if x > self.pos.x then dx = 1 end
  self.direction.x = dx

  
  
  if not grounded then
    self:set_state('fall')
  end
end

function e:off_screen_update (dt)
  
end

function e:killed_by_bubble (other)
  G.boss_health = G.boss_health -1
  self:set_state("death")
  -- self.damage = 0
  -- self.remove = true
  other:take_damage(self,true)
end

function e:killed_by_fire (other)
  G.boss_health = G.boss_health -1
  self:set_state("death")
  other:take_damage(self,true)
end
--------------------------------------------------------------------------
-- STATES --
--------------------------------------------------------------------------
function e:init_state(s)
  if s == "death" then
    self.damage = 0
    G.remove_hitbox(self)
    self.sprite:set_animation('death')
    self.timers.death = 1
  end
  
  if s == "wait" then
    self.sprite:set_animation('shoot')
    self.timers.wait = 2
  end

  if s == "shoot" then
    self.sprite:set_animation('power')
    self.timers.shoot = .2
  end

  if s == "idle" then
    self.sprite:set_animation('idle')
    self.timers.idle = .8
  end
  
end


--------------------------------------------------------------------------
-- SHOOT --
--------------------------------------------------------------------------

function e:idle()
  if self.timers.idle <=0 then self:set_state('shoot') end
end

function e:shoot(dt)

  self:move(0, 60, dt)
  
  if self.timers.shoot <= 0 then
    local my_center_x, my_center_y = self:get_pos()
    local x,y
    x = my_center_x --+ (10 * self.direction.x)
    y = my_center_y - 16
    local b = G.resource_manager:get_new_object('spn_cloud',x,y)
    local dx,dy = G.direction_to_player(x,y)
    b:set_spawn("ent_bullet", dx, dy)
    G.add_object(b)
    self:set_state('wait')
  end
end


function e:wait (dt)
  if self.timers.wait <= 0 then
    self.damage = 0
    self.remove = true
  end
end

function e:fall (dt)
  tgs_y = 200
  tgs_x = 0
  self:move(tgs_x, tgs_y, dt)
  if self:check_ground('solid') or self:check_ground('hazard') or self:check_ground('onewayplatform') then
    self:set_state('idle')
  end
end

return e
