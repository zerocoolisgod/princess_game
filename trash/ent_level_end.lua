-- Heart basic health recovery
local Class     = require 'lib.middleclass'
local Entity    = require "class.entity_class"
local Sprite    = require 'class.sprite_class'



local le = Class('level_end', Entity)

function le:initialize (x,y)
  Entity.initialize(self,x,y,16,16,'level_end')
  self.group = 'trigger'
  self.solid = true
  self.sprite = Sprite:new("level end sprite",'gen_hazard',16,16,0,0)
  self.sprite:add_animation('idle',{1},1)
  self.sprite:set_animation('idle')
  --self:add_state('idle', State:new())
  --self.next_state = 'idle'

  self:set_collision_filter('player','cross')
end

function le:on_collision()
  G.load_next_level()
end

return le
