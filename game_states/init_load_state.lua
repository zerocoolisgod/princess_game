local Class = require 'lib.middleclass'
local State = require 'class.game_state_class'

local lgp = love.graphics.print

local ILS = Class('init_load_state',State)

--[[
To be used if loading gets too long befor the game starts
]]


function ILS:initialize()
  State.initialize(self,'init_load_state')
  self.img = G.resource_manager:get_image('temp_loading_screen')
  self.start_time = G.gametime or 0
  self.delay = 10
  self.delay = self.delay + self.start_time
end

function ILS:on_enter ()
  
end

function ILS:update(dt)
  self.delay = self.delay - dt
  if self.delay <= 0 or G.inputs.start:pressed() then
    G.change_state('title_screen_state')
  end
end

function ILS:draw()
  lgp( "Press "..G.inputs.start:get_key_id().." to Continue.",64,16)
  lgp( "Up:     Keys "..G.inputs.up:get_key_id(),32,32)
  lgp( "Down:        "..G.inputs.down:get_key_id(),32,48)
  lgp( "Left:        "..G.inputs.left:get_key_id(),32,64)
  lgp( "Right:       "..G.inputs.right:get_key_id(),32,80)
  lgp( "Jump:        "..G.inputs.jump:get_key_id(),32,96)
  lgp( "Shoot:       "..G.inputs.act_1:get_key_id(),32,112)
  lgp( "Pause:       "..G.inputs.start:get_key_id(),32,128)
  lgp( "Weapon:      "..G.inputs.select:get_key_id(),32,144)
  
  local x = 160
  lgp( "JoyPad "..G.inputs.up:get_button_id(),x,32)
  lgp( "       "..G.inputs.down:get_button_id(),x,48)
  lgp( "       "..G.inputs.left:get_button_id(),x,64)
  lgp( "       "..G.inputs.right:get_button_id(),x,80)
  lgp( "       "..G.inputs.jump:get_button_id(),x,96)
  lgp( "       "..G.inputs.act_1:get_button_id(),x,112)
  lgp( "       "..G.inputs.start:get_button_id(),x,128)
  lgp( "       "..G.inputs.select:get_button_id(),x,144)
  

end

return ILS
