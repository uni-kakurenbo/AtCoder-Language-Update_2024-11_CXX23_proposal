#include <cassert>
#include <string>
#include <ranges>
#include <flat_set>


int main() {
    std::flat_set<std::string> fm = { "0", "1", "2" };


    for(const auto & [ i, v ] : fm | std::views::enumerate) {
        assert(std::stoi(v) == i);
    }
}
