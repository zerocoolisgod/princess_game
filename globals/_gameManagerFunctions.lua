
if not G then G = {} end

function G.change_state(state)
  G.game_manager.next_state = state
end

function G.load_stage(map)
  G.current_map = G.stage[G.current_stage_number]
  G.game_manager.states.play_state:load_map(G.current_map.file,G.current_map.type)
  G.change_state("stage_load_state")
  G.coins = 0
end

function G.load_next_stage()
  G.current_stage_number = G.current_stage_number + 1
  if G.current_stage_number <= #G.stage then
    print("we good")
    local map = G.stage[G.current_stage_number]
    G.reset_player_spawn ( )
    G.load_stage(map)
  else
    print("load_first_stage :(")
    print("current_stage_number "..G.current_stage_number .." G.stage len ".. #G.stage)
    G.load_first_stage()
  end
end

function G.load_first_stage()
  G.current_stage_number = 1
  local map = G.stage[G.current_stage_number]
  G.reset_player_spawn ( )
  G.load_stage(map)
end

function G.restart_stage()
  -- respawn player and return to the current
  -- map in the same state
  G.load_stage(G.current_map.file)
end

function G.coin_collected ()
  G.coins = G.coins+1
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

function G.cheats()
  local up = G.inputs.up:pressed()
  local down = G.inputs.down:pressed()
  if up then G.current_stage_number = G.current_stage_number + 1 end
  if down then G.current_stage_number = G.current_stage_number - 1 end
end