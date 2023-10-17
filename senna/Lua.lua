local Lua = {}
local luacode = ""

local generator = {}

function generator.literal(node)
    return node.value .. ' '
end

function generator.binop(node)
    local lhs = generator[node.lhs.tag](node.lhs)
    local op = node.op .. ' '
    local rhs = generator[node.rhs.tag](node.rhs)
    return lhs .. op .. rhs
end

function Lua.generate(ast)
    return generator[ast.tag](ast)
end

return Lua