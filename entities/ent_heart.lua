-- Heart basic health recovery
local Class     = require 'lib.middleclass'
local Entity    = require "class.entity_class"
local Sprite    = require 'class.sprite_class'


local p = Class('heart', Entity)

function p:initialize (x,y)
  Entity.initialize(self,x,y,16,16,'heart')
  self.group = 'pickup'
  self.heal = 25
  self.solid = true
  self.sprite = Sprite:new("heart sprite",'pickup_sheet',16,16,0,0)
  self.sprite:add_animation('idle',{1},1)
  self.sprite:set_animation('idle')
  --self:add_state('idle', State:new())
  --self.next_state = 'idle'
end
return p
