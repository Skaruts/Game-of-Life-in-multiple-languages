# Game of Life in Multiple Languages
I always make a Game of Life when learning a new language or framework, and since over the years I've jumped around between quite a few of them, eventually I ended up with a bunch of Games of Life made in a variety of languages and frameworks. Ultimately, it has also given me a first hand perspective of the difference in performance between the languages/frameworks.

I'm gathering them in this repo just for the heck of it, as I clean them up in my spare time. 

---

Most of the implementations are just a bare bones GoL with the simplest algorithm. A notable exception is the TIC-80 version (Lua), which was made to be more of a game/toy where you can play with some drawing tools and whatnot.

All (or most) of them have a scalar variable `m` that can be given the values `1`, `2`, `4`, `8` or `16`, to make the cells bigger/smaller, respectively: `m=1` makes cells of `16x16` pixels and an `80x50` grid, and `m=16` makes cells of `1` pixel in a `1280x800` grid.

###### (Note: if the above isn't true in some particular case, there will probably be a comment next to it explaining how exactly the variable works.)

All of them use the same generation algorithm(s), which is the fastest among the simplest I could come up with so far. They were writen as learning excercises, so I didn't bother with more. Although the simplest algorithm isn't all that bad anyway. I'm not unhappy with it. Maybe one day I'll manage to wrap my head around more complicated algorithms, but that day hasn't come yet.

