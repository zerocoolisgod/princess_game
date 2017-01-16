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





local GUI = Class('GUI')

function GUI:initialize()
  self.game_time = {m=0,s=0,ms=0}
  self.ph_img = G.resource_manager:get_image('hud_health_sheet')
  self.ph_quads = G.cut_quads(self.ph_img, {x=8,y=8},2,1)
  self.coin_img = G.resource_manager:get_image('hud_coin_sheet')
  self.bp_img = G.resource_manager:get_image('hud_bp_sheet')
  self.bp_quads = G.cut_quads(self.bp_img, {x=8,y=8})
  self.bp_color = {{0, 97, 255},{149, 0, 0}}
end


function GUI:update (dt)

end


function GUI:draw ()
  self:draw_player_health()
  self:draw_coins()
  self:draw_bp()
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
  lgp('x'..G.coins, text_x, text_y)
end

function GUI:draw_bp()
  local text_x, text_y = 8,16
  local r1_x,r1_y,r1_w,r1_h
  local r2_x,r2_y,r2_w,r2_h
  local qn = G.player.current_bubble_type
  local q = self.bp_quads[qn]
  -- outline
  r1_x = 8
  r1_y = 15
  r1_w = G.player.bubble_power_max + 11
  r1_h = 10
  --status bar
  r2_x = r1_x + 10
  r2_y = r1_y + 1
  r2_w = G.player.bubble_power
  r2_h = 8
  lgsc(0,0,0)
  lgr('fill',r1_x,r1_y,r1_w,r1_h)
  lgsc(self.bp_color[qn])
  lgr('fill',r2_x,r2_y,r2_w,r2_h)
  lgsc(255,255,255,255)
  lgd(self.bp_img,q,8,16)
end

return GUI
