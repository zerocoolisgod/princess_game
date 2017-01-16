--[[
Localized Framework Calls
--]]
local lg = love.graphics
local lgd = lg.draw
local lgr = lg.rectangle
local lgp = lg.print
local lgsc = lg.setColor
local m_fl = math.floor
local m_abs = math.abs
local key_down = love.keyboard.isDown
local get_FPS = love.timer.getFPS
local get_window_mode = love.window.getMode
local t_insert = table.insert


local DBM ={}

function DBM:load()
  DBM.img = G.resource_manager:get_image('debug_tab')

  DBM.ip = {}

  DBM.running = false

  DBM.line_h = 8
  DBM.vars = {}
  DBM.var_1 = ''
  DBM.var_2 = ''
  DBM.var_3 = ''
  DBM.var_4 = ''

  -- Debug Inputs
  local ip = require "class.input_class"
  DBM.ip.dbg_mode = ip:new('dbg_mode','f1')
  DBM.ip.fullscreen = ip:new('f')
  DBM.ip.key_1 = ip:new('1')
  DBM.ip.key_2 = ip:new('2')
  DBM.ip.key_3 = ip:new('3')
  DBM.ip.key_4 = ip:new('4')
end


function DBM:update (dt)
  -- update inputs
  for k,v in pairs(self.ip) do
    v:update(dt)
  end

  if self.running then
    if DBM.ip.key_1:pressed() then

    end
    if self.ip.key_2:pressed() then

    end
    if self.ip.key_3:pressed() then
      print('DBG KEY 3')
    end
    if self.ip.key_4:pressed() then
      print('DBG KEY 4')
    end
  end


  -- ON/OFF switch
  if self.ip.dbg_mode:pressed() or (G.inputs.select:down() and G.inputs.act_1:pressed()) then
    if self.running then
      print('DBG MODE OFF')
      self.running = false
      G.debug_off()
    else
      print('DBG MODE ON')
      self.running = true
      G.debug_on()
    end
  end
end

function DBM:draw ()
  if self.running then
    lgsc(255, 255, 255, 128)
    lgd(self.img)
    lgsc(255, 255, 255)
    self:draw_watchers()
    lgp(self.var_1, 240, 2*self.line_h)
    lgp(self.var_2, 240, 3*self.line_h)
    lgp(self.var_3, 240, 4*self.line_h)
    lgp(self.var_4, 240, 5*self.line_h)
    lgsc(255, 255, 255)
  end
  self:clear_watchers()
end

function DBM:draw_watchers()
  for i = 1, #self.vars do
    lgp(self.vars[i], 16, i*self.line_h)
  end
end

function DBM:clear_watchers ()
  self.vars = {}
  local fps = get_FPS()
  self:watch("fps: "..fps)
end

function DBM:watch (v)
  t_insert(self.vars,v)
end

function DBM:print (v,n)
  -- for special cases
  -- if you only need to update a variable durring a certin point
  -- or for tracking local variables
  if n==1 then
    self.var_1 = v
  end
  if n==2 then
    self.var_2 = v
  end
  if n==3 then
    self.var_3 = v
  end
  if n==4 then
    self.var_4 = v
  end
end

return DBM
