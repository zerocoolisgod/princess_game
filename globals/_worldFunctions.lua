if not G then G = {} end

-------------------------------------------------------------------------------
-- Global functions
-------------------------------------------------------------------------------
function G.world_check_point (x,y,group)
  -- check point for object with same group
  local this_state = G.game_manager.states[G.game_manager.current_state]
  -- make sure current state has a collision world
  local found = false
  if this_state.world then
    local world = this_state.world --.play_state.world
    local items, len = world:queryPoint(x,y)
    for i = 1, len do
      if items[i].group == group then
        found = true
      end
    end 
  end
  return found
end


function G.world_check_area (l,t,w,h,group)
  -- check rectangle for object with same id
  local this_state = G.game_manager.states[G.game_manager.current_state]
  -- make sure current state has a collision world
  local found = false
  if this_state.world then
    local world = this_state.world
    local items, len = world:queryRect(l,t,w,h)
    for i = 1, len do
      if items[i].group == group then
        found = true
      end
    end
  end
  return found
end

function G.get_objects_at_point (x,y)
  -- check point for objects
  local this_state = G.game_manager.states[G.game_manager.current_state]
  -- make sure current state has a collision world
  if this_state.world then
    local world = this_state.world
    local items, len = world:queryPoint(x,y)
     return items
  end
end