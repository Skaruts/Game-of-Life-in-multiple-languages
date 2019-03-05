#include <SFML/Graphics.hpp>
#include "cellmap.h"

bool paused = false;
bool running = true;

int m  = 4;     // scalar for cell and screen sizes
int CS = (int)16/m;  // cell size
int GW = 80*m;  // screen width
int GH = 50*m;  // screen height

bool space_pressed = false;
Cellmap cm;

bool init();

int main() {
    cm.init(GW, GH, CS);
    sf::RenderWindow window(sf::VideoMode(GW*CS, GH*CS), "Game of Life - SFML(C++)");
    window.setFramerateLimit(60);

    while( window.isOpen() ) {
        sf::Event event;
        while( window.pollEvent(event) ) {
            if ( event.type == sf::Event::Closed
            || sf::Keyboard::isKeyPressed(sf::Keyboard::Escape)
            || sf::Keyboard::isKeyPressed(sf::Keyboard::Q) ) {
                window.close();
            } else if (sf::Keyboard::isKeyPressed(sf::Keyboard::Space) && !space_pressed) {
                space_pressed = true;
                cm.toggle_pause();
            } else if (!sf::Keyboard::isKeyPressed(sf::Keyboard::Space) && space_pressed) {
                space_pressed = false;
            }
        }

        window.clear( sf::Color::Black );

        cm.update();
        cm.render(&window);

        window.display();
    }

    return 0;
}





