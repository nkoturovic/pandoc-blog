---
title: Leveling up Rust (WIP)
author: Nebojša Koturović
date: 2023-09-17T15:30:45Z
abstract: |
    Why I think that Rust might be worth learning in 2023
---
# Hello Rust

This article is about the journey of a C++ developer diving into the Rust realm.

## Course of events

My Rust journey began three years ago, and I've now decided it's time to put 
into practice and level up what I've learned about Rust.

### First look

If you're a genuine C++ developer, hearing the word macro would cause strong symptoms of nausea,
and that is exactly how I reacted the first time I saw rust syntax and found out that `prinln!` is a macro.

```Rust
fn main() {
    println!("Hello World!");
}
```

So, even in the most basic examples of a program, macros come into play. As a C++ developer, 
my instinctive reaction was to close the browser tab and move on with my life, Rust sucks!

### Second look

I couldn't pinpoint the exact time when that first rust encounter was, probably because it didn't leave a strong impression.
But I do roughly remember the first time I took a deeper look and realized that Rust was exciting.
It was Spring 2020, during the Covid 19 lockdown. Since then I've been keeping an eye on the Rust community.

Initially, I was amazed with code generation capabilities, but later on I started to appreciate things like linear types, borrow checker and user friendly Rust ecosystem.

Serialization/Deserialization in Rust

```rust
use serde::{Deserialize, Serialize};

#[derive(Serialize, Deserialize, Debug)]
struct Point {
    x: i32,
    y: i32,
}

fn main() {
    // Define an immutable point variable
    let point = Point { x: 1, y: 2 };

    // Convert the point to string and print it
    let serialized = serde_json::to_string(&point).unwrap();
    println!("serialized = {}", serialized);

    // Convert the string back to a Point and debug print it
    let deserialized: Point = serde_json::from_str(&serialized).unwrap();
    println!("deserialized = {:?}", deserialized);
}
```

Output:

```txt
serialized = {"x":1,"y":2}
deserialized = Point { x: 1, y: 2 }
```

I challenge you to write equivalent piece of code in C++.

*Jeff Atwood: “the best code is no code at all.*

In the next few sections, I will try to explain why Rust might be worth learning at the present moment.

# Why Rust?

In my opinion, Rust isn't successful only due to safety, rich features or community. It's due to
to all of that combined, but most importantly because it's becoming widely used, accepted and mature enough.

Don't get me wrong, I think there are few great alternatives, take Go for example.
I think it's a great language, it has amazing tooling, simple to get started and build powerful software.

Serialization/Deserialization in Go

```go
package main

import (
	"encoding/json"
	"fmt"
)

type Point struct {
	X int `json:"x"`
	Y int `json:"y"`
}

func main() {
	point := Point{X: 1, Y: 2}

	// serializes Point to []byte
	serialized, _ := json.Marshal(point)
	fmt.Printf("Serialized = %s\n", string(serialized))

	// new variable to store deserialized data
	var otherPoint Point
	// deserialize from []byte to Point
	_ = json.Unmarshal(serialized, &otherPoint)
	fmt.Printf("Deserialized = %+v\n", otherPoint)
}
```

Output:

```txt
Serialized = {"x":1,"y":2}
Deserialized = {X:1 Y:2}
```

And I would recommend it over Rust in lots of cases, depending on the task of course.
But if we're talking about preference, coming from the C++ background and having my roots in functional programming, Rust is my cup of tea.

## Simple vs feature-rich languages

In last decade, we're withnessing how simpler languages are gaining in popularity.

*No abstraction is better than the bad abstraction*

I totally see benefits of having a simpler language. However, such languages can be a tiny bit more verbose in my opinion.


## Features

### Constant improvements

## Community

**TODO:** Blog post is not yet finished, continue writing it.

As you know, the life of a C++ developer is tough, with lots of sweat and tears from 
compiler messages, bad overload resolutions, and missing `typename` keywords. 

But don't get me wrong, these are the perks of C++ that you can appreciate and relate to.
There are however things that make you look over the fence.


