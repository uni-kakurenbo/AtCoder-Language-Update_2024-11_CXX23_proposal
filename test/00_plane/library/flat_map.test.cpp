#include <cassert>
#include <string>
#include <ranges>
#include <flat_map>



int main() {
    std::flat_map<std::string, int> fm = {
        { "0", 0 },
        { "1", 1 },
        { "2", 2 },
    };


    for(const auto &[key, value] : fm) {
        assert(std::stoi(key) == value);
    }
}
