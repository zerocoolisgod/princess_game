-- Heart basic health recovery
local Class     = require 'lib.middleclass'
local Entity    = require "class.entity_class"
local Sprite    = require 'class.sprite_class'


local p = Class('dragon fly', Entity)

function p:initialize (x,y)
  Entity.initialize(self,x,y,8,14,'dragon fly')
  self.group = "decoration"
  self.solid = true
  self.sprite = Sprite:new("dragon fly sprite",'pickup_sheet',16,16,0,0)
  self.sprite:add_animation('idle',{13,14,15,14},10)
  self.sprite:set_animation('idle')
  self:set_collision_filter("bubble","cross")

  local f = love.math.random(4)
  self.sprite:set_frame(f)
end


function p:on_collision()
  local obj_typs={"ent_sub_fire","ent_heart","ent_bubble_jar","ent_bubble_jar","ent_bubble_jar","ent_bubble_jar",}
  local d = love.math.random(#obj_typs)
  print(d)
  if d <= #obj_typs then
    local x,y = self:get_true_pos()
    local o = G.resource_manager:get_new_object(obj_typs[d],x,y)
    G.add_object(o)
  end
  self.remove=true

end

return p
