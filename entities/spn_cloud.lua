local Class   = require 'lib.middleclass'
local Entity  = require "class.entity_class"
local Sprite  = require 'class.sprite_class'

local lgr = love.graphics.rectangle
local lgsc = love.graphics.setColor
local className = "cloud_spawner"

-- A unique spawner used mostly for bullets

local e = Class(className, Entity)

function e:initialize (x, y)
  Entity.initialize (self, x, y, 2, 2, "cloud_spawner")
  self.sprite = Sprite:new("cloud sprite","cloud_spawner",16,16,0,0)
  self.sprite:add_animation('dflt',{1,2,3,4,5,6,7},16)
  self.sprite:add_animation('done',{8},1)

  self.sprite:set_animation('dflt')
  self.has_spawned=false
  self.group = nil
  self.solid = false
  self.timers.spawn_delay = .5
end

function e:set_spawn(id, dx, dy)
  self.spawn = {
    id = id, 
    x = self.pos.x, 
    y = self.pos.y, 
    dx = dx, 
    dy = dy
  }
end

function e:on_update_first(dt)
  if self.timers.spawn_delay <= 0 and not self.has_spawned then 
    self.ent = G.resource_manager:get_new_object(self.spawn.id, self.spawn.x, self.spawn.y)
    if self.spawn.id == "ent_bullet" then
      self.ent.speed.x = 150
      self.ent:owner_init(nil, self.spawn.dx, self.spawn.dy)
    end
    G.add_object(self.ent)
    self.has_spawned = true
    self.sprite:set_animation('done')
  end
  
  if self.has_spawned and self.ent.remove then 
    self.ent = nil
    self.remove = true
  end
end

function e:on_update_last(dt)
  
end

return e