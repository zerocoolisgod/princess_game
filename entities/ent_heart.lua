-- Heart basic health recovery
local Class     = require 'lib.middleclass'
local Entity    = require "class.entity_class"
local Sprite    = require 'class.sprite_class'


local p = Class('heart', Entity)

function p:initialize (x,y)
  Entity.initialize(self,x,y,8,14,'heart')
  self.group = 'pickup'
  self.heal = 25
  self.solid = true
  self.sprite = Sprite:new("heart sprite",'pickup_sheet',16,16,0,0)
  self.sprite:add_animation('idle',{1,2,2,3,3,3,2,2,1,4,4,5,5,5,4,4},16)
  self.sprite:set_animation('idle')
end

return p
