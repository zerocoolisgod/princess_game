-- Stage Table
-- change this to a key=value tabel to load stages by name
-- One Screen = 40 x 22 tiles in Tiled
if not G then G = {} end


G.stage = {
  {name="Act 1 The Plains", file="stage_1_1", type="stage", music="song_00", delay=3},
  {name="Ducks Hate Bubbles.", file="stage_1_2", type="stage", music="song_00", delay=4},
  {name="Try Select (Tab).", file="stage_1_3", type="stage", music="song_00", delay=4},
  {name="", file="stage_1_4", type="stage", music="song_00", delay=.5},
  {name="", file="stage_1_5", type="stage", music="song_00", delay=.5},
  {name="Act 2 The Woods", file="stage_2_1", type="stage", music="song_00", delay=2},
  {name="Act 3 The Caves", file="stage_3_1", type="stage", music="song_00", delay=2},
  {name="Act 4 The Tower", file="stage_4_1", type="stage", music="song_00", delay=2},
}

function G.load_stage_list (l)
  if l == "normal" then 
    G.stage = {
      
      --{name="Arena", file="arena", type="stage", music="song_00"},
    }
  end

  if l =="pp" then 
    local pp_stage = {}
  end
end