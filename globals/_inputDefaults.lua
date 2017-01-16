local Input = require "class.input_class"
local InputDir = require "class.input_dir_class"

-- Inputs
if not G then G = {} end

G.bind_inputs = false
G.inputs = {}
G.inputs.up     = InputDir:new('up','w',2,-1 )
G.inputs.down   = InputDir:new('down','s',2,1)
G.inputs.left   = InputDir:new( 'left','a',1,-1)
G.inputs.right  = InputDir:new('right','d',1,1)
G.inputs.jump   = Input:new('jump', 'k', 2)
G.inputs.act_1  = Input:new('act_1','j', 3)
G.inputs.start  = Input:new('start','space', 10)
G.inputs.select = Input:new('select','tab', 9)

--Non bindable
G.inputs.fullscreen = Input:new('fullscreen','f11')
G.inputs.reboot = Input:new('reboot','f12')