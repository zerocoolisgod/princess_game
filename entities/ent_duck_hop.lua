-- run duck, basic enemy

local Class     = require 'lib.middleclass'
local Duck    = require "class.duck_class"
local Sprite    = require 'class.sprite_class'


local e = Class('duck_hop',Duck)

function e:initialize (x,y)
  --init super class
  Duck.initialize(self,x,y,16,16,'duck_hop')
  self.sprite = Sprite:new('duck hop sprite','duck_hop_sheet',16,16,0,0)

  self.sprite:add_animation('idle',{1,2},3)
  self.sprite:add_animation('hop',{3,4,5,4},16)
  self.sprite:add_animation('death',{6,7},15)
  self.sprite:add_animation('bubbled',{7},1)
  self.sprite:set_animation('idle')

  self:set_state('idle')

  self.direction.x = -1
  self.health = 3
  self.gravity = 600
  self.accel.x = .09
  self.accel.y = .02
  self.on_ground = false
  self.wait_time = 1.2
  self.timers.idle = self.wait_time

  self.damage = 1
end

function e:on_update_first (dt)
  self.on_ground = self:check_ground('solid') or self:check_ground('hazard') or self:check_ground('onewayplatform')
end


--------------------------------------------------------------------------
-- STATES --
--------------------------------------------------------------------------
function e:init_state(s)
  if s == "death" then
    self:death_init()
  elseif s =="hop" then
    self.sprite:set_animation(s)
    self.accel.x = .02
    self.velocity.y = -250
    self.velocity.x= 100 * self.direction.x
  elseif s == "idle" then
    self.sprite:set_animation(s)
    self.timers.idle = self.wait_time
    self.accel.x = .08
  end
end

--[[HOP]]--
function e:hop (dt)

  if self.velocity.y >0 and self.on_ground then
    self:set_state('idle')
  end
  self:move(0,self.gravity,dt)
end


--[[IDEL]]--
function e:idle(dt)
  local p = G.player
  if self.timers.idle <=0 then self:set_state('hop') end

  self.direction.x=1
  if (p.pos.x-self.pos.x)<0 then
    self.direction.x=-1
  end
  self:move(0,self.gravity,dt)
end

return e
