---
layout: post
title: "Python's Compiler: Source Code Tokenizer"
---

This is the part 1 of a 5 part series about the Python's compiler - the part of [CPython](/pythonoviny/2025/welcome) which takes your scripts and tranforms them into Python bytecode, which is then executed by the interpreter.

If you already feel lost after the first sentence - I got you, but I promise the following article(s) will be full of practical examples of foundational Computer Science concepts, which are worth learning about. I'll provide links to source code and internal documentation along the way and try to explain everything in plain English - let's learn together.

The compilation (the process of translating high-level code into low-level code [[1]]) happens in 5 steps [[2]] (hence 5 articles):

1. The source code is tokenized (much like LLMs first tranform text into fixed-size tokens [[5]], CPython compiler does the same to reduce the comlexity of the next step)
2. The tokens are parsed into an Abstract Syntax Tree (a tree-like representation of the syntactic structure of source code - much easier for machines to understand than written text - it captures the structure, not the meaning)
3. AST is transformed into an instruction sequence (unoptimized intermediate pseudo-bytecode)
4. A Control Flow Graph is constructed from the instruction sequence and optimizations are applied to it (this graph models the flow of the program, each node is a block of code which needs to execute from start to end)
5. Final bytecode is emitted based on pseudo-bytecode created by converting the optimized CFG

Python bytecode is not yet executable by any common CPU, it is a series of instructions that the Python Virtual Machine (the Intepreter) understands. Have you ever wondered what is in those `__pycache__` directories? It is precisely the compiled bytecode representation of your program. This whole compilation step needs to happen just once, unless you make changes to the code.

## Tokenizer

The first step in compiling the source is tokenization. This makes the PEG parser's job (step 2 - next article) easier and helps with some of the nuances of the Python language.

It is common among PEG parser frameworks that the parser does both the parsing and the tokenization, but this does not happen in Pegen. The reason is that the Python language needs a custom tokenizer to handle things like indentation boundaries, some special keywords like `ASYNC` and `AWAIT` (for compatibility purposes), backtracking errors (such as unclosed parenthesis), dealing with encoding, interactive mode and much more. Some of these reasons are also there for historical purposes, and some others are useful even today [[3]].

It is amazing that we can easily take a look at how these tokens are actually constructed [in the code][4]:
```c
int
_PyToken_OneChar(int c1)
{
    switch (c1) {
    case '!': return EXCLAMATION;
    case '%': return PERCENT;
    case '&': return AMPER;
    case '(': return LPAR;
    case ')': return RPAR;
...
```
*a small excerpt from Parser/token.c [[4]] - a function which converts characters into tokens. This file also contains functions for two and three character tokens.*

The tokenized source code then goes into the parser, but that's up for next week's article. The tokenizer is a relatively simple step when compared to all the others, so it made sense to combine it with the introduction to this whole series.

[1]: https://en.wikipedia.org/wiki/Compiler
[2]: https://github.com/python/cpython/blob/main/InternalDocs/compiler.md
[3]: https://github.com/python/cpython/blob/main/InternalDocs/parser.md
[4]: https://github.com/python/cpython/blob/main/Parser/token.c
[5]: https://en.wikipedia.org/wiki/Lexical_analysis
