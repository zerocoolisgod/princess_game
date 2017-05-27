local Class     = require 'lib.middleclass'
local Entity    = require "class.entity_class"
local Sprite    = require 'class.sprite_class'

--[[
localized framework calls
]]

local m_abs = math.abs


--------------------------------------------------------------------------
-- CLASS DEF --
--------------------------------------------------------------------------
local be = Class('bubbled enemy',Entity)

function be:initialize (x,y)
  Entity.initialize (self,x,y,8,8,'bubbled enemy')
  self:set_pos(x,y)
  self.group = 'bubble'
  self.parent = nil
  self.respawn = ""
  self.accel.x = .07

  self.damage = 0
  self.solid = true

  self.sprite = Sprite:new('bubbled enemy sprite','bubbled_enemy_sheet',16,16,0,0)
  self.sprite:add_animation('full',{1,2,3,4},6)
  self.sprite:add_animation('pop',{5,6},16)
  self.sprite:set_animation('full')

  self:set_state("full")

  self:set_collision_filter('solid', 'cross')
  self:set_collision_filter('player', 'cross')
  --self:set_collision_filter('bullet', 'cross')
end


function be:owner_init (parent, dx, dy, respawn)
  self:set_direction(dx,dy)
  self.velocity.x = 50 * dx
  self.parent = parent or self
  self.respawn = respawn or ""
end


function be:off_screen_update (dt)
  self.remove=true
  G.spawn_enemy_pickup(self:get_true_pos())
end





function be:on_collision(cols, len)
--[[
  only get collision responses form walls and other bullet like objects
]]
  if self.current_state ~= 'pop' then
    for i = 1, len do
      local o = cols[i].other
      if o.group == "bullet" then
        self:collide_bullet(o)
      else
        self:set_state("pop")
      end
    end
  end
end

function be:collide_bullet (other)
  if other.id ~= 'bubble' then
    other:take_damage(self)
    self:set_state("pop")
  end
end

function be:take_damage (other)
  self:set_state("pop")
end

--------------------------------------------------------------------------
-- STATES --
--------------------------------------------------------------------------
function be:init_state (s)
  if s == "pop" then
    self.damage = 0
    G.remove_hitbox(self)
    self.timers.pop = .75
    G.spawn_enemy_pickup(self:get_true_pos())
  elseif s == "full" then
    self.timers.pop = 2
  end
  self.sprite:set_animation(s)
end


--------------------------------------------------------------------------
-- FULL --
--------------------------------------------------------------------------
function be:full (dt)
  if self.timers.pop <= 0 then
    self:set_state("pop")
  end
  self:move(0,-25,dt)
end


--------------------------------------------------------------------------
-- POP --
--------------------------------------------------------------------------
function be:pop (dt)
  if self.timers.pop <= 0 then
    self.remove = true
  end
end

return be
