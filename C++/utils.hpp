#ifndef UTILS_HPP_INCLUDED
#define UTILS_HPP_INCLUDED

namespace utils {
    // return a random int between min and max
    int irand(int min, int max) {
        return rand() % static_cast<int>(max - min) + min;
    }
}

#endif
