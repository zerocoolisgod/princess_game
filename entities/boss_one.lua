local Class           = require 'lib.middleclass'
local SpawnerClass    = require "class.spawner_class"

local lgr = love.graphics.rectangle
local lgsc = love.graphics.setColor
local className = "Duck Wiz Spawner"


local e = Class(className, SpawnerClass)

function e:initialize (x,y)
  SpawnerClass.initialize (self,x,y,"ent_duck_wiz")
  self.group = nil
  self.solid = false
  self.spawn_delay = 3
  self.positions = {
    {x=160,y=88},
    {x=32,y=40},
    {x=280,y=40},
    {x=32,y=96},
    {x=280,y=96}
  }
  G.boss_health = 6
end

function e:on_update_last(dt)
  if not self.ent and self.timers.respawn <=0 then
    local pos = self.positions[love.math.random(#self.positions)]

    if G.boss_health < 1 then 
      self:set_spawn_type("at_next_stage")
      pos.x = 160
      pos.y = 104
    end
    
    self.timers.respawn = self.spawn_delay
    self.ent = G.resource_manager:get_new_object(self.spawn_type, pos.x, pos.y)
    G.add_object(self.ent)
  end
end

function e:on_draw_first()
  local base_x = 200
  for i=1, G.boss_health do
    love.graphics.rectangle("fill", base_x+i*10, 8, 8, 8)
  end
end

function e:off_screen_update (dt)
  
end

return e