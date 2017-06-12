local Class     = require 'lib.middleclass'
local Entity    = require "class.entity_class"
local Sprite    = require 'class.sprite_class'



local A = Class('Door', Entity)
function A:initialize (x,y,w,h,props)
  Entity.initialize (self,x,y,8,8,'door')
  self.group = 'area'
  self.solid = true
  
  self.sprite = Sprite:new('door sprite','door',16,16,0,4)
  self.sprite:add_animation('locked',{1},1)
  self.sprite:add_animation('opened',{2},1)
  self.sprite:set_animation("opened")
  
  self:set_state("opened")
  
  if props.locked then self:set_state("locked") end

end



function A:on_collision ()
  G.reset_player_spawn()
  G.load_next_stage()
end

--------------------------------------------------------------------------
-- STATES --
--------------------------------------------------------------------------

function A:init_state (s)
  if s == "opened" then 
    self.sprite:set_animation("opened")
    self:set_collision_filter('player','cross')
  end

  if s == "locked" then 
    self.sprite:set_animation("locked")
    self:set_collision_filter('player',nil)
  end
end

function A:locked()
  if G.get_coins() >= 3 then self:set_state("opened") end
end

function A:opened()
end

return A
