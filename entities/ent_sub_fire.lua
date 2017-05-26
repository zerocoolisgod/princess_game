-- Heart basic health recovery
local Class     = require 'lib.middleclass'
local Entity    = require "class.entity_class"
local Sprite    = require 'class.sprite_class'


local p = Class('sub_fire', Entity)

function p:initialize (x,y)
  Entity.initialize(self,x,y,8,8,"sub fire")
  self.group = 'pickup'
  self.heal = 25
  self.solid = true
  self.spd = 30
  self.sprite = Sprite:new("heart sprite",'pickup_sheet',16,16,0,0)
  self.sprite:add_animation('idle',{16},1000)
  self.sprite:set_animation('idle')

  self:set_collision_filter('solid','slide')
  self:set_collision_filter('onewayplatform','slide')
end

function p:on_update_first (dt)
   self.pos.y=self.pos.y + self.spd*dt
end

function p:on_collision()
  self.spd = 0
end

return p
