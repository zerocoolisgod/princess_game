-- Heart basic health recovery
local Class     = require 'lib.middleclass'
local Entity    = require "class.entity_class"
local Sprite    = require 'class.sprite_class'


local p = Class('dragon fly', Entity)

function p:initialize (x,y,w,h,props)
  Entity.initialize(self,x,y,8,14,'dragon fly')
  self.group = "decoration"
  self.solid = true
  self.sprite = Sprite:new("dragon fly sprite",'pickup_sheet',16,16,0,0)
  self.sprite:add_animation('idle',{13,14,15,14},10)
  self.sprite:set_animation('idle')
  self:set_collision_filter("bubble","cross")

  self.pickup_type = props.pickup_type

  local f = love.math.random(4)
  self.sprite:set_frame(f)
end


function p:on_collision()
  self[self.pickup_type] (self)
end

function p:default()
  G.spawn_random_pickup (self:get_true_pos())
  self.remove=true
end

function p:fire()
  if G.get_subweapon() ~= "fire" then
    local x,y = self:get_true_pos()
    G.add_object( G.resource_manager:get_new_object("ent_sub_fire", x, y) )
  else
    G.spawn_random_pickup (self:get_true_pos())
  end
  self.remove = true
end

function p:boot()
  if G.get_subweapon() ~= "boot" then
    local x,y = self:get_true_pos()
    G.add_object( G.resource_manager:get_new_object("ent_sub_boot", x, y) )
  else
    G.spawn_random_pickup (self:get_true_pos())
  end
  self.remove = true
end

function p:health()
end

return p
