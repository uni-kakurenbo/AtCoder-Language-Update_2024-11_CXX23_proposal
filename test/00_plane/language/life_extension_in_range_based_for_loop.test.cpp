#include <print>
#include <vector>
#include <string>


std::vector<std::string> get_vector_string() {
    return { "element" };
}


int main() {
    for(auto&& c : get_vector_string()[0]) {
        std::println("{}", c);
    }
}
