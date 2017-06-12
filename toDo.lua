"sub weapons"
  --"consume fluid"
  --"bubble jars add fluid to sub weapon"
  --"pickup to increass sub fluid max"
  -- "pick up to assign subweapon type"
  -- "active subweapon set to nil on death"
  -- "dragonfly to spawn bottles and what not"
  "more sub weapons"
    --"keep sub through stage transition, lose after death"
    "set sub energy to a sain amount after death, and on initial spawn"
    "boomerang bubble"
    "holy water equivalent"
    --"iron boots (bring back the head boop)"

"Enemies"
  --"bubbled enimies"
    --"drop"
      --"fluid bottle"
      --"health"
      --"nothing"
  "More Enemies"
    "duck that jumps from pitts"
      --"logic"
      "sprite"
    "sign wave flying duck"
      --"logic"
      "sprite"
    "homing flying duck"
      --"logic"
      "sprite"
    
    --MAYBE
    "bombing duck"
      "logic"
      "sprite"
    "shooting duck arching shot"
      "logic"
      "sprite"
    "sliding duck"
      "logic"
      "sprite"

"fix the shit gui to not be so shit"
    "more encapsulation"
    "gfx for diffrent sub weapons"
    --"gfx for bubble power bar"
"Boss fight"
  "sprite"
  "duck wizzard"
    -- "phase one"
      -- "shoots aimed shot"
      -- "teleports form platform to platform"
    "phase tow"
      "shoots aimed shot"
      "teleports form platform to platform"
      "summons run ducks"

"UPDATE MAPS TO NEW SYSTEM"



Act_1 = {
  Title = "The Plains"
  Stage_1 = {
    Tileset = "tilesheet_plains",
    Style = "keyed",
    Enemies = {
      "duck_run", --*
      "duck_fly"  --*
    },
    Hazards = {}
  },

  Stage_2 = {
    Tileset = "tilesheet_plains",
    Style = "keyed",
    Enemies = {
      "duck_run",
      "duck_fly"
    },
    Hazards = {}
  },

  Stage_3 = {
    Tileset = "tilesheet_plains",
    Style = "long",
    Enemies = {
      "duck_run", 
      "duck_fly"
    },
    Hazards = {pits}
  }
}

Act_2 = {
  Title = "The Forest",
  Stage_4 = {
    Tileset = "tilesheet_forest",
    Style = "long",
    Enemies = {
      "duck_run",
      "duck_fly",
      "duck_shoot"  --*
    },
    Hazards = {
      "pits",
      "spikes"
    }
  },

  Stage_5 = {
    Tileset = "tilesheet_forest",
    Style = keyed,
    Enemies = {
      "duck_run",
      "duck_fly",
      "duck_shoot"  --*
    },
    Hazards = {
      "pits",
      "spikes"
    }
  }
}

Act_3 = {
  Title = "The Mountains"
  Stage_6 = {
    Tileset = tilesheet_plains,
    Style = long/tall,
    Enemies = {
      "duck_run",
      "duck_fly",
      "duck_shoot",
      "duck_hop"    --*
    },
    Hazards = {}
  },

  Stage_7 = {
    Tileset = tilesheet_plains,
    Style = keyed large,
    Enemies = {
      "duck_run",
      "duck_fly",
      "duck_shoot",
      "duck_hop"    --*
    },
    Hazards = {}
  }
}

Act_4 = {
  Title = "The Caves"
  Stage_8 = {
    Tileset = tilesheet_plains,
    Style = keyed,
    Enemies = {
      "duck_run",
      "duck_fly",
      "duck_shoot",
      "duck_hop",
      "duck_homing"
    },
    Hazards = {}
  },

  Stage_9 = {
    Tileset = tilesheet_plains,
    Style = keyed,
    Enemies = {
      "duck_run",
      "duck_fly",
      "duck_shoot",
      "duck_hop",
      "duck_homing"
    },
    Hazards = {}
  }
}

Act_5 = {
  Title = "The Ocean"
  Stage_10 = {
    Tileset = tilesheet_plains,
    Style = keyed,
    Enemies = {
      "duck_run",
      "duck_fly",
      "duck_shoot",
      "duck_sine_wave", --*
      "duck_pit"        --*
    },
    Hazards = {}
  },

  Stage_11 = {
    Tileset = tilesheet_plains,
    Style = keyed,
    Enemies = {
      "duck_run",
      "duck_fly",
      "duck_shoot",
      "duck_sine_wave", --*
      "duck_pit"        --*
    },
    Hazards = {}
  }
}

Act_6 = {
  Title = "The Tower"
  Stage_12 = {
    Tileset = tilesheet_plains,
    Style = keyed,
    Enemies = {
      "duck_run",
      "duck_fly",
      "duck_shoot",
      "duck_hop",
      "duck_sine_wave",
      "duck_homing",
      "duck_pit"
    },
    Hazards = {}
  },

  Stage_13 = {
    Tileset = tilesheet_plains,
    Style = keyed,
    Enemies = {
      "duck_run",
      "duck_fly",
      "duck_shoot",
      "duck_hop",
      "duck_sine_wave",
      "duck_homing",
      "duck_pit"
    },
    Hazards = {}
  },
  Stage_14 = {
    Tileset = tilesheet_plains,
    Style = keyed,
    Enemies = {
      "duck_run",
      "duck_fly",
      "duck_shoot",
      "duck_hop",
      "duck_sine_wave",
      "duck_homing",
      "duck_pit"
    },
    Hazards = {}
  },

  Stage_15 = {
    Tileset = tilesheet_plains,
    Style = keyed,
    Enemies = {
      "duck_run",
      "duck_fly",
      "duck_shoot",
      "duck_hop",
      "duck_sine_wave",
      "duck_homing",
      "duck_pit"
    },
    Hazards = {}
  }
}
