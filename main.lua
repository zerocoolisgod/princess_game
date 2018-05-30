-- Do I Have To Be The Princess?


--_BUILD_FOR_PI = true
_BUILD_FOR_LAPPY = true
_NO_ZOOM=true

-- Localized fdcsga
local volume = 1

-------------------------------------------------------------------------------
-- Load Function
-------------------------------------------------------------------------------
function love.load(arg)
  -- Scaling filter / Mouse Cursor Off
  love.graphics.setDefaultFilter('nearest')
  love.mouse.setVisible(false)

  -- load font
  local font = love.graphics.newFont('res/font/font_3.ttf', 8)
  love.graphics.setFont(font)
  

  -- Volume
  love.audio.setVolume(volume)

  require "globals.ALL"
  
  love.graphics.setBackgroundColor(0/254,0/254,0/254,254/254)

  -- Debug Manager
  G.debug_manager:load()

  if arg[2] then G.cl_switch(arg) end
  
  for i=0,1000 do
    love.math.random(i)
  end
  
end


-------------------------------------------------------------------------------
-- Main Loop
-------------------------------------------------------------------------------
function love.update(dt)
  G.gametime = G.gametime + dt
  G.game_manager:update(dt)
  G.debug_manager:update(dt)
end

-------------------------------------------------------------------------------
-- Drawing Loop
-------------------------------------------------------------------------------
function love.draw()
  G.game_manager:draw()
  G.debug_manager:draw()
  --G.draw_camera_boundary()
end


-------------------------------------------------------------------------------
-- Other Callbacks
-------------------------------------------------------------------------------
function love.focus(f)
  G.in_focus = f
end


function love.keypressed(key, isrepeat)
  G.game_manager:keypressed(key, isrepeat)
  if key == 'escape' or key == 'q' then
    love.event.quit()
  end
end


function love.joystickpressed(joystick, button)
  G.game_manager:joystickpressed(joystick, button)
end


function love.joystickaxis(joystick, axis, value)
  G.game_manager:joystickaxis(joystick, axis, value)
end
