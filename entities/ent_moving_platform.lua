-- run duck, basic enemy

local Class   = require "lib.middleclass"
local Entity  = require "class.entity_class"
local Sprite  = require "class.sprite_class"


local e = Class('moving_platform', Duck)
function e:initialize (x,y)
  --init super class
  Entity.initialize(self,x,y,16,16,'moving_platform')

  self.group = 'solid'

  self.sprite = Sprite:new('moving_platform','duck_fly_sheet',16,16,0,0)
  self.sprite:add_animation('fly',{1},9999)
  self.sprite:set_animation('fly')

  self:set_state("float")

  self.direction.x = -1
  self.accel.x = 1
  self.accel.y = .02
  self.speed.x = 75
end

--------------------------------------------------------------------------
-- STATES --
--------------------------------------------------------------------------


--------------------------------------------------------------------------
-- FLY --
--------------------------------------------------------------------------
function e:float(dt)
  local tgs_x = self.speed.x * self.direction.x
  local tgs_y = 0
  
  if self:check_face() or self:check_face("onewayplatform") or self:check_face("stopper") then
	  self.direction.x = self.direction.x * -1
  end

  self:move(tgs_x, tgs_y, dt)
end

return e
