-- run duck, basic enemy

local Class     = require 'lib.middleclass'
local Duck      = require "class.duck_class"
local Sprite    = require 'class.sprite_class'


local e = Class('duck_homing', Duck)
function e:initialize (x,y)
  --init super class
  Duck.initialize(self,x,y,16,16,'duck_homing')
  self.sprite = Sprite:new('duck homing sprite','duck_homing_sheet',16,16,0,0)
  self.sprite:add_animation('fly',{1,2,3,2},16)
  self.sprite:add_animation('death',{4,5},15)
  self.sprite:set_animation('fly')

  self:set_collision_filter('solid',nil)
  self:set_collision_filter('onewayplatform',nil)

  

  self.direction.x = -1
  self.accel.x = .2
  self.accel.y = .2
  self.speed.x = 80
  self.speed.y = 80
  self.timers.wait = 0
  self.timers.fly = 0
  self.wait_time = 1
  self.fly_time = 0.6

  self.health = 1
  self.damage = 1

  self:set_state("wait")
end

--------------------------------------------------------------------------
-- STATES --
--------------------------------------------------------------------------
function e:init_state (s)
  if s=="fly" then
    self:set_direction(G.direction_to_player(self.pos.x, self.pos.y))
    self.accel.x = 0.08
    self.accel.y = 0.08
    self.timers.fly = self.fly_time
  end
  if s=="wait" then
    self.accel.x = 0.1
    self.accel.y = 0.1
    self.timers.wait = self.wait_time
  end
end

--------------------------------------------------------------------------
-- FLY --
--------------------------------------------------------------------------
function e:fly(dt)
  self:move(self.speed.x * self.direction.x, self.speed.y * self.direction.y,dt)
  if self.timers.fly <= 0 then self:set_state("wait") end
end


--------------------------------------------------------------------------
-- FLY --
--------------------------------------------------------------------------
function e:wait(dt)
  self:move(0, 0, dt)
  if self.timers.wait <= 0 then self:set_state("fly") end
end


return e
