if not G then G = {} end

-- Run through this and make most of the vars private.
-- Provide getters and setters for variables that need 
-- to be accessed out side of the modual.
-- Run through the rest of the code and replace all of the
-- direct reffrences to thies vars.

-- Global
--G.bubble_power = 0
G.bubble_power_max = 32
G.sub_power_max = 80
G.bubble_type = "normal"

-- Local
G.bubble_power_recharge_rate = 250
G.bubble_power_recharge_delay = .7
G.bubble_power_timer = 0


G.bubble_power_cost = {
  normal=10,
  fire=5
}

local bubble_power = {
  normal = G.bubble_power_max,
  sub = 0 --G.sub_power_max
}

G.active_subweapon = nil
G.subweapon_bottles = 0



function G.clear_subweapon()
  bubble_power.sub = G.sub_power_max
  G.bubble_type = "normal"
  G.active_subweapon = nil
end

function G.set_subweapon(w)
  G.active_subweapon = w
end

function G.get_subweapon()
  return G.active_subweapon
end

function G.get_bubble_power(type)
  return bubble_power[type]
end

function G.get_bubble_power_max(type)
  return G.sub_power_max
end

function G.add_sub_power(amount)
  local newAmount = bubble_power.sub + amount
  if newAmount > G.sub_power_max then newAmount = G.sub_power_max end
  bubble_power.sub = newAmount
end

function G.change_bubble_type( )
  local subWeapon = G.get_subweapon()
  local nextWeapon = "normal"

  if G.bubble_type == "normal" then 
    if subWeapon then nextWeapon = subWeapon end
  end
  G.bubble_type = nextWeapon
end

function G.bubble_recharging(dt)
  local bp, bpt, bpm, recharge_rate
  G.bubble_power_timer=G.bubble_power_timer-dt

  -- handel bubble recharging
  bp = bubble_power.normal
  bpm = G.bubble_power_max
  bpt = G.bubble_power_timer
  recharge_rate = G.bubble_power_recharge_rate

  if bpt <= 0 then bp = bp + (dt * recharge_rate) end
  if bp > bpm then bp = bpm end

  bubble_power.normal = bp
end

local function add_bubble(shooter, type)
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

function G.add_bubble_power (amount)
  G.bubble_power_max = G.bubble_power_max + amount
end

function G.shoot_bubble(shooter)
  local cost = G.bubble_power_cost[G.bubble_type]
  local powerPool = "sub"
  local type = G.bubble_type 

  if type == "normal" then powerPool = "normal" end

  if bubble_power[powerPool] >= cost then
    add_bubble(shooter, type)
    bubble_power[powerPool] = bubble_power[powerPool] - cost
    if bubble_power[powerPool] < 0 then bubble_power[powerPool] = 0 end
    G.bubble_power_timer = G.bubble_power_recharge_delay
  end
end

