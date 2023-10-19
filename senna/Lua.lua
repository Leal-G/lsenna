local Lua = {}
local luacode = ""

local generator = {}

function generator.literal(node)
    return node.value .. ' '
end

function generator.op(op)
    if op == '!=' then
        op = '~='
    elseif op == '!' then
        op = 'not'
    end
    return op .. ' '
end

function generator.unary(node)
    local e = generator.op(node.op) .. ' ' .. generator[node.rhs.tag](node.rhs)
    if node.bracket then
        return '( ' .. e .. ') '
    end
    return e 
end

function generator.binop(node)
    local lhs = generator[node.lhs.tag](node.lhs)
    local op = generator.op(node.op)
    local rhs = generator[node.rhs.tag](node.rhs)
    if node.bracket then
        return '( ' .. lhs .. op .. rhs .. ') '
    end
    return lhs .. op .. rhs
end

function Lua.generate(ast)
    return generator[ast.tag](ast)
end

return Lua