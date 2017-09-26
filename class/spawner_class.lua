local Class     = require 'lib.middleclass'
local Entity    = require "class.entity_class"

local lgr = love.graphics.rectangle
local lgsc = love.graphics.setColor

local e = Class("Spawner Class", Entity)

function e:initialize (x,y,type)
  Entity.initialize (self, x, y, 1, 1, "spawner")
  self.solid = false
  self.spawn_type = type
  self.spawn_delay = 5
  self.timers.respawn = 0.2
  self.first_spawn = false
  self.ent = nil
end

function e:on_update_first(dt)
  if self.ent and self.ent.remove then self.ent = nil end
  if self.ent then self.timers.respawn = self.spawn_delay end
  -- comment out to revert to off screen spawning only
  self:check_for_spawn()
end

function e:off_screen_update (dt)
  self:update_timers(dt)
  self:check_for_spawn()
end

function e:check_for_spawn()
  if not self.ent and (self.timers.respawn <= 0) then
    --self.ent = G.resource_manager:get_new_object(self.spawn_type, self.pos.x, self.pos.y)
    self.ent = G.resource_manager:get_new_object("spn_cloud", self.pos.x, self.pos.y)
    self.ent:set_spawn(self.spawn_type)
    G.add_object(self.ent)
  end
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
