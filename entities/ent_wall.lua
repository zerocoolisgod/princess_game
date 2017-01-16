local Class = require 'lib.middleclass'
local Entity = require "class.entity_class"


local Wall = Class('Wall', Entity)

function Wall:initialize (x,y,w,h,q)
  Entity.initialize(self,x,y,w,h,'wall')
  self.group = 'solid'
  self.solid = true
  self.quad = q or nil
end

function Wall:set_quad (q)
  -- May use for animated tiles
  self.quad = q
end

return Wall
