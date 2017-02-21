local Class = require 'lib.middleclass'

-- Object manager
-- designed to function as a layer
-- will build objects when suplied with an object layer from Tiled
-- requires resource manager to function

--[[
Localized Framework Calls
--]]
local lg    = love.graphics
local lgd   = love.graphics.draw
local lgp   = love.graphics.print
local lgsc  = love.graphics.setColor
local t_insert = table.insert
local t_remove = table.remove

local Object_Layer = Class('Object Layer')

function Object_Layer:initialize(parent)

  self.id = "Object Layer"
  self.parent = parent
  self.objects = {}
end

function Object_Layer:load(objects)
  for o = 1, #objects do
    local map_obj = objects[o]

    -- Tiled is wierd and sets objects oragin to bottom left
    local x,y = map_obj.x, map_obj.y - map_obj.height
    local w,h = map_obj.width, map_obj.height
    local obj = G.resource_manager:get_new_object(map_obj.name,x,y,w,h)
    if not obj then G.error(map_obj.name.." is not a valid Entity type.") end
    if obj.load then obj:load() end
    if obj.camera_focus then G.set_camera_focus(obj) end
    -- This is where the spawn point shit should happen!!
    -- Put it here and deleat ot from everywhere else!!
    if obj.id=='player' then
      local sx,sy = G.get_player_spawn()
      if sx and sy then
        obj:set_true_pos(sx,sy)
      end
      G.player = obj
    end
    t_insert(self.objects, obj)
    if obj.solid and self.parent then
      self.parent.world:add(obj, obj.pos.x, obj.pos.y, obj.size.x, obj.size.y)
    end
  end
end


function Object_Layer:update(dt)
  local ob_list = self.objects

  ---
  -- Check for object removal
  for i = #ob_list,1,-1 do
    local o = ob_list[i]
    if o.remove then
      local obj_exists = self.parent.world:hasItem(o)
      if obj_exists then
        self.parent.world:remove(o)
      end
      t_remove(self.objects,i)
    end
  end
  -- iterate backwards to ensure every eliment is updated
  -- after an object is removed
  for i = #ob_list,1,-1 do
    local o = ob_list[i]
    local on_scrn = o:is_on_screen()
    if on_scrn and not o.remove then
      o:update(dt)
      local goal = o.pos
      local obj_exists = self.parent.world:hasItem(o)

      if obj_exists then
        local act_x, act_y, cols, len =
          self.parent.world:move(o, goal.x, goal.y, o.col_filter)
        if len > 0 then
          o:set_true_pos(act_x, act_y)
          o:on_collision(cols, len, dt)
        end
      end
    elseif not on_scrn then
      -- Do not engage collision system when off screen
      -- Do not move objects in off_screen_update()
      o:off_screen_update(dt)
    end
  end
end


function Object_Layer:draw()
  local ob_list = self.objects

  for i = 1, #ob_list do
    local o = ob_list[i]
    o:draw()
  end
end

function Object_Layer:add(obj)
  table.insert(self.objects, obj)
  if obj.solid and self.parent then
    self.parent.world:add(obj, obj.pos.x, obj.pos.y, obj.size.x, obj.size.y)
  end
end

function Object_Layer:rem()end
function Object_Layer:clear()end


return Object_Layer
