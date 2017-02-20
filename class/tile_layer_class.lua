local Class = require 'lib.middleclass'
-- Tile manager
-- designed to function as a layer
-- will build tile objects when suplied with an tile layer from Tiled
-- requires resource manager to function

--[[
Localized Framework Calls
--]]
local lg    = love.graphics
local lgd   = love.graphics.draw
local lgp   = love.graphics.print
local lgr   = love.graphics.rectangle
local lgsc  = love.graphics.setColor


local Tile_Layer = Class('Tile Layer')

function Tile_Layer:initialize (parent)
  self.id = "Tile Layer"
  self.parent = parent
  self.tiles = {}
  self.solid = {}
end

function Tile_Layer:load (map, layer)
  local ts_data = map.tilesets[1]
  local tile_seize = {x = ts_data.tilewidth, y = ts_data.tileheight}
  local buffer = ts_data.spacing
  local margin = ts_data.margin

  self.tiles  = {}
  self.tile_quads = {}
  self.map_size = {x=0,y=0}
  self.tile_sheet = G.resource_manager:get_image(ts_data.name)
  self.tile_batch = lg.newSpriteBatch(self.tile_sheet)
  self.tile_batch:setBufferSize(2048)
  self.map_size.y = map.height
  self.map_size.x = map.width
  self.tile_quads = G.cut_quads(self.tile_sheet,tile_seize,buffer,margin)

  for i = 1, map.height do
    self.tiles[i] = {}
  end

  self:add_tiles(map,layer)
end

function Tile_Layer:update (dt)
  -- body...
end


function debug_adjust(t)
  local rt = t
  if love.keyboard.isDown("up") then
    rt.x = rt.x + 1
  elseif love.keyboard.isDown("down") then
    rt.x = rt.x - 1
  elseif love.keyboard.isDown("left") then
    rt.x = rt.y - 1
  elseif love.keyboard.isDown("right") then
    rt.x = rt.x + 1
  end
  return rt
end

function Tile_Layer:draw ()
  local l_C_SIZE = {x=340,y=340}
  local cam_pos = G.camera:get_pos()
  local v_frame = {l,r,t,b}
  local s_buff = 16 -- just a little past the screen edge
  v_frame.l = cam_pos.x - s_buff 
  v_frame.r = cam_pos.x + (C_SIZE.x + s_buff)
  v_frame.t = cam_pos.y - s_buff 
  v_frame.b = cam_pos.y + (C_SIZE.y + s_buff)
  self.tile_batch:clear()
  for y = 1, self.map_size.y do
    for x = 1, self.map_size.x do
      if self.tiles[y][x] ~= nil then
        local tile = self.tiles[y][x]
        if (tile.pos.x > v_frame.l and
            tile.pos.x < v_frame.r and
            tile.pos.y > v_frame.t and
            tile.pos.y < v_frame.b) then
          self.tile_batch:add(tile.quad,tile.pos.x, tile.pos.y)
        end
      end
    end
  end
  self.tile_batch:flush()
  lgd(self.tile_batch)
  
  if G.debug then
    for i=1,#self.solid do
      local o = self.solid[i]
      local x,y,w,h, vel
      x = o.pos.x
      y = o.pos.y
      w = o.size.x
      h = o.size.y
      lgsc(255,0, 0,255)
      lgr("line", x, y, w, h)
      lgsc(255, 255, 255,255)
    end
  end
end

function Tile_Layer:add_tiles (map,layer)
  local ts_data = map.tilesets[1]
  local image_width = ts_data.imagewidth
  local image_height = ts_data.imageheight
  local tile_width = ts_data.tilewidth
  local tile_height = ts_data.tileheight
  local data = map.layers[layer].data
  local prop = map.layers[layer].properties
  local layer_name = map.layers[layer].name
  local index = 1

  local function make_tile(x,y,w,h,quad)
    local t = {} -- mabey make it a rect
    t.pos = {x=x,y=y}
    t.size = {x=w,y=h}
    t.quad = quad
    return t
  end

  for y = 1, map.height do
    for x = 1, map.width do
      if data[index] ~= 0 then
        local q = self.tile_quads[data[index]]
        local xpos = (x-1) * tile_width
        local ypos = (y-1) * tile_height
        if layer_name =='solid' then
          local obj = G.resource_manager:get_new_tile(xpos, ypos, tile_width, tile_height, q)
          if G.show_solid_tiles then self.tiles[y][x] = obj end
          self.parent.world:add(obj, obj.pos.x, obj.pos.y, obj.size.x, obj.size.y)
          table.insert(self.solid,obj)
        elseif layer_name =='owp' then
          local obj = G.resource_manager:get_new_object("ent_oneway_platform",xpos, ypos, 8, 4, q)
          if G.show_solid_tiles then self.tiles[y][x] = obj end
          self.parent.world:add(obj, obj.pos.x, obj.pos.y, obj.size.x, obj.size.y)
          table.insert(self.solid,obj)
        else
          self.tiles[y][x] = make_tile(xpos, ypos, tile_width, tile_height, q)
        end
      end
      index = index + 1
    end
  end
end



return Tile_Layer
