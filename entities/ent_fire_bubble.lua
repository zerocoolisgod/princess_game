local Class     = require 'lib.middleclass'
local Entity    = require "class.entity_class"
local Sprite    = require 'class.sprite_class'

--[[
localized framework calls

shorten flame up animation and remove damage to enemies while flaming up
]]

local m_abs = math.abs


--------------------------------------------------------------------------
-- CLASS DEF --
--------------------------------------------------------------------------
local bbl = Class('Fire',Entity)

function bbl:initialize (x,y,ttl)
  Entity.initialize (self,x,y,8,8,'fire_bubble')
  self:set_pos(x,y)
  self.group = 'bubble'
  self.parent = nil
  self.accel.x = .04
  self.accel.y = .07
  self.speed.x = 200
  self.speed.y = -200
  self.grav = 200

  self.damage = 1
  self.solid = true

  self.sprite = Sprite:new('Fire Bubble sprite','fire_bubble_sheet',16,16,0,4)
  self.sprite:add_animation('empty',{1,2,3},10)
  self.sprite:add_animation('pop',{4,5,6},15)
  self.sprite:set_animation('empty')

  self:set_state("empty")

  self:set_collision_filter('solid', 'cross')
  self:set_collision_filter('bullet', 'cross')
  self:set_collision_filter('decoration', 'cross')
  --self:set_collision_filter('onewayplatform','onewayplatformSlide')
end


function bbl:owner_init (parent,dx,dy)
  self:set_direction(dx,dy)
  self.velocity.x = self.speed.x * dx
  self.velocity.y = self.speed.y
  self.parent = parent or self
end


function bbl:off_screen_update (dt)
  self.remove=true
  self:remove_bubble()
end


function bbl:remove_bubble()
  G.remove_bubble()
end


function bbl:on_collision(cols, len)
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

function bbl:collide_bullet (other)
  if other.id ~= self.id then
    other:take_damage(self)
    self:set_state("pop")
  end
end

function bbl:take_damage (other, now)
  if now then
    self:pop_now()
  else
    self:set_state("pop")
  end
end

--------------------------------------------------------------------------
-- STATES --
--------------------------------------------------------------------------
function bbl:init_state (s)
  if s == "pop" then
    self.damage = 0
    self.timers.pop = .2
    self:remove_bubble ()
    self.sprite:set_animation("pop")
  end
end


--------------------------------------------------------------------------
-- EMPTY --
--------------------------------------------------------------------------
function bbl:empty (dt)
  --local mov_x = 0 * self.direction.x
  self:move(0, self.grav, dt)
end


--------------------------------------------------------------------------
-- POP NOW --
--------------------------------------------------------------------------
function bbl:pop_now (dt)
    self.remove = true
end


--------------------------------------------------------------------------
-- POP --
--------------------------------------------------------------------------
function bbl:pop (dt)
  if self.timers.pop <= 0 then
    self.remove = true
  end
end

return bbl
