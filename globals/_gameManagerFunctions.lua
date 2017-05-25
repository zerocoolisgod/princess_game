
if not G then G = {} end

function G.change_state(state)
  G.game_manager.next_state = state
end


function G.load_stage_from_cl(map_name)
  local map_i
  for i=1,#G.stage do
    local st_map=G.stage[i]
    if st_map.file == map_name then map_i=i end
  end
  
  if map_i then
    G.load_stage(map_i)
    return true
  else
    print("Map file: "..map_name.." not found.")
  end  
end


function G.load_stage(map_i)
  if map_i then G.current_stage_number = map_i end
  G.current_map = G.stage[G.current_stage_number]
  G.game_manager.states.play_state:load_map(G.current_map.file,G.current_map.type)
  G.change_state("stage_load_state")
  G.coins = 0
end


function G.load_next_stage()
  local csn = G.current_stage_number + 1
  if csn > #G.stage-1 then csn=1 end
  
  G.current_stage_number = csn
  G.reset_player_spawn ( )
  G.load_stage()
end

function G.restart_stage()
  -- respawn player and return to the current
  -- map in the same state
  G.clear_subweapon()
  G.load_stage()
end

function G.coin_collected ()
  G.coins = G.coins+1
end

function G.clear_coins ()
  G.coins = 0
end

function G.get_coins ()
  return G.coins or 0
end

function G.add_object (o)
  G.game_manager.states.play_state:add_object(o)
end

function G.remove_hitbox (o)
  local obj_exists = G.game_manager.states.play_state.world:hasItem(o)
  if obj_exists then
    G.game_manager.states.play_state.world:remove (o)
  end
end

function G.spawn_random_pickup (spawner)
  local obj_typs={"ent_heart","ent_bubble_jar","ent_bubble_jar","ent_bubble_jar","ent_bubble_jar",}
  local d = love.math.random(16)
  print(d)
  if d <= #obj_typs then
    local x,y = spawner:get_true_pos()
    local o = G.resource_manager:get_new_object(obj_typs[d],x,y)
    G.add_object(o)
  end
end

function G.cheats()
  local up = G.inputs.up:pressed()
  local down = G.inputs.down:pressed()
  if up then G.current_stage_number = G.current_stage_number + 1 end
  if down then G.current_stage_number = G.current_stage_number - 1 end
end