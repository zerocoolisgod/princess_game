-- Global
-- Pay attention to the load order

require "lib.game_math"

local GameManager = require "class.game_manager_class"

-- G is the only global value
G = {}

-- Except for Constants, which should never change
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



--TRASH
farts = 'FARTS!'
