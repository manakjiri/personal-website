---
layout: post
title: Decorators in Python
---

Let's switch gears a bit. One of the readers asked me if I could cover decorators and explain how they work. Decorators were introduced two decades ago in [PEP318](https://peps.python.org/pep-0318) and I think everybody writing Python code is accustomed to using them, but are you comfortable writing your own? Let's dive in.
 
> Python decorators allow you to modify or extend the behavior of functions and methods without changing their actual code.
[realpython](https://realpython.com/primer-on-python-decorators/)

So what happens when you apply a decorator to a function?
- the `decorator` is just yet another function, which receives the `some_function` as an argument and is free to do whatever with it
- when you call a decorated function, you no longer call it directly, you call its decorated version
- the confusing part: in order to achieve this, the decorator actually returns a completely different function, which is in fact called instead of the original one.

```python
@decorator
def some_function(args):
    ...
```

And so what happens when you call a decorated function?
- the decorator(s) are evaluated† and as we just learned, they simply return some function
- this returned function is executed with provided arguments

In code, this may look something like
```python
decorated_some_function = decorator(some_function)
our_return_value = decorated_some_function(our_args)
```
We can say that decorators are basically just syntactic sugar, which hides this code behind the `@` character.

Most articles start with showing you how to implement a decorator and I think that's the most confusing part. I tried to give you the primer in plain english, but now let's put this into practice.

```python
def passthrough(func):
    def inner(*args, **kwargs):
        return func(*args, **kwargs)
    return inner
```
This is the simplest decorator you can come up with - as the name suggests, it does nothing. It simply calls the decorated function with the provided arguments and returns its result. Let's break-down what is happening here
- the outer function (named `passthrough`) serves as a vessel for your decorator implementation, its only job is to receive the decorated function and return the inner one, which usually does all the magic
- the inner function is actually responsible for executing the provided function. You could log the arguments and the return value, you could do some generic error handling, or implement retry logic - that is the beauty (and perhaps also the curse) of decorators, they give you full control

```python
@passthrough
def test(number):
    return f"I got {number}"

print(test(42)) # prints "I got 42"
```

There is one problem however - even in this very simple example. Today's Python developer experience is powered by type hints, but even this decorator with its completely generic definition inadvertently swallows any information about the wrapped function. Your IDE does not know which arguments your functions take and what they return - a huge pain.

Recently (with the help of Martin and Roman) I wrote a decorator, which converts any sync method into an async one. In the process, we came up with type-hints, that fix this and I want to provide you this universal copy-paste-able snippet, which you can use anywhere and bring your type hints back!
```python
import functools
import typing as t

RET = t.TypeVar("RET")
P = t.ParamSpec("P")
SelfType = t.TypeVar("SelfType")

def decorated_method_template(
    func: t.Callable[t.Concatenate[SelfType, P], RET],
) -> t.Callable[t.Concatenate[SelfType, P], RET]:
    """
    This decorator propagates the decorated function's type hints
    """
    @functools.wraps(func)
    def wrapper(self: SelfType, *args: P.args, **kwargs: P.kwargs) -> RET:
        return func(self, *args, **kwargs)

    return wrapper

class TestClass:
    @decorated_method_template
    def test(self, number: int) -> str:
        return f"I got {number}"

print(TestClass().test(42)) # also prints "I got 42"
```
This example works well for methods, but you can easily adapt it to generic functions by removing `SelfType` and `Concatenate`. ![[Screenshot 2025-04-30 at 19.08.08.png]]

†I am simplifying - what actually happens is that when a decorated function is defined, the decorator is applied immediately, replacing the original function with the decorated version. Subsequent calls to the function invoke this new, decorated version.

Note: `ParamSpec` and `Concatenate` were introduced in Python 3.10. If you're using an earlier version of Python or certain type checkers, these features might not be available or fully supported.