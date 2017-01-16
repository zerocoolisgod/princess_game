-- Class for handleing Images and animations for entitys
local Class = require 'lib.middleclass'

--[[
Localized Framework Calls
--]]
local lg = love.graphics
local lgd = love.graphics.draw
local lgr = love.graphics.rectangle
local lgp = love.graphics.print
local lgsc = love.graphics.setColor
local m_fl = math.floor
local m_abs = math.abs
local key_down = love.keyboard.isDown

local Sprite = Class('Sprite')

function Sprite:initialize (id,img,sw,sh,adj_x,adj_y, margin, buffer)
  self.id = id or 'sprite'
  self.pos = {x=0,y=0}

  self.img = G.resource_manager:get_image(img)


  self.sprite_size = {x=sw,y=sh}
  -- all sprite adjustment is done form the center
  -- of the image
  self:set_sprite_origin (adj_x,adj_y)
  --space around tile in tile sheet
  -- margin:pixels form (0,0) where image starts
  local m = margin or 0
  -- Buffer:space inbetween sprites
  local b = buffer or m*2

  self.img_quads = G.cut_quads(self.img,self.sprite_size, b, m)

  self.animations = {}
  self.playing = nil
  self.next_animation = nil
end



function Sprite:update (dt)

  if self.playing ~= self.next_animation then
    self.playing = self.next_animation
  end

  local p = self.playing
  local delay = 1 / self.animations[p].fps--
  local total_frames = #self.animations[p].frames
  local cf = self.animations[p].current_frame
  self.animations[p].timer = self.animations[p].timer + dt

  if self.animations[p].timer > delay then

    self.animations[p].timer = 0
    cf = cf + 1
    if cf > total_frames then cf = 1 end
    self.animations[p].current_frame = cf
  end
end

function Sprite:draw (sx,sy,x,y,alpha)
  local alpha = alpha or 255
  if not self.playing then
    local msg  = 'Object '..self.id..' has no animation set'
    G.error(msg)
  end
  local animation = self.animations[self.playing]
  if not animation then
    local msg  = 'Object '..self.id..' has no animation '..self.playing
    G.error(msg)
  end

  local frame = animation.current_frame

  local a_frame = animation.frames[frame]

  local i,q,r,ox,oy
  i = self.img
  q = self.img_quads[a_frame]
  r = 0
  ox = self.img_ori.x
  oy = self.img_ori.y
  if q then
    lgsc(255,alpha,alpha,alpha)
    lgd(i,q,x,y,r,sx,sy,ox,oy)
    lgsc(255,255,255,255)
  end
end


function Sprite:set_sprite_origin (x,y)
  -- Centers origin of sprite
  -- If this is not run at least once the sprites origin
  -- will stay top left.
  -- x and y are adjustments for sprites oragin point
  -- 0 for centered, -n to move Left or Up +n to move Right or Down
  local m_adj_x = x or 0
  local m_adj_y = y or 0
  local sprite_width = self.sprite_size.x
  local sprite_height = self.sprite_size.y

  self.img_ori = {x=0,y=0}
  self.img_ori.x = (sprite_width * .5) + m_adj_x
  self.img_ori.y = (sprite_height * .5) + m_adj_y
end

function Sprite:set_animation (animation_id)
  if not self.playing then self.playing = animation_id end
  self.next_animation = animation_id
end

function Sprite:get_current_animation ()
  return self.playing
end

function Sprite:set_frame (frame)
  self.animations[self.playing].current_frame = frame
end

function Sprite:get_frame ()
  return self.animations[self.playing].current_frame
end

function Sprite:add_animation(id,frames,fps)
  self.animations[id] = {
    frames=frames,
    fps=fps,
    current_frame=1,
    timer=0
  }
end


return Sprite
