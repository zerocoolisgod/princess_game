local Class     = require 'lib.middleclass'
local Area      = require "class.area_trigger_class"


local A = Class('Area_Respawn', Area)

function A:initialize (x,y)
  Area.initialize (self,x,y,16,16,'Area_Respawn')
  self.group = 'area'
  self.solid = true
  self:set_collision_filter('player','cross')
end

function A:on_collision ()
  G.set_player_spawn(self:get_true_pos())
end

return A
