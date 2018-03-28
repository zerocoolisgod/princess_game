-- Stage Table
-- change this to a key=value tabel to load stages by name
-- One Screen = 40 x 22 tiles in Tiled
if not G then G = {} end

local reg_stages = {
  {name="Act 1 The Plains", file="stage_1", type="stage", music="01", delay=2},
  {name="", file="stage_2", type="stage", music="02", delay=0.5},
  {name="", file="stage_3", type="stage", music="03", delay=0.5},
  {name="", file="stage_4", type="stage", music="04", delay=0.5},

  {name="Act 2 The Forest", file="stage_5", type="stage", music="05", delay=2},
  {name="", file="stage_6", type="stage", music="06", delay=0.5},
  {name="", file="stage_7", type="stage", music="07", delay=0.5},
  {name="", file="stage_8", type="stage", music="08", delay=0.5},

  {name="Act 3 The Caves", file="stage_9", type="stage", music="09", delay=2},
  {name="", file="stage_10", type="stage", music="10", delay=0.5},
  {name="", file="stage_11", type="stage", music="11", delay=0.5},
  {name="", file="stage_12", type="stage", music="12", delay=0.5},

  {name="Act 4 The Tower", file="stage_13", type="stage", music="13", delay=2},
  {name="", file="stage_14", type="stage", music="14", delay=0.5},
  {name="", file="stage_15", type="stage", music="15", delay=0.5},
  {name="", file="stage_16", type="stage", music="16", delay=0.5},

  {name="The Duck Wizard", file="boss_dw", type="stage", music="16", delay=5},
  
  
  {name="DEBUG LEVEL", file="arena", type="stage", music="song_00", delay=.1}
}

G.stage = reg_stages

function G.load_stage_list (l)
  -- This will be an easy normal hard switch
  if l == "normal" then 
    G.stage = {
      
      --{name="Arena", file="arena", type="stage", music="song_00"},
    }
  end

  if l =="pp" then 
    local pp_stage = {}
  end
end
