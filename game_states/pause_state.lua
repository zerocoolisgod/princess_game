-- Pause State
local Class = require 'lib.middleclass'
local State = require'class.game_state_class'

--[[
Localized Framework Calls
--]]
local lg    = love.graphics
local lgd   = love.graphics.draw
local lgr   = love.graphics.rectangle
local lgp   = love.graphics.print
local lgsc  = love.graphics.setColor


local ps =  Class('pause_state',State)


--Constructor
function ps:initialize()
  State.initialize(self,'pause_state')
  self.font = love.graphics.getFont()
  self.text = love.graphics.newText(self.font,'Pause')
  --self.text:getWidth()
end

function ps:on_enter ()
  love.graphics.setBackgroundColor(0, 0, 0)
  G.camera:set_pos(0,0)
end

function ps:update (dt)
  if G.inputs.start:pressed() then
    G.change_state('play_state')
  elseif G.inputs.select:pressed() then
    G.change_state('init_load_state')
  end

end


function ps:draw ()
  ---[[
  local x,y,r,sx,sy,ox,oy
  x = C_SIZE.x/2
  y = C_SIZE.y/2
  r = 0
  sx = 1
  sy = 1
  ox = self.text:getWidth() / 2
  oy = self.text:getHeight() / 2
  love.graphics.draw(self.text,x,y,r,sx,sy,ox,oy)
  self:draw_colors()
  --]]
end

function ps:draw_colors ()
  
  local i = 1
  for y =1,(#C_COLOR / 16) do
    for x=1,16 do
      lgsc(C_COLOR[i])
      lgr('fill',x*4,y*4,4,4)
      i=i+1
    end
  end

  lgsc(255,255,255)
end

function ps:add_object (obj)

end

return ps
