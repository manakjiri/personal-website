---
layout: post
title: "Python Tutorial: Context Managers"
---

In keeping with the theme from the last article, let's focus on another Python language feature which is arguably even more useful for writing correct code.

Python's context managers, introduced through the `with` statement, are often showcased with file operations but their capabilities reach far deeper. Under the hood, a context manager is any object implementing the `__enter__` and `__exit__` methods (`__aenter__` and `__aexit__` for [async-await](/pythonoviny/2025/async) variants). This design abstracts resource management, enabling predictable control over setup and teardown logic without relying on the [garbage collector](/pythonoviny/2025/memory-management) for cleanup.

```python
with open("example.txt") as f:
    data = f.read()
```

[Under the hood](https://github.com/python/cpython/blob/f00512db20561370faad437853f6ecee0eec4856/Lib/_pyio.py#L232-L271) basically is:

```python
f = open("example.txt")
try:
    data = f.read()
finally:
    f.close()
```

This pattern generalizes to any resource - database connections, locks, temporary environments, even mocking in tests.

The simplest way to write a context manager, one that I use most often, is facilitated by [`contextlib`](https://docs.python.org/3/library/contextlib.html). 

```python
import os
from contextlib import contextmanager

@contextmanager
def temporary_env(var: str, value: str):
    old = os.environ.get(var)
    os.environ[var] = value
    try:
        yield
    finally:
        if old is None:
            del os.environ[var]
        else:
            os.environ[var] = old
```

This one simple decorator (`asynccontextmanager` for async contexts) transforms any function into a context manager. All it needs to do is to use the `try-except-finally` statement internally and yield something - this becomes the lifetime of the context.

For more complicated stuff (especially if you need state), you can define the previously mentioned methods in a class:

```python
import time

class Timer:
    def __enter__(self):
        self.start = time.perf_counter()
        return self

    def __exit__(self, exc_type, exc_value, traceback):
        self.end = time.perf_counter()
        self.interval = self.end - self.start
        print(f"Took {self.interval:.3f}s")
```

which can be used directly like so

```python
with Timer():
    print("This is a timed block of code.")
```

or you can define a function which returns such context manager (resembling the built-in `open()` function)

```python
def time_this():
    return Timer()

with time_this() as timer:
    print(f"Timer started at: {timer.start:.3f}s")
    print("This is a timed block of code.")
```

You can also enter multiple context managers using a single `with` statement, which is expecially useful when using [`patch()` from the mocking module](https://docs.python.org/3/library/unittest.mock.html#patch). 

```python
with time_this() as timer1, time_this() as timer2:
    pass
```

Context managers encapsulate temporal concerns - what must happen before and after an action. They're foundational to Pythonic design, providing clarity, composability, and safety. 

I also like how explicitly they communicate the scope of a resources's lifetime. Context managers can be used to help with otherwise fuzzy scoping rules and bring Python closer to static languages with explicit destructors, when it comes to object lifetimes.
