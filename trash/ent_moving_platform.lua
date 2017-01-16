local Class = require "lib.middleclass"
local Entity = require "class.entity_class"
local Sprite = require "class.sprite_class"

local lgd = love.graphics.draw

local owp = Class('moving platform', Entity)

function owp:initialize (x,y)
  Entity.initialize(self,x,y,32,8,'moving platform')
  self.sprite = Sprite:new('moving platform sprite','moving_plat',32,8,0,1)
  self.group = 'passable'
  self.solid = true
  self:set_collision_filter('player','cross')
end

function owp:on_update_first (dt)
  local pw,ph = G.player:get_size()
  local px,py = G.player:get_true_pos()
  local sx,sy = self:get_true_pos()
  local g = "passable"

  if py <= (sy - ph) then
    g = "solid"
  end

  
  self.group = g
end


function owp:on_collision(cols, len)

end

function owp:trash_on_draw_last ()
  local sx,sy = self:get_true_pos()
  love.graphics.rectangle("fill", sx, 0, 1, 1)
end
return owp
