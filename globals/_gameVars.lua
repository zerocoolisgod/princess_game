
if not G then G = {} end

-- Global Game Vars
G.gametime = 0
G.debug = false
G.show_solid_tiles = false

G.current_map = ""
G.current_stage_number = 0

-- Player Vars
G.player = {}
G.player_position = {x=0,y=0}
G.player_health = 0
G.player_health_max = 3
G.coins = 0

G.boss_health = 0
