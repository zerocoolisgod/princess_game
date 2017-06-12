local Class           = require 'lib.middleclass'
local SpawnerClass    = require "class.spawner_class"

local lgr = love.graphics.rectangle
local lgsc = love.graphics.setColor
local className = "Duck Run Spawner"


local e = Class(className, SpawnerClass)

function e:initialize (x, y, w, h, ent_id)
  SpawnerClass.initialize (self, x, y, ent_id)
  self.group = groupName
  self.solid = false
  self.spawn_delay = 3
end

return e