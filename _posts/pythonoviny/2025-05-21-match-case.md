---
layout: post
title: "Python Tutorial: Match Case"
---

The `match-case` syntax is a pretty new addition to Python, introduced in version [3.10][1] by [PEP 634][2] mere 4 years ago, while other languages have had it since the dawn of time. What took Python so long? 

The delay wasn’t due to oversight but rather a deliberate choice rooted in Python's design philosophy. Python values readability over syntax variety, with past proposals rejected [[3]] [[4]] because they didn’t offer compelling advantages over idiomatic Python patterns.

So what was special about the accepted proposal that got us the current incarnation of `match-case`? It is much more than a classical literal-only switch, it also does
- matching on types and structures
- destructuring objects
- conditional guarding

Let's start off with something simple, perhaps the most frequent usecase - replacing a series of `if-elif-else` statements
```python
number = int(input("Enter a number: "))

if number == 1:
    print("One")
elif number == 2:
    print("Two")
else:
    print("Something else:", number)

match number:
    case 1:
        print("One")
    case 2:
        print("Two")
    case n:
        print("Something else:", n)
```
The two approaches are functionally identical. At the cost of one extra indentation level we gained some readability, ease of refactoring and potentially a more error-proof piece of code since the `n` variable for the "else" case of the match statement is a distinct instance from the original `number` variable, so modifying `n` will not change `number`. This is a win in my opinion, it does not duplicate the variable name and shows the intent clearly.

Python’s `match-case` shines when working with structured data—especially tuples, lists, or custom objects.

```python
point = (3, 4)

match point:
    case (0, 0):
        print("Origin")
    case (0, y):
        print(f"Y axis at {y}")
    case (x, 0):
        print(f"X axis at {x}")
    case (x, y) if x == y:
        print(f"Diagonal: ({x}, {y})")
    case (x, y):
        print(f"Point at ({x}, {y})")
```
- `(x, y)` extracts values into variables.
- `if x == y` is a guard condition.

This kind of destructuring used to be verbose and brittle with `if-else`, involving `len()` checks and `try/except` blocks.

Now let’s push things further with a real-world example using [Pydantic](https://docs.pydantic.dev/), a popular data validation library in Python. Assume we’re writing a request handler that accepts multiple request types—say, `CreateUser`, `DeleteUser`, and `UpdateUser`.

```python
from pydantic import BaseModel

class CreateUser(BaseModel):
    username: str
    email: str

class DeleteUser(BaseModel):
    user_id: int

class UpdateUser(BaseModel):
    user_id: int
    email: str | None = None
    username: str | None = None
```

Now let’s use `match-case` to branch based on the type and content of the model:

```python
def handle_request(request: BaseModel):
    match request:
        case CreateUser(username=name, email=email):
            print(f"Creating user {name} with email {email}")
        case DeleteUser(user_id=uid):
            print(f"Deleting user with ID {uid}")
        case UpdateUser(user_id=uid, email=email, username=name) if email or name:
            print(f"Updating user {uid} with changes: email={email}, username={name}")
        case UpdateUser():
            print("No changes provided.")
        case _:
            print("Unsupported request")
```

Notice the subtlety here, especially the two cases of `UpdateUser` and how the user id is omited in the "no changes" case. Of course all this can be done without `match`

```python
def handle_request_legacy(request: BaseModel):
    if isinstance(request, CreateUser):
        print(f"Creating user {request.username} with email {request.email}")
    elif isinstance(request, DeleteUser):
        print(f"Deleting user with ID {request.user_id}")
    elif isinstance(request, UpdateUser):
        if request.email or request.username:
            print(f"Updating user {request.user_id} with changes: email={request.email}, username={request.username}")
        else:
            print("No changes provided.")
    else:
        print("Unsupported request")
```
but I find the match-case version describes the intent better - and we've only scratched the surface of what is possible [[5]]. I do not want to include any made-up and too convoluted examples - for me match-case really solved the ergonomics of handling tuples or lists of varing lengths and encoding rules that triger based on the contents of these objects. I came acros these applications when writing small custom data parsers; here we can demonstrate the usefulness implementing a crude url path router.
```python
def handle_path(path: str):
    match path.strip("/").split("/"):
        case []:
            print("Homepage")
        case ["about"]:
            print("About Page")
        case ["blog", post] if post.isdigit():
            print(f"Viewing Blog Post #{post}")
        case ["user", username, "settings"]:
            print(f"Settings page for user: {username}")
        case ["user", username]:
            print(f"Profile page for user: {username}")
        case [('video'|'photo'), *parts]:
            print(f'Media path: {parts}')
        case _:
            print("404 Not Found")

# Example usage
handle_path("/about")                   # About Page
handle_path("/blog/123")                # Viewing Blog Post #123
handle_path("/user/johndoe/settings")   # Settings page for user: johndoe
handle_path("/photo/vacation/2025")     # Media path: ['vacation', '2025']
```
This really sets apart `match-case` and `if-else` approaches, where in the latter case you'd have to write a lot more code to achieve the same thing. I also like how this uses the well-established unpacking pattern for sequences.

If you want to find out more about this feature, checkout the [official tutorial][5]. I also found [Ben Hoyt's article][6] insightful as he took the time to analyze existing code-bases for potential use-cases of this new feature and explored whether they would be a good fit for refactoring, while being more critical of its introduction.


[1]: https://docs.python.org/3/whatsnew/3.10.html
[2]: https://peps.python.org/pep-0634/
[3]: https://peps.python.org/pep-3103/
[4]: https://peps.python.org/pep-0275/
[5]: https://peps.python.org/pep-0636/
[6]: https://benhoyt.com/writings/python-pattern-matching/