local Class     = require 'lib.middleclass'
local Entity    = require "class.entity_class"
local Sprite    = require 'class.sprite_class'


local Bullet = Class('Bullet',Entity)


function Bullet:initialize (x,y,ttl)
  Entity.initialize (self,x,y,8,8,'bullet')
  self:set_pos(x,y)
  self.group = 'bullet'
  self.parent = nil
  self.speed.x = 250
  self.accel.x = 1
  self.dist_to_move = 99999

  self.damage = 1
  self.solid = true

  self.sprite = Sprite:new('bullet sprite','bullet_sheet',8,8,0,0)
  self.sprite:add_animation('shoot',{1,2,3},8)
  self.sprite:set_animation('shoot')

  self.next_state = 'shoot'
  self.current_state = self.next_state
  self:set_collision_filter('solid', 'cross')
end


function Bullet:on_update_last(dt)
  local mx = self.speed.x * self.direction.x
  local my = self.speed.x * self.direction.y
  self:move(mx,my,dt)
  -- local x,y = self:get_pos()
  -- local x2,y2 = self.parent:get_pos()
  -- local dist = (x-x2)*self.direction.x
  -- if dist > self.dist_to_move then self:remove_bullet() end
end


function Bullet:owner_init (parent, dx, dy, dist)
  self:set_direction(dx,dy)
  self.dist_to_move = dist or 99999
  self.parent = parent or self
end


function Bullet:off_screen_update ()
  self:remove_bullet()
end


function Bullet:remove_bullet()
  self.remove = true
end


function Bullet:on_collision(cols, len)
--[[
  enemy sets remove for bullet, otherwise bullet soemtimes removes
  it self before enemy registers the hit
]]
  for i = 1, len do
    if cols[i].other ~= self.parent and
      cols[i].other.id ~= 'bullet' then
        G.resource_manager:play_sound('hit')
        self:remove_bullet()
    end
  end
end

function Bullet:take_damage (o)
  self:remove_bullet()
end

return Bullet
