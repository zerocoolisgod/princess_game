local Class = require 'lib.middleclass'
local State = require 'class.game_state_class'

local ILS = Class('init_load_state',State)

--[[
To be used if loading gets too long befor the game starts
]]


function ILS:initialize()
  State.initialize(self,'init_load_state')
  self.img = G.resource_manager:get_image('temp_loading_screen')
  self.start_time = G.gametime or 0
  self.delay = 0
  self.delay = self.delay + self.start_time
end

function ILS:on_enter ()

end

function ILS:update(dt)
  --G.set_player_checkpoint(660,192)
  local s = 'title_screen_state'
  G.change_state(s)
end

function ILS:draw()
  love.graphics.draw(self.img)
end

return ILS
