-- run duck, basic enemy

local Class  = require 'lib.middleclass'
local Duck   = require "class.duck_class"
local Sprite = require 'class.sprite_class'


local e = Class('duck_pit',Duck)

function e:initialize (x,y)
  --init super class
  Duck.initialize(self,x,y,16,16,'duck_pit')
  self.sprite = Sprite:new('duck hop sprite','duck_hop_sheet',16,16,0,0)

  --self.sprite:add_animation('idle',{1,2},3)
  self.sprite:add_animation('hop',{3,4,5,4},16)
  self.sprite:add_animation('death',{6,7},15)
  self.sprite:add_animation('bubbled',{7},1)
  self.sprite:set_animation('hop')

  self:set_state('hop')

  self.direction.x = -1
  self.health = 1
  self.gravity = 600
  self.accel.y = .009
  
  self.damage = 1
end

function e:on_update_first (dt)
  
end

function e:off_screen_update (dt)
  self.remove = true
end

--------------------------------------------------------------------------
-- STATES --
--------------------------------------------------------------------------
function e:init_state(s)
  if s == "death" then
    self:death_init()
  elseif s =="hop" then
    self.sprite:set_animation(s)
    self.velocity.y = -255
    self.velocity.x= 0
  end
end

--[[HOP]]--
function e:hop (dt)
  self:move(0,self.gravity,dt)
end

return e
