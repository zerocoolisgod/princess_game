-- Map Manager
-- the entirety of the play state
local Class = require 'lib.middleclass'
local State = require 'class.game_state_class'
local Gui = require 'class.gui_class'
--[[
Localized Framework Calls
--]]
local lg    = love.graphics
local lgd   = love.graphics.draw
local lgp   = love.graphics.print
local lgsc  = love.graphics.setColor


local Obj_Lay = require "class.object_layer_class"
local Tile_Lay = require "class.tile_layer_class"
local bump = require 'lib.bump'

local mm = Class('play_state',State)

--Constructor
function mm:initialize ()
  State.initialize(self,'play_state')
  self.bgc={200,200,200}
  love.graphics.setBackgroundColor(self.bgc)
end

function mm:load_map (mapname, m_type)
  --print(mapname)
  local map = require("maps/"..mapname)
  local ts_data = map.tilesets[1]
  local tile_seize = {x = ts_data.tilewidth, y = ts_data.tileheight}
  self.bgc=map.backgroundcolor or{255,255,255}
  love.graphics.setBackgroundColor(self.bgc)
  self.layers = {}
  self.world = bump.newWorld(32)
  self:add_owp_response()
  self.gui = nil
  if m_type=="stage" then self.gui = Gui:new() end
  
  G.set_camera_limit(map.width*tile_seize.x, map.height*tile_seize.y)


  -- Make a layer object for every map layer
  for layer = 1,#map.layers do
    if map.layers[layer].type == "tilelayer" then
        local tl = Tile_Lay:new(self)
        tl:load(map, layer)
        table.insert(self.layers, tl)
    end
    if map.layers[layer].type == "objectgroup" then
        local ol = Obj_Lay:new(self)
        local objs = map.layers[layer].objects
        ol:load(objs)
        table.insert(self.layers, ol)
    end
  end
end

function mm:destroy ()
end

function mm:on_enter ()
  love.graphics.setBackgroundColor(self.bgc)
  if G.camera.focus then
    local x,y
    x = G.camera.focus.pos.x
    y = G.camera.focus.pos.y
    G.camera:center_on(x,y,1)
  end
end

function mm:update (dt)
  for l = 1, #self.layers do
    self.layers[l]:update(dt)
  end

  if self.gui then self.gui:update(dt) end
  if G.inputs.start:pressed() then G.change_state('pause_state') end
  G.camera:update(dt)
end


function mm:draw ()
  for l = 1, #self.layers do
    self.layers[l]:draw()
  end
end


function mm:add_object (obj)
  for i = 1, #self.layers do
    local layer = self.layers[i]
    if layer.id == 'Object Layer' then
      layer:add(obj)
    end
  end
end

function mm:add_owp_response()
  local slide, cross = bump.responses.slide, bump.responses.cross

  local onewayplatformSlide = function(world, col, x, y, w, h, goalX, goalY, filter)
  if G.inputs.down:down() and G.inputs.jump:pressed() then
    return cross(world, col, x, y, w, h, goalX, goalY, filter)
  elseif col.normal.y < 0 and not col.overlaps then
    col.didTouch = true
    return slide(world, col, x, y, w, h, goalX, goalY, filter)
  else
    return cross(world, col, x, y, w, h, goalX, goalY, filter)
  end
  end

  self.world:addResponse('onewayplatformSlide', onewayplatformSlide)
end

return mm
