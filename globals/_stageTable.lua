-- Stage Table
-- change this to a key=value tabel to load stages by name
if not G then G = {} end


G.stage = {
  {name="Stage 1-1 The Plains", file="stage_1_1", type="stage", music="song_00"},
  {name="Stage 1-2 The Plains", file="stage_1_2", type="stage", music="song_00"},
  {name="Stage 1-3 The Plains", file="stage_1_3", type="stage", music="song_00"},
  {name="Stage 1-4 The Plains", file="stage_1_4", type="stage", music="song_00"},
  {name="Stage 1-5 The Plains", file="stage_1_5", type="stage", music="song_00"},
  {name="Stage 2-1 The Woods", file="stage_2_1", type="stage", music="song_00"},
  {name="Stage 3-1 The Caves", file="stage_3_1", type="stage", music="song_00"},
  {name="Stage 4-1 The Tower", file="stage_4_1", type="stage", music="song_00"},
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