#include <cassert>
#include <print>


int main() {
    if(using T = int; T x = 1) {
        std::println("{}", x);
    }
    else {
        assert(false);
    }

    for(using T = int; T x : { 1, 2, 3 }) {
        std::println("{}", x);
    }
}
