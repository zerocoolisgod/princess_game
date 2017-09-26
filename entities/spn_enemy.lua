local Class           = require 'lib.middleclass'
local SpawnerClass    = require "class.spawner_class"

local lgr = love.graphics.rectangle
local lgsc = love.graphics.setColor
local className = "Enemy Spawner"


local e = Class(className, SpawnerClass)

function e:initialize (x, y, w, h, props)
  SpawnerClass.initialize (self, x, y, props.spawn)
  self.group = "none"
  self.solid = false
  self.spawn_delay = 10
  if props.spawn == "ent_duck_pit" then self.spawn_delay = 2 end
end

-- function e:on_update_last(dt)
--   self:off_screen_update (dt)
-- end

return e