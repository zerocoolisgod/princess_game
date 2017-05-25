-- bubble jar increases total bubble power
local Class     = require 'lib.middleclass'
local Entity    = require "class.entity_class"
local Sprite    = require 'class.sprite_class'


local b = Class('bubble_jar', Entity)

function b:initialize (x,y)
  Entity.initialize(self,x,y,8,8,'bubble jar')
  self.group = 'pickup'
  self.add = 10
  self.start_y = y
  self.solid = true
  self.spd = 50
  self.sprite = Sprite:new("bubble jar sprite",'bubble_jar_sheet',8,8,0,0,1)
  self.sprite:add_animation('idle', {1,2,3,4}, 6)
  self.sprite:set_animation('idle')
  self:set_collision_filter('solid','slide')
end

function b:on_update_first (dt)
  local frequency = 6
  local pitch = 5
  self.start_y=self.start_y+self.spd*dt
  self.pos.y = self.start_y + math.cos(G.gametime*frequency)*pitch
end

function b:on_collision()
  self.start_y=self.pos.y-4
  self.spd = 0
end

function b:pickup ()
  return self.add
end
return b
