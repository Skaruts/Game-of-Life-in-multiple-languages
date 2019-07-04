# Game-of-Life-in-Multiple-Languages
I always make a Game of Life when learning a new language or framework, and since over the years I've jumped around between quite a few of them, eventually I ended up with a bunch of Games of Life made in a variety of languages and frameworks. Ultilmately it has also given me a first hand perspective of the difference in performance between languages.

I'm gathering them in this repo, as I clean them up in my spare time. 

---

The [C++](./C++)/[Nim](./Nim)/[PySFML](./Python/PySFML) versions are just a bare bones GoL. 

The [TIC-80](./Lua/TIC-80) (lua) version is a quite intricate one. 

The [LOVE2D](./Lua/LÖVE2D/) version is bare bones, but I could swear I had one with some of the same fun stuff from the TIC-80 version. Will add it here if I can dig it up.

---

All of them use the same generation algorithm, which is the fastest I could come up with so far. Maybe one day I'll manage to wrap my head around [Tony Finch's algorithms](https://dotat.at/prog/life/life.html) or even hashlife, but for now this is the best I got. And I'm not unhappy with its performance. 

All versions have a scalar variable `m` that can be given the values `1`, `2`, `4`, `8` or `16`, to make the cells bigger/smaller, respectively: `m=1` makes cells of 16x16 pixels in a 80x50 grid, and `m=16` makes cells of 1 pixel in a 1280x800 grid.

Cpp/Nim versions give me ~20fps with `1px` cells, and ~60-70fps with `2px` cells. They run like wild with larger cells.

LOVE2D gives me ~40fps with `4px` cells.

PySFML gives me ~60-70 with... `16px` cells... (Pretty bad. Either I did something wrong or...)

TIC-80 can't have a very large grid (240x136) and is by design slower, and gives me ~20fps with `1px` cells (in this case the largest cells are `8px`, so the scalar `m` only goes up to `8` for `1px` cells).
