local Lexer = require"senna.Lexer"
local ast_builder = require"senna.AstBuilder"
local ls = {}
local Parser = {}

local binops = {
    TK_ge = '>=',
    TK_le = '<=',
    TK_ne = '!=',
    TK_concat = '..',
    TK_eq = '==',
    ['+'] = '+',
    ['-'] = '-',
    ['*'] = '*',
    ['/'] = '/',
    ['%'] = '%',
    ['^'] = '^',
    TK_and = 'and',
    TK_or = 'or'
}

local function is_binop(op)
    op = op or ls.token
    return binops[op]
end

local expr -- forward declaration

local function expect(tk)
    if ls.token == tk then
        ls.next()
    else
        error("Unexpected token at " .. ls.line .. ":" .. ls.pos_in_line)
    end
end

local function bracket(e)
    e.bracket = true
    return e
end

local function literal()
    local node = {}
    if ls.token == 'TK_number' or ls.token == 'TK_true' or ls.token == 'TK_false' then
        node = { tag = 'literal', value = ls.token_value }
    else
        error("Unexpected token") -- later we'll have to add more info, like line and col, etc...
    end
    ls.next()
    return node
end

local function unary()
    if ls.token == '!' -- not
        or ls.token == '-' -- unary minus
        or ls.token == '#'  -- len
        then
            local op = ls.token
            ls.next()
            local rhs = expr()
        return {tag = 'unary', op = op, rhs = rhs }
    end
    return literal()
end

local function primary()
    local e
    if ls.token == '(' then
        ls.next()
        e = bracket(expr())
        expect(')')
    else
        e = unary()
    end
    return e
end

local function pow()
    local lhs = primary()
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

local function binop()
    local lhs = muldivmod()
    local op
    local rhs
    while is_binop() do
        op = binops[ls.token]
        ls.next()
        rhs = expr()
        lhs = { tag = 'binop', lhs = lhs, op = op, rhs = rhs }
    end
    return lhs
end

function expr()
    return binop()
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