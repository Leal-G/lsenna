local function usage()
    print("Usage: lua senna.lua <your_senna_file>")
    os.exit()
end

-- gets all parameters sent from command line
local args = {...}

local filename = args[1]
if not filename then usage() end

local f = io.open(filename)
local source
if f == nil then
    usage()
else
    source = f:read("a")
    f:close()
end

local Compiler = require"senna.Compiler"

Compiler.compile(source)