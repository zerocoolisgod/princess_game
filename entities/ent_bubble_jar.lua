-- bubble jar increases total bubble power
local Class     = require 'lib.middleclass'
local Entity    = require "class.entity_class"
local Sprite    = require 'class.sprite_class'


local b = Class('bubble_jar', Entity)

function b:initialize (x,y)
  Entity.initialize(self,x,y,8,14,'bubble jar')
  self.group = 'pickup'
  self.add = 10
  self.start_y = y
  self.solid = true
  self.spd = 30
  self.sprite = Sprite:new("bubble jar sprite",'pickup_sheet',16,16,0,0)
  self.sprite:add_animation('idle', {7,8,8,9,9,9,8,8,7,10,10,11,11,11,10,10}, 16)
  self.sprite:set_animation('idle')
  
  self:set_collision_filter('solid','slide')
  self:set_collision_filter('onewayplatform','slide')
end

function b:on_update_first (dt)
  -- local frequency = 6
  -- local pitch = 5
  -- self.start_y=self.start_y+self.spd*dt
  -- self.pos.y = self.start_y + math.cos(G.gametime*frequency)*pitch
  self.pos.y = self.pos.y + self.spd*dt
end

function b:on_collision()
  
  self.spd = 0
end

function b:pickup ()
  return self.add
end
return b
