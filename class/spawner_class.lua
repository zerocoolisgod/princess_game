local Class     = require 'lib.middleclass'
local Entity    = require "class.entity_class"

local lgr = love.graphics.rectangle
local lgsc = love.graphics.setColor

local className = "Spawner Class"
local entityId  = "spawner"
local sizeX = 1
local sizeY = 1

local e = Class(className, Entity)

function e:initialize (x,y,type)
  Entity.initialize (self,x,y,sizeX,sizeY,entityId)
  self.solid = false
  self.spawn_type = type
  self.spawn_delay = 5
  self.timers.respawn = 5
  self.first_spawn = true
  self.ent = nil
end

function e:on_update_first(dt)
  if self.first_spawn then
    self.first_spawn = false
    self.ent = G.resource_manager:get_new_object(self.spawn_type, self.pos.x, self.pos.y)
    G.add_object(self.ent)
  end
  if self.ent then
    if self.ent.remove then self.ent = nil end
    self.timers.respawn = self.spawn_delay
  end
end

function e:on_update_last(dt)
  
end

function e:off_screen_update (dt)
  if not self.ent and self.timers.respawn <=0 then
    self.timers.respawn = self.spawn_delay
    self.ent = G.resource_manager:get_new_object(self.spawn_type, self.pos.x, self.pos.y)
    G.add_object(self.ent)
  end
end

function e:on_draw_first()
end

function e:on_collision ()
  
end

function e:draw_bounding_box()
  --draws a yellow box of self.size at self.position
  local x,y,w,h, vel
  x = self.pos.x
  y = self.pos.y
  w = self.size.x
  h = self.size.y

  lgsc(255, 64, 156, 128)
  lgr("fill", x, y, w, h)
  lgsc(255, 255, 0,255)
  lgr("line", x, y, w, h)
  lgsc(255, 255, 255,255)
end

function e:set_spawn_type(type)
  self.spawn_type = type
end

return e
