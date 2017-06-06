-- GUI
-- This class is verry specific to this game, needs to be
-- generalized.
local Class = require 'lib.middleclass'

--[[
Localized Framework Calls
--]]
local lgd   = love.graphics.draw
local lgr   = love.graphics.rectangle
local lgp   = love.graphics.print
local lgsc  = love.graphics.setColor
local bptypes = {normal=1,fire=2}

local GUI = Class('GUI')

function GUI:initialize()
  self.game_time = {m=0,s=0,ms=0}
  self.ph_img = G.resource_manager:get_image('hud_health_sheet')
  self.ph_quads = G.cut_quads(self.ph_img, {x=8,y=8},2,1)
  self.coin_img = G.resource_manager:get_image('hud_key_sheet')
  self.bp_img = G.resource_manager:get_image('hud_bp_sheet')
  self.bp_quads = G.cut_quads(self.bp_img, {x=8,y=8})
  self.sub_id={none=8,fire=2,boot=3}
  --self.bp_color = {{0, 97, 255},{149, 0, 0}}
end


function GUI:update (dt)

end


function GUI:draw ()
  self:draw_player_health()
  self:draw_coins()
  
  self:draw_bp()
  self:draw_sub()
end

function GUI:draw_player_health ()
  local ph = G.get_player_health()
  local phm = G.get_player_health_max()
  for i=1,phm do
    local x,y
    local q = 2
    if ph >=i then q = 1 end
    x = 8 + (10 * (i-1))
    y = 6
    self:draw_ph_sprite(x,y,q)
  end
end

function GUI:draw_ph_sprite(x,y,q)
  local i = self.ph_img
  local qd = self.ph_quads[q]
  lgd(i,qd,x,y)
end

function GUI:draw_coins ()
  local icon_x,icon_y,text_x,text_y

  icon_x = (C_SIZE.x/2) - 8
  icon_y = 6
  text_x = icon_x + 10
  text_y = 6
  lgsc(255,255,255,255)
  lgd(self.coin_img, icon_x, icon_y)
  lgp('x'..G.get_coins(), text_x, text_y)
end

function GUI:draw_bp()
  local quad_index = 9
  local full = G.bubble_power_max
  local mid = full * .66
  local low = full * .33
  local bubble_power = G.get_bubble_power("normal")
  if bubble_power < full then quad_index = 10 end
  if bubble_power < mid then quad_index = 11 end
  if bubble_power < low then quad_index = 12 end
  lgd(self.bp_img, self.bp_quads[quad_index], 8, 16)
  if G.bubble_type == "normal" then lgd(self.bp_img, self.bp_quads[13], 8, 16) end
end



function GUI:draw_sub()
  --status bar
  local sbx,sby = 28,16
  local w = G.get_bubble_power("sub")
  lgsc({149, 0, 0})
  lgr('fill', sbx, sby, w, 8)
  lgsc(255, 255, 255, 255)
  
  -- bottle sprite
  local sx,sy = 18,16
  local q = self.sub_id[G.get_subweapon()]
  --if G.active_subweapon then q = 2 end
  lgd(self.bp_img, self.bp_quads[q], sx, sy)
  --draw selector
  if G.bubble_type ~= "normal" then lgd(self.bp_img, self.bp_quads[13], sx, sy) end

  -- bar sprite
  local bsx,bsy = 28,16
  lgd(self.bp_img, self.bp_quads[5], bsx, bsy)
  for i=1,8 do
    lgd(self.bp_img, self.bp_quads[6], bsx+8*i, bsy)
  end
  lgd(self.bp_img, self.bp_quads[7], bsx+8*9, bsy)
  
end

return GUI
