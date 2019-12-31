#include "raylib.h"

// quick way to modify the size of the cells, grid and window in the same proportion
// use values 1, 2, 4, 8 or 16 (higher means smaller/more cells, and less performance)
#define m 8

#define CS 16/m     // cell size
#define GW 80*m     // grid width
#define GH 50*m     // grid height

Color dead_cell = DARKGRAY;
Color alive_cell = ORANGE;

bool show_fps = true;
bool show_dead_cells = false; // quite taxing on perfomance
bool paused = false;

int prev_buf = 0;    // to alternate between cell buffers
int curr_buf = 1;

// add a padding space around cells (just to look nicer)
int pad;    // top and left padding
int pad2;   // bottom and right padding

int cells[2][GH][GW];
Rectangle quads[GH][GW];
bool running = true;

void randomize_cells() {
    for(int buf_idx = 0; buf_idx < 2; buf_idx++) {
        for(int j = 0; j < GH; j++) {
            for(int i = 0; i < GW; i++) {
                cells[buf_idx][j][i] = GetRandomValue(0, 1);
            }
        }
    }
}
void draw_fps(int posX, int posY, int fontSize, Color color) {
    static int fps = 0, counter = 0, refreshRate = 20;
    if (counter < refreshRate)
        counter++;
    else {
        fps = GetFPS();
        refreshRate = fps;
        counter = 0;
    }
    DrawText(TextFormat("%i FPS", fps), posX, posY, fontSize, color);
}
void init_cells() {
    pad = 1;
    pad2 = pad*2;

    if (m > 4) {    // check if cells aren't too small, or else they become invisible with padding
        pad = 0;
        pad2 = 0;
    }

    randomize_cells();

    for(int j = 0; j < GH; j++) {
        for(int i = 0; i < GW; i++) {
            int x = i*CS+pad;
            int y = j*CS+pad;
            int w = CS-pad2;
            int h = CS-pad2;
            Rectangle rect = { x, y, w, h };
            quads[j][i] = rect;
        }
    }
}
void pass_generation() {
    prev_buf = 1 - prev_buf;      // switch buffers
    curr_buf = 1 - curr_buf;

    for (int j = 0; j < GH; j++) {
        for (int i = 0; i < GW; i++) {
            // wrap around
            int j_ = j-1 >=  0   ?   j-1   :  GH-1;
            int _j = j+1 <  GH   ?   j+1   :     0;
            int i_ = i-1 >=  0   ?   i-1   :  GW-1;
            int _i = i+1 <  GW   ?   i+1   :     0;

            // count alive neighbors
            int n =   cells[prev_buf][ j_    ][ i_    ]
                    + cells[prev_buf][ j_    ][   i   ]
                    + cells[prev_buf][ j_    ][    _i ]
                    + cells[prev_buf][   j   ][ i_    ]
                    + cells[prev_buf][   j   ][    _i ]
                    + cells[prev_buf][    _j ][ i_    ]
                    + cells[prev_buf][    _j ][   i   ]
                    + cells[prev_buf][    _j ][    _i ];

            // set cell according to GoL rules
            cells[curr_buf][j][i] = (int) n == 3 || ( cells[prev_buf][j][i] && n == 2);
        }
    }
}
void handle_input() {
    if (WindowShouldClose() || IsKeyPressed(KEY_Q) || IsKeyPressed(KEY_ESCAPE))
        running = false;
    if (IsKeyPressed(KEY_SPACE))                    paused = !paused;
    if (IsKeyPressed(KEY_ENTER))                    randomize_cells();
    if (IsKeyPressed(KEY_F1))                       show_fps = !show_fps;

    if (paused) {
        if (IsKeyPressed(KEY_G)) pass_generation();
    } else {
        pass_generation();
    }
}
int main() {
    // set window size according to grid and cell sizes
    // (makes a 1280x800 window if only the value of 'm' is tinkered with)
    int screenWidth = GW*CS;
    int screenHeight = GH*CS;

    InitWindow(screenWidth, screenHeight, "Game of Life, by Skaruts (Raylib - C)");
    SetTargetFPS(60);
    running = true;

    init_cells();

    while (running) {
        handle_input();

        BeginDrawing();
        ClearBackground(BLACK);
        for(int j = 0; j < GH; j++) {
            for(int i = 0; i < GW; i++) {
                if (cells[curr_buf][j][i]) DrawRectangleRec(quads[j][i], alive_cell);
                else if (show_dead_cells)  DrawRectangleRec(quads[j][i], dead_cell);
            }
        }
        if (show_fps) { draw_fps(10, 10, 24, YELLOW); }
        EndDrawing();
    }
    CloseWindow();
    return 0;
}

