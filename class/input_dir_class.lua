local Class = require 'lib.middleclass'

--like input class but for the stupid axis

local input = Class('Direction Input')

local key_down = love.keyboard.isDown

function input:initialize (id, key, axis, dir, joystick)
  self.id = id or 'generic direction input'
  self.kb = {}
  self.kb.id = key or ''
  self.kb.last_state = false
  self.kb.current_state = false

  if joystick then
    self.gp_device = joystick
  else
    local gps = love.joystick.getJoysticks()
    self.gp_device = gps[1]
  end

  self.gp = {}
  self.gp.axis = axis or 0
  self.gp.dir = dir or 0
  self.gp.last_state = 0
  self.gp.current_state = 0
end

function input:get_key_id()
  return self.kb.id
end

function input:get_button_id()
  local id = self.gp.axis
  if id == 0 then id = self.gp.dir end
  return id
end


function input:up ()
  local kb = self.kb.current_state
  local gp = self.gp.current_state
  local dir = self.gp.dir
  if not kb and not gp == dir then
    return true
  else
    return false
  end
end

function input:down ()
  local kb = self.kb.current_state
  local gp = self.gp.current_state
  local dir = self.gp.dir

  if kb or gp == dir then
    return true
  else
    return false
  end
end

function input:pressed ()
  local kb_c = self.kb.current_state
  local kb_l = self.kb.last_state
  local gp_c = self.gp.current_state
  local gp_l = self.gp.last_state
  local dir = self.gp.dir

  if (kb_c and not kb_l) or (gp_c == dir and not gp_l == dir) then
    return true
  else
    return false
  end
end

function input:released ()
  local kb_c = self.kb.current_state
  local kb_l = self.kb.last_state
  local gp_c = self.gp.current_state
  local gp_l = self.gp.last_state
  local dir = self.gp.dir

  if (not kb_c and kb_l) or (not gp_c == dir and gp_l == dir) then
    return true
  else
    return false
  end
end

function input:update (dt)
  self.kb.last_state = self.kb.current_state
  self.kb.current_state = key_down(self.kb.id)

  if self.gp_device and self.gp.axis then
    local dir = self.gp.dir
    self.gp.last_state = self.gp.current_state
    self.gp.current_state = self.gp_device:getAxis(self.gp.axis)
  end
end

return input
