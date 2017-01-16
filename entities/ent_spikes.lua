-- Spike basic hazard
local Class     = require 'lib.middleclass'
local Entity    = require "class.entity_class"


local h = Class('spikes', Entity)

function h:initialize (x,y,w,h)
  Entity.initialize(self,x,y,w,h,'spikes')
  self.group = 'hazard'
  self.damage = 1000
  self.solid = true
end
return h
