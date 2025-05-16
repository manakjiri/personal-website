---
layout: post
title: Python's Memory Management
---

I hear you say: "Python is a high-level language, we do not need to worry about memory management, it does that for us" - but have you ever wondered how it does that?

## Reference Counting

The main garbage collection algorithm used by CPython is reference counting. The basic idea is that CPython counts how many different places there are that have a reference to an object [[1]]. When an object’s reference count becomes zero, the object is deallocated. Python provides built-in tools for querying the number of references

```python
>>> import sys
>>> x = object()
>>> sys.getrefcount(x)
2
>>> y = x
>>> sys.getrefcount(x)
3
>>> del y
>>> sys.getrefcount(x)
2
```

Reference counting is predictable and relatively easy to implement [[2]]. One of its main disadvantages, which Python also needs to solve, are reference cycles.

```python
>>> container = []
>>> sys.getrefcount(container)
2 # = variable's reference + getrefcount's reference
>>> container.append(container)
>>> sys.getrefcount(container)
3 # = variable's reference + cyclical reference + getrefcount's reference
>>> del container
```

Here the `container` list keeps a reference to itself even after the deletion of the `container` variable, meaning it is still taking up system memory while being useless to us, because we can no longer access it. We can actually observe this using a lower-level access to the same information

```python
>>> import ctypes
>>> container = []
>>> container.append(container)
>>> addr = ctypes.c_long.from_address(id(container))
>>> addr.value
2
>>> del container
>>> addr.value
1
```

For now you will have to trust me on that `addr.value` is the reference counter of the `container` object, we'll see why that is shortly. We can read it because the object still exists in the memory until a garbage collector detects that it is not reachable by any of our code and deallocates it.

You may be saying that this kind of code must be rare, so why even worry about this? Truth is that Python creates many of these cycles by itself - for example exceptions contain traceback objects that contain a list of frames that contain the exception itself.

## Cyclic Garbage Collector

The cyclic garbage collector is the Python's solution to the imperfect reference counting mechanism. When it gets triggered, it scans all objects and removes those that are not reachable by the program. The amazing [1][CPython's Internal Documentation] covers it in much more detail.

The GC runs when a certain number of allocations (object creations) and deallocations (object deletions) occurr. When the GC runs, it causes a *stop the world* event, which **pauses** your program's execution for the duration of the GC scan. Figuring out which objects are inaccesible is actually a pretty complicated process and could take quite a while [[1]]. You can actually know exactly when this happens, because Python allows you to register callbacks through the `gc` module [[3]].

```python
import gc

def gc_callback(phase, info):
    print(f"GC {phase}: {info}")

# register a callback which prints the current status of GC
gc.callbacks.append(gc_callback)

for i in range(5000):
    # create objects that need to be collected by GC
    container = []
    container.append(container)
```
```shell
GC start: {'generation': 0, 'collected': 0, 'uncollectable': 0}
GC stop: {'generation': 0, 'collected': 45, 'uncollectable': 0} 140 us
GC start: {'generation': 0, 'collected': 0, 'uncollectable': 0}
GC stop: {'generation': 0, 'collected': 2046, 'uncollectable': 0} 79 us
GC start: {'generation': 0, 'collected': 0, 'uncollectable': 0}
GC stop: {'generation': 0, 'collected': 2080, 'uncollectable': 0} 80 us
GC start: {'generation': 2, 'collected': 0, 'uncollectable': 0}
GC stop: {'generation': 2, 'collected': 828, 'uncollectable': 0} 247 us
```
*(notice that I added time measurements showing how long it took from start to finish of each GC run. Also notice that the GC seems to run after about 2000 objects are accumulated, which is the default threshold [[3]])*

## How are Python objects represented?

You might be wondering: How does Python keep track of all these objects? How can it reclaim space after all references to an object are lost?

| *_gc_next     | pointer to the next dynamic object |
| *_gc_prev     | pointer to the previous object |
| **ob_refcnt** | reference count integer field (the one that we read directly) |
| ***ob_type**  | pointer to object type, more fields follow after this... |

This is what every dynamic object (mainly lists and dicts) looks like under the hood in Python. The actual object starts with the refcount field, that is why we were able to read it in the example using `ctypes.c_long.from_address` directly by dereferencing the object's address. When the GC starts, it walks this doubly-linked list of `_gc_next` and `_gc_prev` pointers and does its magic.

## Summary

The result is that these two systems work together so that you (mostly) do not need to worry about any of this, but there examples [[4]][[5]] out there of teams needing to tune and optimize the interpreter to support their workloads. I think it is useful to know the GC is there and be aware of its impacts. With [Python 3.13](/pythonoviny/2025/welcome) and its free-threaded mode, there have also been changes made to the way the memory is managed and it will no doubt be an area of further development.


[1]: https://github.com/python/cpython/blob/main/InternalDocs/garbage_collector.md
[2]: https://en.wikipedia.org/wiki/Reference_counting#Advantages_and_disadvantages
[3]: https://docs.python.org/3/library/gc.html
[4]: https://medium.com/%40shivam_99875/unpacking-instagrams-python-garbage-collection-optimization-a-quick-analysis-f2cd1bd794be
[5]: https://github.com/asf-transfer/hamilton/blob/main/writeups/garbage_collection/post.md
