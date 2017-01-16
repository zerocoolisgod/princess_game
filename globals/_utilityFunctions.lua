if not G then G={} end

function G.cut_quads (img, frame_size, buffer, margin)
  -- Cut quads
  local t_insert = table.insert
  local b = buffer or 0
  local frame_height = frame_size.y
  local m = margin or 0

  local image_width = img:getWidth()
  local image_height = img:getHeight()
  local frame_width = frame_size.x
  local q_table = {}

  -- Position in image is based on cells,
  -- frame size is the size of the tile or spriteframe.
  -- If we are using a buffered sprite sheet then the cell
  -- will be the size of the frame + 2 buffer on all 4 sides,
  -- or cx=fx+b*2 cy=fy+b*2
  local cell_w = frame_width + b
  local cell_h = frame_height + b

  local number_wide = image_width / cell_w
  local number_high = image_height / cell_h

  -- Cut tile sheet into quads
  for y = 1, number_high do
    for x = 1, number_wide do
      -- add buffer to whole thing to get the first position off
      -- of the 0x and 0y
      local xpos = ((x-1) * (cell_w)) + m
      local ypos = ((y-1) * (cell_w)) + m
      t_insert(q_table,love.graphics.newQuad(xpos, ypos, frame_width, frame_height,
                                                      image_width, image_height))
    end
  end
  return q_table
end

function G.error (msg)
  love.errhand(msg)
  love.event.quit()
end

function G.debug_on()
  G.debug = true
  G.game_manager.debug = true
end

function G.debug_off()
  G.debug = false
  G.game_manager.debug = false
end