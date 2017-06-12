local Class           = require 'lib.middleclass'
local SpawnerClass    = require "class.spawner_class"

local lgr = love.graphics.rectangle
local lgsc = love.graphics.setColor
local className = "Duck Hop Spawner"


local e = Class(className, SpawnerClass)

function e:initialize (x,y)
  SpawnerClass.initialize (self,x,y,"ent_duck_pit")
  self.group = groupName
  self.solid = false
  self.spawn_delay = 4
end

function e:on_update_last(dt)
  if not self.ent and self.timers.respawn <=0 then
    self.timers.respawn = self.spawn_delay
    self.ent = G.resource_manager:get_new_object(self.spawn_type, self.pos.x, self.pos.y)
    G.add_object(self.ent)
  end
end

return e