if not G then G = {} end

-------------------------------------------------------------------------------
-- Global Player Functions
-------------------------------------------------------------------------------
function G.set_player_map_location()
  -- set the player's position on the Overworld map 

end

function G.get_player_map_location()
  -- get the player's position on the Overworld map 

end


function G.set_player_health(h)
  G.player_health = h
end


function G.get_player_health ()
  return G.player_health
end

function G.player_heal(ammount)
  local max = G.get_player_health_max()
  local health = G.get_player_health()
  local new_health = health + ammount
  if new_health > max then new_health = max end
  G.set_player_health(new_health)
end

function G.player_hurt( ammount )
  local health = G.get_player_health()
  local new_health = health - ammount
  G.set_player_health(new_health)
end

function G.set_player_health_max (h)
  G.player_health_max = h
end


function G.get_player_health_max ()
  return G.player_health_max
end


function G.blow_bubble(shooter, type)
  local b
  
  local x, y = shooter:get_pos()
  x = x + (shooter.size.x*shooter.direction.x)
  
  if type == "normal" then 
    b = G.resource_manager:get_new_object('ent_bubble', x, y)
  elseif type == "fire" then
    b = G.resource_manager:get_new_object('ent_fire_bubble', x, y)
  end
  b:owner_init(shooter, shooter.direction.x, 1)
  G.add_object(b)
  G.resource_manager:play_sound('shoot')
end


function G.remove_bubble()
  -- G.active_bubbles = G.active_bubbles - 1
  -- if G.active_bubbles < 0 then G.active_bubbles = 0 end
end


function G.set_player_spawn(x,y)
  G.spawn = {x=x,y=y}
end
function G.reset_player_spawn ( )
  G.spawn = nil
end

function G.get_player_spawn(x,y)
  if G.spawn then return G.spawn.x,G.spawn.y end
end


function G.track_player(x,y)
  -- This is a fucntion for the player object register its position with
  G.player_position.x=x
  G.player_position.y=y
end

function G.get_player_position()
  -- The x and y returned may not be accurate as it is self reported by
  -- the player object which may have moved inbetween its last update and this
  -- functionas call. Do not use it for mission critical math. used more for 
  -- pointing enimies vagly in the direction of the player.
  return G.player_position.x,G.player_position.y
end