local Class = require 'lib.middleclass'


local lg = love.graphics
local lgd = love.graphics.draw
local lgr = love.graphics.rectangle
local lgp = love.graphics.print
local lgsc = love.graphics.setColor
local m_fl = math.floor
local m_abs = math.abs
local key_down = love.keyboard.isDown


local Animation = Class('Animation')

function Animation:initialize ()
  self.frames = {}
  self.fps = 0
  self.current_frame = 1
  self.timer = 0
end


function Animation:update (ent,dt)
  -- if this method is over overridden be sure to call
  -- update_frame at the end of the new method
  if self.on_update then self:on_update(ent, dt) end
  self:update_frame(dt)
end

function Animation:update_frame (dt)

  local delay = 1 / self.fps
  local total_frames = #self.frames
  local cf = self.current_frame
  self.timer = self.timer + dt

  if self.timer > delay then
    self.timer = 0
    cf = cf + 1
    if cf > total_frames then cf = 1 end
    self.current_frame = cf
  end
end


function Animation:get_frame ()
  local cf = self.current_frame
  return self.frames[cf]
end


return Animation
