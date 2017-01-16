local Class = require 'lib.middleclass'
local State = require'class.game_state_class'
-- Option screen for setting up inputs


local OSS = Class('option_screen_state',State)



function OSS:initialize()
  State.initialize(self,'option_screen_state')
  self.input_labels = {'up','down','left','right','jump','act_1','select','start'}
  self.current_ip = ''
  self.waiting = false
  self.counter = 0
  self.prev_ax_ip = {a,d}
  
end

function OSS:on_enter ()
  self.current_ip = ''
  self.waiting = false
  self.counter = 0
  self.prev_ax_ip = {a,d}
  love.graphics.setBackgroundColor(0, 0, 0)
end

function OSS:update(dt)
  local done = false
  if self.counter > #self.input_labels then
    done = true
    G.change_state('title_screen_state')
  end

  if not self.waiting and not done then
    self.counter = self.counter + 1
    self.current_ip = self.input_labels[self.counter]
    self.waiting = true
  end
end

function OSS:draw()
  
  local ip = self.current_ip or 'done'
  local msg = 'Press a key for '..ip
  love.graphics.print(msg,64,64)
end

function OSS:set_inputs_default()
  G.inputs = {}
  G.inputs.up = dir:new('up','w',2,-1 )
  G.inputs.down = dir:new('down','s',2,1)
  G.inputs.left = dir:new( 'left','a',1,-1)
  G.inputs.right = dir:new('right','d',1,1)
  G.inputs.jump = ip:new('jump', 'k', 2)
  G.inputs.act_1 = ip:new('act_1','j', 3)
  G.inputs.start = ip:new('start','space', 10)
  G.inputs.select = ip:new('select','tab', 9)
end

function OSS:keypressed(key, isrepeat)
  local ip = require "class.input_class"
  if self.waiting then
    G.inputs[self.current_ip] = ip:new(self.current_ip,key,nil)
    self.waiting = false
  end
end

function OSS:joystickpressed( joystick, button )
  print (joystick)
  local ip = require "class.input_class"
  if self.waiting then
    G.inputs[self.current_ip] = ip:new(self.current_ip,nil,button,joystick)
    self.waiting = false
  end
end

function OSS:joystickaxis( joystick, axis, value)
  local dir = require "class.input_dir_class"
  local cur_ax_ip = {a = axis, v =  value}
  if self.waiting and cur_ax_ip ~= self.prev_ax_ip and cur_ax_ip.v ~= 0 then
    --waitin and not previouse input and not returning to center
    G.inputs[self.current_ip] = dir:new(self.current_ip,nil,axis,value,joystick)
    self.waiting = false
    self.prev_ax_ip = cur_ax_ip
  end
end

return OSS
