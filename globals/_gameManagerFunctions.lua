
if not G then G = {} end

function G.change_state(state)
  G.game_manager.next_state = state
end



-------------------------------------------------------------------------------
-- Deal with command line switches
-------------------------------------------------------------------------------
function G.cl_switch (arg)  
  local a = arg[2]
  print("cmd arg: "..a)
  print("file arg: "..arg[3])
  
  if a == "-loadmap" then
    local map_path = arg[3]
    
    local dir, file = map_path:match'(.*/)(.*)'
    if not file then dir, file = map_path:match'(.*\\)(.*)' end
    local ext = file:find(".tmx")
    local map_name = file:sub(0,ext-1)

    print("loading: "..map_name)
    if G.load_stage_from_cl(map_name) then G.change_state("play_state") end
  end
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


-------------------------------------------------------------------------------
-- Map Loading
-------------------------------------------------------------------------------
function G.load_stage(map_i)
  if map_i then G.current_stage_number = map_i end
  G.current_map = G.stage[G.current_stage_number]
  G.game_manager.states.play_state:load_map(G.current_map.file,G.current_map.type)
  G.change_state("stage_load_state")
  G.coins = 0
end


function G.load_next_stage()
  local csn = G.current_stage_number + 1
  if csn > #G.stage-1 then 
    G.current_stage_number = 0
    G.change_state("title_screen_state")
    return
  end
  
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


-------------------------------------------------------------------------------
-- Pickups
-------------------------------------------------------------------------------
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


local function add_random_pickup(bottle, health, subweapon, nothing, x, y)
  -- This is where the actual work gets done.
  -- spawn_enemy_pickup() and spawn_random_pickup() just set up the 
  -- probabilities.

  local obj_table={}
  local function gen_itms(itm,num)
    for i = 1,num do
      table.insert(obj_table,itm)
    end
  end

  gen_itms("ent_bubble_jar", bottle)
  gen_itms("ent_heart", health)
  gen_itms("ent_sub_fire", subweapon)
  gen_itms("ent_sub_boot", subweapon)
  gen_itms("", nothing)

  local roll = love.math.random(#obj_table)
  local obj_type = obj_table[roll]
  
  if obj_type ~= "" then 
    local o = G.resource_manager:get_new_object(obj_type, x, y)
    G.add_object(o)
  end
end


function G.spawn_enemy_pickup (x, y)
  local bottle, health, subweapon, nothing = 10,10,2,0
  local low_health = G.get_player_health() < (G.get_player_health_max() / 2)
  local low_sub_enrg = G.get_bubble_power("sub") < (G.get_bubble_power("sub") / 10)
  local no_sub =  G.get_subweapon() == nil
  
  if low_health then health = 20 end
  if low_sub_enrg then bottle = 30 end
  if no_sub then subweapon = 6 end
  
  nothing = 100 - (bottle+subweapon+health)

  add_random_pickup(bottle, health, subweapon, nothing, x, y)
end


function G.spawn_random_pickup (x, y)
  local bottle, health, subweapon, nothing = 0,10,5,0
  local low_health = G.get_player_health() < (G.get_player_health_max() / 2)
  local low_sub_enrg = G.get_bubble_power("sub") < (G.get_bubble_power("sub") / 10)
  local no_sub =  G.get_subweapon() == "none"
  
    
  if low_health then health = 30 end
  if no_sub then subweapon = 250 end
  
  bottle = 100 - (health + subweapon + nothing)
  if bottle < 0 then bottle = 0 end
  add_random_pickup(bottle, health, subweapon, nothing, x, y)
end


function G.cheats()
  local up = G.inputs.up:pressed()
  local down = G.inputs.down:pressed()
  if up then G.current_stage_number = G.current_stage_number + 1 end
  if down then G.current_stage_number = G.current_stage_number - 1 end
end