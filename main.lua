-- Do I Have To Be The Princess?
-- we doing GIT now, seeing as i will not beable to work from a
-- USB pen anymore :(

-- Localized
local volume = 0

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
  require "lib.game_math"

  -- Debug Manager
  G.debug_manager:load()

  -- Deal with command line switches
  if arg[2] then
    local a = arg[2]
    print("cmd arg: "..a)
     print("file arg: "..arg[3])
    if a == "-load_map" then
      local map_path = arg[3]
     
      local dir, file = map_path:match'(.*/)(.*)'
      if not file then dir, file = map_path:match'(.*\\)(.*)' end
      local ext = file:find(".tmx")
      local map_name = file:sub(0,ext-1)

      print("loading: "..map_name)
      if G.load_stage_from_cl(map_name) then G.change_state("play_state") end
    end
  end
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
