local Lexer = require"senna.Lexer"
local ast_builder = require"senna.AstBuilder"
local ls = {}
local Parser = {}

local expr -- forward declaration

local function literal()
    local node = {}
    if ls.token == 'TK_number' then
        node = { tag = 'literal', value = ls.token_value }
    else
        error("Unexpected token") -- later we'll have to add more info, like line and col, etc...
    end
    ls.next()
    return node
end

local function pow()
    local lhs = literal()
    local op
    local rhs
    while ls.token == '^' do
        op = ls.token
        ls.next()
        rhs = expr()
        lhs = { tag = 'binop', lhs = lhs, op = op, rhs = rhs }
    end
    return lhs
end


local function muldivmod()
    local lhs = pow()
    local op
    local rhs
    while ls.token == '*' or ls.token == '/' or ls.token == '%' do
        op = ls.token
        ls.next()
        rhs = expr()
        lhs = { tag = 'binop', lhs = lhs, op = op, rhs = rhs }
    end
    return lhs
end

function expr()
    local lhs = muldivmod()
    local op
    local rhs
    while ls.token == '+' or ls.token == '-' do
        op = ls.token
        ls.next()
        rhs = expr()
        lhs = { tag = 'binop', lhs = lhs, op = op, rhs = rhs }
    end
    return lhs
end

function Parser.parse(chunk)
    local ast = {}
    -- create Lexer state
    ls = Lexer.new(chunk)
    ls.next()
    ast = expr()
    return ast
end

return Parser