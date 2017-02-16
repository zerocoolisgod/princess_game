local Class = require 'lib.middleclass'
local State = require 'class.game_state_class'

local SLS = Class('stage_load_state',State)



function SLS:initialize()
  State.initialize(self,'stage_load_state')
  self.delay = .5
  self.delay_end = self.delay + G.gametime
end

function SLS:on_enter ()
  G.resource_manager:play_music('song_03', .5)
  self.font = love.graphics.getFont()
  self.text = love.graphics.newText(self.font, G.current_map.name)
  self.delay_end = self.delay + G.gametime
  love.graphics.setBackgroundColor(0, 0, 0)
  G.camera:set_pos(0,0)
  G.clear_coins()
end

function SLS:update(dt)
  if G.gametime > self.delay_end then
    local map = G.current_map
    -- G.load_next_stage()
    G.change_state('play_state')
    G.resource_manager:play_music(map.music, .3)
  end
end

function SLS:draw()
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

return SLS
