local Class     = require 'lib.middleclass'
local Entity    = require "class.entity_class"
local Sprite    = require 'class.sprite_class'




local Coin = Class('Coin',Entity)

function Coin:initialize (x,y)
  Entity.initialize (self,x,y,8,8,'coin')
  self.group = 'pickup'
  self.solid = true
  self.sprite = Sprite:new('coin sprite','key_sheet',8,8,0,0)
  self.sprite:add_animation('idle',{1,2,3,4,5,6,7,6,5,4,3,2},12)
  self.sprite:set_animation('idle')

  local f = love.math.random(7)
  self.sprite:set_frame(f)
end

return Coin
