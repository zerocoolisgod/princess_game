-- run duck, basic enemy

local Class     = require 'lib.middleclass'
local Duck    = require "class.duck_class"
local Sprite    = require 'class.sprite_class'


local e = Class('duck_fly', Duck)
function e:initialize (x,y)
  --init super class
  Duck.initialize(self,x,y,16,16,'duck_fly')
  self.sprite = Sprite:new('duck fly sprite','duck_fly_sheet',16,16,0,0)
  self.sprite:add_animation('fly',{1,2,3,2},10)
  self.sprite:add_animation('death',{4,5},15)
  self.sprite:set_animation('fly')

  self:set_state("fly")

  self.direction.x = -1
  self.accel.x = 1
  self.accel.y = .02
  self.speed.x = 75

  self.health = 1
  self.damage = 1
end

--------------------------------------------------------------------------
-- STATES --
--------------------------------------------------------------------------


--------------------------------------------------------------------------
-- FLY --
--------------------------------------------------------------------------
function e:fly(dt)
  local tgs_x = self.speed.x * self.direction.x
  local tgs_y = 0
  --self.pos.y = self.start_y + math.cos(self.pos.x/16)*15

  if self:check_face() or self:check_face("onewayplatform") or self:check_face("stopper") then
	  self.direction.x = self.direction.x * -1
  end

  self:move(tgs_x, tgs_y, dt)
end

return e
