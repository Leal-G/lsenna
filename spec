Build the Senna programming language from scratch.


Senna is a programming language named in honor of the legendary Formula 1 driver, Ayrton Senna. 
Just like Senna's racing prowess, this language is designed to provide speed, precision, and efficiency in software development. 
It is tailored to seamlessly run on the renowned Lua/Luajit virtual machines, emphasizing high-performance computing and rapid application deployment.


Phase I -> PROTOTYPE

the prototype will be coded in Lua, to try and feel the language.
For NOW, we are not worried with performance. The prototype will guide us in terms of dev experience.

When we reach the "final" syntax and semantics, we'll rewrite the code in C.

Let's start?

Runner  
Compiler 
    Lexer 
        lex numbers 
        lex operators 
    Parser -> AST
        parse simple expressions
            numbers
            (+-/*)
    Codegen
        generate lua code
    Evaluator
        naive evaluator


Today we did a lot!!
    we parsed operators
    parsed simple arith operations
    transpiled it to lua
    and rAN it

    this is really great!!

that's it for today!!

if you liked the video, please hit like AND subscribe!

for the next video, lets start looking at strings and comments

see you!!

thank you!!

bye!