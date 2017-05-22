local Class           = require 'lib.middleclass'
local SpawnerClass    = require "class.spawner_class"

local lgr = love.graphics.rectangle
local lgsc = love.graphics.setColor
local className = "Duck Shoot Spawner"


local e = Class(className, SpawnerClass)

function e:initialize (x,y)
  SpawnerClass.initialize (self,x,y,"ent_duck_shoot")
  self.group = groupName
  self.solid = false
  self.spawn_delay = 3
end

return e