-- run duck, basic enemy

local Class     = require 'lib.middleclass'
local Duck      = require "class.duck_class"
local Sprite    = require 'class.sprite_class'


local e = Class('duck_run', Duck)

function e:initialize (x,y)
  --init super class
  Duck.initialize(self,x,y,16,16,'duck_run')
  self.sprite = Sprite:new('duck run sprite','duck_run_sheet',16,16,0,0)

  self.sprite:add_animation('walk',{1,2,3,2},6)
  self.sprite:add_animation('death',{4,5},15)
  self.sprite:set_animation('walk')

  self:set_state('fall')

  self.direction.x = -1
  self.accel.x = 1
  self.accel.y = .01
  self.speed.x = 40

  self.health = 1
  self.damage = 1
end


-------------------------
-- Collision Functions --
-------------------------
function e:check_edge ()
  -- check front facing toe for the edge of a platform
  local cx,cy = self:get_pos()
  local x,y,w,h
  w = ((self.size.x/2)+1)*self.direction.x
  h = (self.size.y/2)+1
  x = cx+w
  y = cy+h
  return world_check_point(x,y,'solid') or world_check_point(x,y,'onewayplatform')
end


--------------------------------------------------------------------------
-- STATES --
--------------------------------------------------------------------------
function e:init_state(s)
  if s == "death" then
    self.damage = 0
    G.remove_hitbox(self)
    self.sprite:set_animation('death')
    self.timers.death = 1
  end
end


--------------------------------------------------------------------------
-- WALK --
--------------------------------------------------------------------------
function e:walk(dt)
  local tgs_x = self.speed.x * self.direction.x
  local tgs_y = self.gravity or 0
  local grounded = self:check_ground('solid') or self:check_ground('hazard') or self:check_ground('onewayplatform')
  local turn = self:check_face() or not self:check_edge()

  if not grounded then
    self:set_state('fall')
  elseif turn then
    self:set_state('turn')
  end

  self:move(tgs_x, tgs_y, dt)
end


--------------------------------------------------------------------------
-- TURN --
--------------------------------------------------------------------------
function e:turn(dt)
  self.direction.x = self.direction.x * -1
  self:set_state('walk')
end

--------------------------------------------------------------------------
-- FALL --
--------------------------------------------------------------------------
function e:fall (dt)
  tgs_y = 600
  tgs_x = 60 * self.direction.x
  self:move(tgs_x, tgs_y, dt)
  if self:check_ground('solid') or self:check_ground('hazard') or self:check_ground('onewayplatform') then
    self:set_state('walk')
  end
end


--------------------------------------------------------------------------
-- DEATH --
--------------------------------------------------------------------------
function e:death (dt)
  if self.timers.death <=0 then
    self.remove = true
  end
end


return e
