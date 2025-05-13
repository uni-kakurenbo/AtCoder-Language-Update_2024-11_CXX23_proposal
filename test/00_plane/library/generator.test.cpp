#ifdef __clang__


#pragma message("skipped")

int main() {}


#else


#include <print>
#include <generator>

using std::generator;


template<class T>
generator<T> iota(T end) {
    for(T i = 0; i < end; ++i) {
        co_yield i;
    }
}


int main() {
    for(auto v : iota<int>(10)) std::println("{}", v);
}


#endif
