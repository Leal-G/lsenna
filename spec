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
            (+-/*%^)
            brackets
            unary expressions
            comparison expressions
            boolean expressions (and/or)
        parse strings and comments
    Codegen
        generate lua code
    Evaluator
        naive evaluator

GREAT!!!

so...  I think we've covered a lot for today!!

little by little Senna is turning into shape.

Hope will like it!!

feel free to fork the github repo (link in description)

see you soon!!!

thank you!!

bye!