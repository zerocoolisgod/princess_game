--[[
Localized Framework Calls
--]]
local lg = love.graphics
local lgd = love.graphics.draw
local lgp = love.graphics.print
local lgsc = love.graphics.setColor

-- Imports
local loc = "game_states."
local Load_State        = require (loc.."init_load_state")
local Options_State     = require (loc.."options_screen_state")
local Title_State       = require (loc.."title_screen_state")
local Pause_State       = require (loc.."pause_state")
local Play_State        = require (loc.."play_state")
local Stage_Load_State  = require (loc.."stage_load_state")
local Player_Died_State = require (loc.."player_died_state")
local Camera = require "class.camera_class"




--Love Callback parody
function G.game_manager:load ()
  self.debug = false
  self.current_state = 'init_load_state'
  self.next_state = 'init_load_state'

  -- States
  self.states = {}
  self.states.init_load_state = Load_State:new()
  self.states.options_screen_state = Options_State:new()
  self.states.title_screen_state = Title_State:new()
  self.states.pause_state = Pause_State:new()
  self.states.play_state = Play_State:new()
  self.states.stage_load_state = Stage_Load_State:new()
  self.states.player_died_state = Player_Died_State:new()
end

-------------------------------------------------------------------------------
-- Main Game Update Callback
-------------------------------------------------------------------------------
function G.game_manager:update (dt)
  -- Update all registered inputs
  for k,v in pairs(G.inputs) do
    v:update(dt)
  end

  -- special quit button combo
  if G.inputs.start:down() and G.inputs.select:down() then
    love.event.quit()
  end

  -- Camera hangles the change to fullscreen
  if G.inputs.fullscreen:pressed() then
    G.camera:toggle_fullscreen()
  end

  --
  if G.inputs.reboot:pressed() then
    G.change_state('init_load_state')
  end

  if self.current_state ~= self.next_state then
    if not self.states[self.next_state] then G.error(self.next_state..' is not a valid state!')end
    self.current_state = self.next_state
    self.states[self.current_state]:on_enter()
  end

  if G.in_focus then
    self.states[self.current_state]:update(dt)
  end
  self:db_update(self.debug,dt)
end

-------------------------------------------------------------------------------
-- Main Game Draw Callback --
-------------------------------------------------------------------------------
function G.game_manager:draw ()
  local draw_state = self.current_state
  --if draw_state == 'pause_state' then draw_state = 'play_state' end
  G.camera:set()
  self.states[draw_state]:draw()
  G.camera:unset()
  if self.states[self.current_state].gui then
    G.camera:set_gui()
    self.states[self.current_state].gui:draw()
    G.camera:unset()
  end
end


-------------------------------------------------------------------------------
-- Optional Game Callbacks --
-------------------------------------------------------------------------------
function G.game_manager:focus()
  self.states[self.current_state]:focus()
end

function G.game_manager:keypressed(key, isrepeat)
  self.states[self.current_state]:keypressed(key, isrepeat)
end

function G.game_manager:keyreleased()
  self.states[self.current_state]:keyreleased()
end

function G.game_manager:lowmemory()
  self.states[self.current_state]:lowmemory()
end

function G.game_manager:mousefocus()
  self.states[self.current_state]:mousefocus()
end

function G.game_manager:mousemoved()
  self.states[self.current_state]:mousemoved()
end

function G.game_manager:mousepressed()
  self.states[self.current_state]:mousepressed()
end

function G.game_manager:mousereleased()
  self.states[self.current_state]:mousereleased()
end

function G.game_manager:quit()
  self.states[self.current_state]:quit()
end

function G.game_manager:resize()
  self.states[self.current_state]:resize()
end

function G.game_manager:threaderror()
  self.states[self.current_state]:threaderror()
end

function G.game_manager:visible()
  self.states[self.current_state]:visible()
end

function G.game_manager:wheelmoved()
  self.states[self.current_state]:wheelmoved()
end

function G.game_manager:gamepadaxis()
  self.states[self.current_state]:gamepadaxis()
end

function G.game_manager:gamepadpressed(joystick, button)
  self.states[self.current_state]:gamepadpressed(joystick, button)
end

function G.game_manager:gamepadreleased()
  self.states[self.current_state]:gamepadreleased()
end

function G.game_manager:joystickadded()
  self.states[self.current_state]:joystickadded()
end

function G.game_manager:joystickaxis(joystick, axis, value)
  self.states[self.current_state]:joystickaxis(joystick, axis, value)
end

function G.game_manager:joystickhat()
  self.states[self.current_state]:joystickhat()
end

function G.game_manager:joystickpressed(joystick, button)
  self.states[self.current_state]:joystickpressed(joystick, button)
end

function G.game_manager:joystickreleased()
  self.states[self.current_state]:joystickreleased()
end

function G.game_manager:joystickremoved()
  self.states[self.current_state]:joystickremoved()
end


-------------------------------------------------------------------------------
-- Debug Functions
-------------------------------------------------------------------------------
function G.game_manager:db_update(db,dt)
  if db then
    G.debug_manager:watch('Game State: '..self.current_state)
  end
end

function G.game_manager:get_state()
  return self.current_state
end



