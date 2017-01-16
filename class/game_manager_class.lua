-- Game Manager Class
local Class = require "lib.middleclass"

--[[
Localized Framework Calls
--]]
local lg = love.graphics
local lgd = love.graphics.draw
local lgp = love.graphics.print
local lgsc = love.graphics.setColor

-- Imports
local Load_State        = require "game_states.init_load_state"
local Options_State     = require "game_states.options_screen_state"
local Title_State       = require "game_states.title_screen_state"
local Pause_State       = require "game_states.pause_state"
local Play_State        = require "game_states.play_state"
local Stage_Load_State  = require "game_states.stage_load_state"
local Player_Died_State = require "game_states.player_died_state"

local g = Class("Game Manager")

function g:initialize()
  self.debug = false
  self.current_state = 'init_load_state'
  self.next_state = 'init_load_state'
  
  -- Error checking
  if not G.camera then G.error("No Global Camera!!") end

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
function g:update (dt)
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
function g:draw ()
  local draw_state = self.current_state
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
function g:focus()
  self.states[self.current_state]:focus()
end

function g:keypressed(key, isrepeat)
  self.states[self.current_state]:keypressed(key, isrepeat)
end

function g:keyreleased()
  self.states[self.current_state]:keyreleased()
end

function g:lowmemory()
  self.states[self.current_state]:lowmemory()
end

function g:mousefocus()
  self.states[self.current_state]:mousefocus()
end

function g:mousemoved()
  self.states[self.current_state]:mousemoved()
end

function g:mousepressed()
  self.states[self.current_state]:mousepressed()
end

function g:mousereleased()
  self.states[self.current_state]:mousereleased()
end

function g:quit()
  self.states[self.current_state]:quit()
end

function g:resize()
  self.states[self.current_state]:resize()
end

function g:threaderror()
  self.states[self.current_state]:threaderror()
end

function g:visible()
  self.states[self.current_state]:visible()
end

function g:wheelmoved()
  self.states[self.current_state]:wheelmoved()
end

function g:gamepadaxis()
  self.states[self.current_state]:gamepadaxis()
end

function g:gamepadpressed(joystick, button)
  self.states[self.current_state]:gamepadpressed(joystick, button)
end

function g:gamepadreleased()
  self.states[self.current_state]:gamepadreleased()
end

function g:joystickadded()
  self.states[self.current_state]:joystickadded()
end

function g:joystickaxis(joystick, axis, value)
  self.states[self.current_state]:joystickaxis(joystick, axis, value)
end

function g:joystickhat()
  self.states[self.current_state]:joystickhat()
end

function g:joystickpressed(joystick, button)
  self.states[self.current_state]:joystickpressed(joystick, button)
end

function g:joystickreleased()
  self.states[self.current_state]:joystickreleased()
end

function g:joystickremoved()
  self.states[self.current_state]:joystickremoved()
end


-------------------------------------------------------------------------------
-- Debug Functions
-------------------------------------------------------------------------------
function g:db_update(db,dt)
  if db then
    G.debug_manager:watch('Game State: '..self.current_state)
  end
end

function g:get_state()
  return self.current_state
end

return g