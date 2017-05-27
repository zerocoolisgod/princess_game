local Class = require 'lib.middleclass'

--- Create a new object for each input
-- return down, up, pressed, released
-- keyboard and gamepad buttons

local input = Class('Input')

local key_down = love.keyboard.isDown

function input:initialize (id, key, button, joystick)
  self.id = id or 'generic input'
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
  self.gp.id = button or 1000
  self.gp.last_state = false
  self.gp.current_state = false
end

function input:get_key_id()
  return self.kb.id
end

function input:get_button_id()
  local id = self.gp.id
  if id == 1000 then id = "None set" end
  return id
end

function input:up ()
  local kb = self.kb.current_state
  local gp = self.gp.current_state
  if not kb and not gp then
    return true
  else
    return false
  end
end

function input:down ()
  local kb = self.kb.current_state
  local gp = self.gp.current_state
  if kb or gp then
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

  if (kb_c and not kb_l) or (gp_c and not gp_l) then

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

  if (not kb_c and kb_l) or (not gp_c and gp_l) then
    return true
  else
    return false
  end
end

function input:update (dt)
  self.kb.last_state = self.kb.current_state
  self.kb.current_state = key_down(self.kb.id)

  if self.gp_device and self.gp.id then
    self.gp.last_state = self.gp.current_state
    self.gp.current_state = self.gp_device:isDown(self.gp.id)
  end
end

return input
