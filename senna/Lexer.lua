--- defines
local ASCII_0, ASCII_9 = 48, 57
local ASCII_a, ASCII_f, ASCII_z = 97, 102, 122
local ASCII_A, ASCII_Z = 65, 90

local EOF = -1

local symbols = { ['+'] = true, ['-'] = true,
                    ['*'] = true, ['/'] = true,
                    ['%'] = true, ['^'] = true
    	        }

-- Lexer class
local Lexer = {}

function Lexer.new(chunk)
    local self = {}

    self.c = 0
    self.p = 0  -- lookahead_char
    self.byte = 0
    self.token = ''
    self.token_value = ''
    self.lookahead_token = 'TK_eof'
    self.lookahead_token_value = ''
    self.line = 1
    self.pos = 0
    self.pos_in_line = 0
    self.len = string.len(chunk)
    self.buffer = ''

    local function reset_buffer()
        self.buffer = ''
        self.token = ''
        self.token_value = ''
        self.lookahead_token = 'TK_eof'
        self.lookahead_token_value = ''
    end

    -- reads next char
    local function lex_next(steps)
        steps = steps or 1
        if self.pos + steps > self.len then
            self.c = EOF
            self.byte = -1
            return
        end
        self.pos = self.pos + steps
        self.pos_in_line = self.pos_in_line + steps
        self.c = string.sub(chunk, self.pos, self.pos)
        self.p = string.sub(chunk, self.pos + 1, self.pos + 1)
        self.byte = string.byte(self.c)
    end

    local function save(c)
        c = c or self.c
        self.buffer = self.buffer .. c
    end

    -- saves current c and moves to next
    local function save_next()
        save()
        lex_next()
    end

    local function is_digit(b)
        b = b or self.byte
        return b and b >= ASCII_0 and b <= ASCII_9
    end

    local function is_space(c)
        c = c or self.c
        return c == '\t' or c == ' '
    end

    local function is_eof()
        return self.c == EOF
    end

    local function is_eol()
        return self.c == '\n' or self.c == '\r'
    end

    local function inc_line()
        self.line = self.line + 1
        self.pos_in_line = 1
    end

    local function lex_newline()
        local old = self.c;
        lex_next();  -- Skip "\n" or "\r"
        if is_eol() and self.c ~= old then lex_next() end  -- Skip "\n\r" or "\r\n".
        inc_line()
    end

    -- checks for alpha digits and '.' and exponentials
    local function is_digit_ext(b)
        b = b or self.byte
        return b and (is_digit(b) or
            (b >= ASCII_a and b <= ASCII_f) or -- only accepts lower case 'a' to 'f' for hexa
            (self.c == '.' or self.c == '-' or self.c == 'e' or
            self.c == 'X' or self.c == 'x')
        )
    end

    local function lex_number()
        repeat
            save_next()
        until not is_digit_ext()
    end

    -- main lexer loop
    local function lex()
        reset_buffer()
        while true do
            -- lex numbers
            if is_digit() then
                lex_number()
                self.token = 'TK_number'
                self.token_value = tonumber(self.buffer)
                return self.token, self.token_value
            
            elseif is_eol() then
                lex_newline()

            elseif is_space() then
                repeat
                    lex_next()
                until not is_space()

            elseif is_eof() then
                self.token = 'TK_eof'
                return self.token
            else -- every single char token should be treated here
                if symbols[self.c] then
                    self.token = self.c
                    lex_next()
                    return self.token
                else
                    error("Unexpected symbol at line: " .. self.line .. " col: " .. self.pos_in_line)
                end
            end
        end
    end

    -- lexer api
    function self.next()
        if self.lookahead_token == 'TK_eof' then
            lex()
        end
        return self.token, self.token_value
    end

    -- just before return the lexer state, reads the first char
    lex_next()

    return self
end

return Lexer