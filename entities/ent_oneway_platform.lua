local Class = require 'lib.middleclass'
local Entity = require "class.entity_class"

-- FIX THIS DUMB SHIT!!

local lgd = love.graphics.draw

local owp = Class('one_way_platform', Entity)

function owp:initialize (x,y,w,h,q)
  Entity.initialize(self,x,y,w,h,'one_way_platform')
  self.group = 'passable'
  self.solid = true
  self.is_passable = true
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

  if G.inputs.down:down() and G.inputs.jump:pressed() then
    g = "passable"
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
