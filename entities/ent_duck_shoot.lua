-- run duck, basic enemy

local Class     = require 'lib.middleclass'
local Duck      = require "class.duck_class"
local Sprite    = require 'class.sprite_class'

local e = Class('duck_shoot',Duck)

function e:initialize (x,y)
  -- init super class
  Duck.initialize(self,x,y,16,16,'shoot_duck')

  self.sprite = Sprite:new('duck shoot sprite','duck_shoot_sheet',16,16,0,0)
  self.sprite:add_animation('shoot',{1,2},6)
  self.sprite:add_animation('death',{4,5},15)
  self.sprite:set_animation('shoot')

  self:set_state("shoot")

  self.direction.x = -1
  self.timers.shoot = 2
  self.health = 3
  self.damage = 1
end


--------------------------------------------------------------------------
-- STATES --
--------------------------------------------------------------------------
--------------------------------------------------------------------------
-- SHOOT --
--------------------------------------------------------------------------
function e:shoot(dt)
  if self.timers.shoot <= 0 then
    local my_center_x, my_center_y = self:get_pos()
    local x,y
    x = my_center_x + (10 * self.direction.x)
    y = my_center_y
    local b = G.resource_manager:get_new_object('ent_bullet',x,y)
    --b.group = 'enemy'
    b.speed.x=150
    b:owner_init(ent, self.direction.x, 1)
    G.add_object(b)
    self.timers.shoot = 2
  end
end

return e
