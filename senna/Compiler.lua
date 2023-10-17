local pt = require("pt").pt -- small lib to pretty-print tables
local Parser = require"senna.Parser"
local Codegen = require"senna.Lua"
local Compiler = {}

function Compiler.compile(source)
   local ast = Parser.parse(source)
    print(pt(ast))
    -- so here, after ast is generated, we pass it to the 
    -- codegen to generate lua code

    local lua = require"senna.Lua"
    local code = lua.generate(ast)
    print(code)
    local fn = load('return ' .. code)
    if fn then print(fn()) end
end
return Compiler