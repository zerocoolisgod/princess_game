local Class     = require 'lib.middleclass'
local Area      = require "class.area_trigger_class"


local A = Class('Stage_Change', Area)

function A:initialize (x,y)
  Area.initialize (self,x,y,16,16,'Stage_Change')
  self.group = 'area'
  self.solid = true
  self:set_collision_filter('player','cross')
end

function A:on_collision ()
  G.reset_player_spawn()
  G.load_next_stage()
end

return A
