#ifndef __CELLMAP_H___
#define __CELLMAP_H___

#include <SFML/Graphics.hpp>
#include <iostream>
#include <vector>
using namespace std;

class Cellmap {
    public:
        Cellmap() {};
        ~Cellmap() {};
        void init(int w, int h, int cs);

        void update();
        void render(sf::RenderWindow* window);
        void toggle_pause();

    private:
        vector< vector< vector<uint8_t> > > cells;
        sf::VertexArray quads;
        sf::Color cell_color_alive;
        sf::Color cell_color_dead;

        int GW;
        int GH;
        int CS;
        int old_buf = 0;
        int curr_buf = 1;
        bool paused = false;
        int pad = 1;

        void init_cells();
        void randomize_cells();
        void pass_generation();
        void update_quad(sf::Vertex* quad, sf::Color c);
};


#endif // __CELLMAP_H___
