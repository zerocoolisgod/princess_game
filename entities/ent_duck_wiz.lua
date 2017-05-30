-- run duck, basic enemy

local Class     = require 'lib.middleclass'
local Duck      = require "class.duck_class"
local Sprite    = require 'class.sprite_class'

local e = Class('duck_wiz',Duck)

function e:initialize (x,y)
  -- init super class
  Duck.initialize(self,x,y,16,16,'duck_wiz')

  self.sprite = Sprite:new('duck shoot sprite','duck_shoot_sheet',16,16,0,0)
  self.sprite:add_animation('shoot',{1,2},3)
  self.sprite:add_animation('death',{4,5},15)
  self.sprite:set_animation('shoot')

  self:set_state("shoot")

  self.direction.x = -1
  self.timers.shoot = 2
  self.health = 1
  self.damage = 1
end

function e:on_update_first (dt)
  local x,y = G.get_player_position()
  local dx = -1
  if x > self.pos.x then dx = 1 end
  self.direction.x = dx
end

function e:off_screen_update (dt)
  
end

function e:killed_by_bubble (other)
  G.boss_health = G.boss_health -1
  self:set_state("death")
  -- self.damage = 0
  -- self.remove = true
end

function e:killed_by_fire (other)
  G.boss_health = G.boss_health -1
  self:set_state("death")
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
  
  if s == "wait" then
    self.timers.wait = 2
  end
end


--------------------------------------------------------------------------
-- SHOOT --
--------------------------------------------------------------------------


function e:shoot(dt)
  
  local grounded = self:check_ground('solid') or self:check_ground('hazard') or self:check_ground('onewayplatform')
  
  if not grounded then
    self:set_state('fall')
  end

  self:move(0, 60, dt)
  
  if self.timers.shoot <= 0 then
    local my_center_x, my_center_y = self:get_pos()
    local x,y
    x = my_center_x --+ (10 * self.direction.x)
    y = my_center_y - 16
    local b = G.resource_manager:get_new_object('spn_cloud',x,y)
    local dx,dy = G.direction_to_player(x,y)
    b:set_spawn("ent_bullet", dx, dy)
    G.add_object(b)
    self:set_state('wait')
  end
end


function e:wait (dt)
  if self.timers.wait <= 0 then 
    self.damage = 0
    self.remove = true
  end
end

function e:fall (dt)
  tgs_y = 200
  tgs_x = 0
  self:move(tgs_x, tgs_y, dt)
  if self:check_ground('solid') or self:check_ground('hazard') or self:check_ground('onewayplatform') then
    self:set_state('shoot')
  end
end

return e
