-- Global
-- Pay attention to the load order

require "lib.game_math"

local GameManager = require "class.game_manager_class"

-- G is the only global value
G = {}

-- Except for Constans, which should never change
require "globals.CONSTANTS"
require "globals._inputDefaults"
require "globals._gameVars"
require "globals._stageTable"

-- Initialize Global Objects
G.resource_manager = require "singles.resource_manager_object"
G.debug_manager = require "singles.debug_mod"

-- Load Resource Manager
G.resource_manager:load_images('res/img/')
G.resource_manager:load_objects('entities/')
G.resource_manager:load_sounds('res/aud/')

require "globals._cameraSettings"


-- The Game Manager
G.game_manager = GameManager:new()


require "globals._worldFunctions"
require "globals._utilityFunctions"
require "globals._playerFunctions"
require "globals._gameManagerFunctions"
require "globals._bubbleModual"

function G.cl_switch (arg)
  -- Deal with command line switches
  
  local a = arg[2]
  print("cmd arg: "..a)
  print("file arg: "..arg[3])
  
  if a == "-load_map" then
    local map_path = arg[3]
    
    local dir, file = map_path:match'(.*/)(.*)'
    if not file then dir, file = map_path:match'(.*\\)(.*)' end
    local ext = file:find(".tmx")
    local map_name = file:sub(0,ext-1)

    print("loading: "..map_name)
    if G.load_stage_from_cl(map_name) then G.change_state("play_state") end
  end
end

--TRASH
farts = 'FARTS!'
