local Class     = require 'lib.middleclass'
local Entity    = require "class.entity_class"

-- local lg = love.graphics
-- local lgd = love.graphics.draw
-- local lgr = love.graphics.rectangle
-- local lgp = love.graphics.print
-- local lgsc = love.graphics.setColor

local e = Class("", Entity)

function e:initialize (x,y)
  Area.initialize (self,x,y,8,8,'Stage_Change')
  self.group = 'area'
  self.solid = true
  
  self.sprite = Sprite:new('door sprite','door',16,16,0,4)
  self.sprite:add_animation('closed',{1},1)
  self.sprite:add_animation('open',{2},1)
  self.sprite:set_animation("open")
  
  self:set_collision_filter('player','cross')
end

function A:on_update_last(dt)
  self.sprite:update(dt)
end

function A:on_draw()
  local sx,sy,x,y, alph
  alph = self.alpha or 255
  sy = 1
  x,y = self:get_pos()
  self.sprite:draw(1,sy,x,y,alph)
  if G.debug then self:draw_bounding_box() end
end

function A:on_collision ()
  G.reset_player_spawn()
  G.load_next_stage()
end

function A:draw_bounding_box()
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

return A
