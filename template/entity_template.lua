local Class     = require 'lib.middleclass'
local Entity    = require "class.entity_class"

-- local lg = love.graphics
-- local lgd = love.graphics.draw
-- local lgr = love.graphics.rectangle
-- local lgp = love.graphics.print
-- local lgsc = love.graphics.setColor

local className = ""
local entityId  = ""
local groupName = "" --used for collision resolution

local e = Class(className, Entity)

function e:initialize (x,y)
  Entity.initialize (self,x,y,8,8,entityId)
  self.group = groupName
  self.solid = true
  
  -- self.sprite = Sprite:new(sprite id, sprite sheet name, quad sx, quad sy, offset x, offset y)
  -- self.sprite:add_animation(animation id, {frames}, delay)
    
  -- self:set_collision_filter(group,type) cross,bounce,slide
end

function e:on_update_last(dt)
  
end

function e:on_draw()
  
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

return e
