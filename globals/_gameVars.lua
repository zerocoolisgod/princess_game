
if not G then G = {} end

-- Global Game Vars
G.gametime = 0
G.debug = false
G.show_solid_tiles = false
G.player = {}
G.player_position = {x=0,y=0}
G.player_health = 0
G.player_health_max = 2
G.coins = 0

G.current_map = ""
G.current_stage_number = 0