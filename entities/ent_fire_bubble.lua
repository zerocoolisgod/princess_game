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
local bbl = Class('Fire',Entity)

function bbl:initialize (x,y,ttl)
  Entity.initialize (self,x,y,8,8,'fire_bubble')
  self:set_pos(x,y)
  self.group = 'bubble'
  self.parent = nil
  self.accel.x = .07
  self.accel.y = .07

  self.damage = 2
  self.solid = true

  self.sprite = Sprite:new('Fire Bubble sprite','fire_bubble_sheet',16,16,0,4)
  self.sprite:add_animation('empty',{1,2,3},10)
  self.sprite:add_animation('pop',{4,5},10)
  self.sprite:set_animation('empty')

  self:set_state("empty")

  self:set_collision_filter('solid', 'cross')
  --self:set_collision_filter('passable','cross')
  self:set_collision_filter('bullet', 'cross')
end


function bbl:owner_init (parent,dx,dy)
  self:set_direction(dx,dy)
  self.velocity.x = 250 * dx
  self.velocity.y = -300
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
    --self.damage = 0
    --G.remove_hitbox(self)
    self.timers.pop = .5
    self:remove_bubble ()
    self.sprite:set_animation("pop")
  end
end


--------------------------------------------------------------------------
-- EMPTY --
--------------------------------------------------------------------------
function bbl:empty (dt)
  local mov_x = 100 * self.direction.x
  self:move(mov_x, 200, dt)
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
