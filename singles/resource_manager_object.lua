---
-- Resource Manager
-- Loads everything in a path once
-- to be retrieved with the apropriate rsm:get()
local Class = require 'lib.middleclass'

local rsm = {}

local new_image = love.graphics.newImage
local new_sound = love.audio.newSource
local la = love.audio

rsm.res = {
  img = {},
  aud = {},
  obj = {}
}


function rsm:load_images(path)
  -- takes every image in $path and adds it to
  -- self.img as {str file_name = obj drawable}
  local dir = love.filesystem.getDirectoryItems(path)
  local id,res

  for i,v in ipairs(dir) do
    id = string.sub(dir[i],1,-5)
    res = path..dir[i]
    self:add_img(res,id)
  end
end

function rsm:load_sounds(path)
  local dir = love.filesystem.getDirectoryItems(path)
  local id,res

  for i,v in ipairs(dir) do
    id = string.sub(dir[i],1,-5)
    res = path..dir[i]

    self:add_aud(res,id)
  end
end

function rsm:load_objects(path)
  -- takes every class in $path and adds it to
  -- self.obj as {str file_name = obj class_constructor}
  local dir = love.filesystem.getDirectoryItems(path)
  local id,res

  for i,v in ipairs(dir) do
    if string.sub(dir[i],-4) == '.lua' then
      id = string.sub(dir[i],1,-5)
      res = path..id
      self:add_obj(res,id)
    end
  end
end

function rsm:clear ()
  self.res = {
    img = {},
    aud = {},
    obj = {}
  }
end

function rsm:add_img (resource,id)
  self.res.img[id] = new_image(resource)
end

function rsm:add_aud (resource,id)
  self.res.aud[id] = new_sound(resource)
end

function rsm:add_obj (resource,id)
  self.res.obj[id] = require(resource)
end

function rsm:get_image (id)
  -- takes id (str file_name)
  -- returnes drawable
  if self.res.img[id] then
    return self.res.img[id]
  else
    G.error(id..' is not a valid image sheet.')
  end
end

function rsm:play_sound (id)
  if self.res.aud[id] then
    self.res.aud[id]:stop()
    self.res.aud[id]:play()
  else
    G.error(id..' is not a valid sound file.')
  end
end

function rsm:play_music (id,volume)
  la.stop()
  volume = volume or 1
  if self.res.aud[id] then
    self.res.aud[id]:stop()
    self.res.aud[id]:setVolume(volume)
    self.res.aud[id]:setLooping(true)
    self.res.aud[id]:play()
  else
    G.error(id..' is not a valid song file.')
  end
end

function rsm:get_new_object (id,x,y,h,w)
  -- takes id (str file_name) and position
  -- returnes object at that position
  if self.res.obj[id] then
    return self.res.obj[id]:new(x,y,h,w)
  end
end

function rsm:get_new_tile (x,y,w,h,q)
  -- returnes tile at that position
  return self.res.obj['ent_wall']:new(x,y,w,h,q)
end

return rsm
