local Class = require 'lib.middleclass'
local State = require 'class.game_state_class'

local PDS = Class('player_died_state',State)



function PDS:initialize()
  State.initialize(self,'player_died_state')
  self.delay = 2
  self.delay_end = self.delay + G.gametime

  self.font = love.graphics.getFont()
  self.text = love.graphics.newText(self.font,'Sorry, Try Again!')
end

function PDS:on_enter ()
  G.resource_manager:play_music('song_01', .3)
  self.delay_end = self.delay + G.gametime
  love.graphics.setBackgroundColor(0, 0, 0)
  G.camera:set_pos(0,0)
end

function PDS:update(dt)
  if G.gametime > self.delay_end then
    G.restart_stage()
    --G.change_state('play_state')
    G.resource_manager:play_music('song_00', .3)
  end
end

function PDS:draw()
  local x,y,r,sx,sy,ox,oy
  x = C_SIZE.x/2
  y = C_SIZE.y/2
  r = 0
  sx = 1
  sy = 1
  ox = self.text:getWidth() / 2
  oy = self.text:getHeight() / 2
  love.graphics.draw(self.text,x,y,r,sx,sy,ox,oy)
end

return PDS
