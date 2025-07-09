---
layout: post
title: "Python's Compiler: Source Code Parser"
---

Welcome to the second article in our [5-part series about the CPython compiler](/pythonoviny/2025/compiler-tokenizer)! As you recall, Python source code is first tokenized a then these tokens are parsed:

> 2. The tokens are parsed into an Abstract Syntax Tree (a tree-like representation of the syntactic structure of source code - much easier for machines to understand than written text - it captures the structure, not the meaning)

Historically, Python (like many languages) used an LL(1) parser—in Python’s case, it was a hand-written recursive descent parser that could only look one token ahead. The LL(1) approach has some limitations:

- Limited Grammar: Only certain grammar structures are supported; [left recursion](https://peps.python.org/pep-0617/#lack-of-left-recursion) and [whitespace-sensitive constructs are tricky](https://github.com/python/cpython/issues/56991).
- Ambiguity: Some new features were very hard to add to the language (e.g., the ["match/case" syntax](/pythonoviny/2025/match-case)).
- Hard to Evolve: As the language grows, supporting new syntax becomes difficult [without major rework](https://peps.python.org/pep-0617/#complicated-ast-parsing).

To solve this, Python switched to a PEG parser ("Parsing Expression Grammar"), as specified in PEP 617 [[1]], starting with Python 3.9.

## What’s a PEG Parser?

PEG parsers are like eager, methodical readers. Instead of looking just a token or two ahead and consulting a rigid table like LL(1), a PEG parser tries each possible rule in the order they’re written until one fits. It follows these principles:

- Ordered choices: if the first alternative works, the parser doesn’t try the others—even if a better fit appears later.
- No Ambiguity: PEG grammars never have multiple valid parse trees for the same input—it’s always one (or none), so the parser always knows what your code means [[2]].
- Infinite Lookahead: PEG parsers can look arbitrarily far ahead in the token stream when matching choices (and backtrack if they cannot proceed further). To keep this efficient, Python's implementation uses ["packrat parsing"](https://en.wikipedia.org/wiki/Packrat_parser) with [memoization](https://en.wikipedia.org/wiki/Memoization) (caching results for positions in the source code).

## Practical Example

What's great about the parser is that we can actually play around with it directly in Python thanks to the built-in `ast` module [[3]].

To start off, we can try to parse a very simple statement: `x = 1`

```python
print(ast.dump(ast.parse("x = 1"), indent=4))
```

which outputs

```
Module(
    body=[
        Assign(
            targets=[
                Name(id='x', ctx=Store())],
            value=Constant(value=1))],
    type_ignores=[])
```

which clearly captures our intent of assigning a constant to a variable in a machine-readable structure. We can also peek into how Python organizes source-code in general - as you can see even our primitive statement is wrapped in the `Module` node with a body.

Since this is the parser, it is also the place where the pesky `SyntaxError`s come from:

```python
print(ast.dump(ast.parse("def foo()"), indent=4))
# SyntaxError: expected ':'
```

## The Grammar Definition

You can view the full grammar definition on [GitHub](https://github.com/python/cpython/blob/main/Grammar/python.gram). It consists of many rules that define the syntax of the entire Python language. The actual parser implementation (C code) is generated from this file by a program called [pegen](https://github.com/python/cpython/tree/main/Tools/peg_generator/pegen).

The grammar (including inline comments) totals around 1500 lines, because even something as "simple" as function arguments can take on many different forms. The following excerp from the grammar includes the rules for *one* paramater of a function:

```
# One parameter.  This *includes* a following comma and type comment.
#
# There are three styles:
# - No default
# - With default
# - Maybe with default
#
# There are two alternative forms of each, to deal with type comments:
# - Ends in a comma followed by an optional type comment
# - No comma, optional type comment, must be followed by close paren
# The latter form is for a final parameter without trailing comma.
#

param_no_default[arg_ty]:
    | a=param ',' tc=TYPE_COMMENT? { _PyPegen_add_type_comment_to_arg(p, a, tc) }
    | a=param tc=TYPE_COMMENT? &')' { _PyPegen_add_type_comment_to_arg(p, a, tc) }
param_no_default_star_annotation[arg_ty]:
    | a=param_star_annotation ',' tc=TYPE_COMMENT? { _PyPegen_add_type_comment_to_arg(p, a, tc) }
    | a=param_star_annotation tc=TYPE_COMMENT? &')' { _PyPegen_add_type_comment_to_arg(p, a, tc) }
param_with_default[NameDefaultPair*]:
    | a=param c=default ',' tc=TYPE_COMMENT? { _PyPegen_name_default_pair(p, a, c, tc) }
    | a=param c=default tc=TYPE_COMMENT? &')' { _PyPegen_name_default_pair(p, a, c, tc) }
param_maybe_default[NameDefaultPair*]:
    | a=param c=default? ',' tc=TYPE_COMMENT? { _PyPegen_name_default_pair(p, a, c, tc) }
    | a=param c=default? tc=TYPE_COMMENT? &')' { _PyPegen_name_default_pair(p, a, c, tc) }
param[arg_ty]: a=NAME b=annotation? { _PyAST_arg(a->v.Name.id, b, NULL, EXTRA) }
param_star_annotation[arg_ty]: a=NAME b=star_annotation { _PyAST_arg(a->v.Name.id, b, NULL, EXTRA) }
annotation[expr_ty]: ':' a=expression { a }
star_annotation[expr_ty]: ':' a=star_expression { a }
default[expr_ty]: '=' a=expression { a } | invalid_default
```

Here we can also see why the "ordered choices" principle matters so much - each parameter style includes two forms
1. `param,` (is followed by another parameter or is the last one - Python supports trailing commas)
2. `param` (is the last one - this case is more generic than the first one)

The form with the comma is tried first. If you swapped these two rules, a parameter followed by a comma could never appear, because the more general “no comma” rule would match first and swallow everything, producing confusing errors down the line.

## Closing thoughts

PEG parsing is not always the fastest, and the introduction of memoization makes it use more memory to guarantee performance doesn’t blow up for ambiguous-looking code. But for Python, the trade-off is worth it: maintainers and contributors get a more flexible and powerful way to express the grammar, and users get new features and clearer syntax errors.


[1]: https://peps.python.org/pep-0617
[2]: https://github.com/python/cpython/blob/main/InternalDocs/parser.md
[3]: https://docs.python.org/3/library/ast.html
