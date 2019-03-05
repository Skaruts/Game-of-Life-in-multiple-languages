#include "cellmap.h"
#include "utils.hpp"

void Cellmap::init(int w, int h, int cs) {
    GW = w;
    GH = h;
    CS = cs;
    old_buf = 0;
    curr_buf = 1;
    cell_color_alive = sf::Color(255, 128, 0);
    cell_color_dead = sf::Color(32, 32, 32);

    init_cells();
    randomize_cells();
}

void Cellmap::update() {
    if (!paused)
        pass_generation();
}

void Cellmap::render(sf::RenderWindow* window) {
    window->draw(quads);
}

void Cellmap::toggle_pause() {
    paused = !paused;
}

void Cellmap::init_cells() {
    // init buffers
    for (int buffers = 0; buffers < 2; buffers++) {
        vector< vector<uint8_t> > outer;
        for (int j = 0; j < GH; j++) {
            vector<uint8_t> inner;
            for (int i = 0; i < GW; i++) {
                inner.push_back(0);
            }
            outer.push_back(inner);
        }
        cells.push_back(outer);
    }

    // init vertexarray
    quads.setPrimitiveType(sf::Quads);
    quads.resize(GW * GH * 4);

    if (CS < 4) pad = 0; // otherwise if cells are 2x2 px, padding will make them 0x0 px

    for (int j = 0; j < GH; j++) {
        for (int i = 0; i < GW; i++) {
            int INDEX = (i+j*GW) * 4;
            sf::Vertex* quad = &quads[ INDEX ];
            quad[0].position = sf::Vector2f(  i   *CS +pad,    j   *CS +pad );    // top left
            quad[1].position = sf::Vector2f( (i+1)*CS -pad,    j   *CS +pad );    // top right
            quad[2].position = sf::Vector2f( (i+1)*CS -pad,   (j+1)*CS -pad );    // bot right
            quad[3].position = sf::Vector2f(  i   *CS +pad,   (j+1)*CS -pad );    // bot left

            update_quad(quad, cell_color_dead);
        }
    }
}

void Cellmap::update_quad(sf::Vertex* quad, sf::Color c) {
    quad[0].color = c;
    quad[1].color = c;
    quad[2].color = c;
    quad[3].color = c;
}

void Cellmap::randomize_cells() {
    for (int j = 0; j < GH; j++) {
        for (int i = 0; i < GW; i++) {
            bool r = utils::irand(0, 100) > 50;
            if (r) {
                cells[curr_buf][j][i] = 1;
                update_quad(&quads[(i+j*GW) * 4], cell_color_alive);
            } else {
                cells[old_buf][j][i] = 0;
                update_quad(&quads[(i+j*GW) * 4], cell_color_dead);
            }
        }
    }
}

void Cellmap::pass_generation() {
    old_buf = 1 - old_buf;
    curr_buf = 1 - curr_buf;

    for (int j = 0; j < GH; j++) {
        for (int i = 0; i < GW; i++) {
            // wrap around
            int j_ = j-1 >=  0   ?   j-1   :  GH-1;
            int _j = j+1 <  GH   ?   j+1   :     0;
            int i_ = i-1 >=  0   ?   i-1   :  GW-1;
            int _i = i+1 <  GW   ?   i+1   :     0;

            int n =   cells[old_buf][ j_    ][ i_    ]
                    + cells[old_buf][ j_    ][   i   ]
                    + cells[old_buf][ j_    ][    _i ]
                    + cells[old_buf][   j   ][ i_    ]
                    + cells[old_buf][   j   ][    _i ]
                    + cells[old_buf][    _j ][ i_    ]
                    + cells[old_buf][    _j ][   i   ]
                    + cells[old_buf][    _j ][    _i ];

            bool alive = n == 3 || ( cells[old_buf][j][i] && n == 2);
            cells[curr_buf][j][i] = (int)alive;

            if (alive)  update_quad(&quads[(i+j*GW) * 4], cell_color_alive);
            else        update_quad(&quads[(i+j*GW) * 4], cell_color_dead);

        }
    }
}


