local Class = require 'lib.middleclass'
local Entity = require "class.entity_class"

local lgd = love.graphics.draw

local stopper = Class('stopper', Entity)


--[[
  Only functions as backstop for moving objects to bounce off of.
]]


function stopper:initialize (x,y)
  Entity.initialize(self,x,y,32,8,'stopper')
  self.group = 'stopper'
  self.solid = true
  -- self:set_collision_filter('all',nil)
end

function stopper:on_update_first (dt)
  
end


function stopper:on_collision(cols, len)

end

function stopper:trash_on_draw_last ()
  
end
return stopper
