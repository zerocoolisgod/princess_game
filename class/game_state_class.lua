local Class = require 'lib.middleclass'
-- Class of game states
-- Almost identical to ent_states except it has methodes for all
-- Love callbacks, and does not have a update>ent_update loop for
-- mid loop standerd update processing


local State = Class('Game_State')

function State:initialize(name)
  self.id = name or 'Unnamed State'
end

function State:on_enter() end
function State:on_exit() end
function State:update(dt) end
function State:draw() end

function State:focus() end
function State:keypressed(key,isrepeat) end
function State:keyreleased() end
function State:lowmemory() end
function State:mousefocus() end
function State:mousemoved() end
function State:mousepressed() end
function State:mousereleased() end
function State:quit() end
function State:resize() end

function State:visible() end
function State:wheelmoved() end
function State:gamepadaxis() end
function State:gamepadpressed() end
function State:gamepadreleased() end
function State:joystickadded() end
function State:joystickaxis(joystick, axis, value) end
function State:joystickhat() end
function State:joystickpressed(joystick, button) end
function State:joystickreleased(joystick, button) end
function State:joystickremoved() end


function State:get_id() return self.id end


return State
