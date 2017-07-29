local Class = require 'lib.middleclass'
local State = require'class.game_state_class'


local lgd = love.graphics.draw
local lgp = love.graphics.print
local lgsc = love.graphics.setColor

local ts = Class('title_screen_state',State)

function ts:initialize()
  State.initialize(self,'title_screen_state')
  self.text_alpha = 255
  self.text_fade_out = true
  self.img = G.resource_manager:get_image('title_screen')
end

function ts:on_enter ()
  love.graphics.setBackgroundColor(0, 0, 0)
  G.current_map = nil
  --G.resource_manager:play_music('song_01', .5)
  G.camera:reset_pos()
end

function ts:update(dt)
  local start = G.inputs.start:pressed()
  local select = G.inputs.select:pressed()
    local fade_rate = 300
  if start then
    --G.resource_manager:play_music('song_00', .3)
    -- reset our color fuckery
    lgsc(255,255,255,255)
    G.load_next_stage()
  elseif select then
    lgsc(255,255,255,255)
    G.change_state('options_screen_state')
  end
  
  if self.text_fade_out then
    self.text_alpha = self.text_alpha - (fade_rate*dt)
    if self.text_alpha <=0 then self.text_fade_out = false end
  else
    self.text_alpha = self.text_alpha + (fade_rate*dt)
    if self.text_alpha >=255 then self.text_fade_out = true end
  end

  G.cheats()
end


function ts:draw()
  lgd(self.img)
  lgsc(200,200,200,self.text_alpha)
  lgp('Press Space to Start',76,150)
  lgsc(200,200,60,self.text_alpha*2)
  lgp('Press Tab to Set Controls',55,160)
  lgsc(200,200,200,255)
  lgp(G.current_stage_number+1,8,8)
  lgsc(255,255,255,255)
end

return ts
