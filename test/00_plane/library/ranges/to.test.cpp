#include <print>
#include <ranges>
#include <string>
#include <string_view>
#include <vector>


// ref: https://cpprefjp.github.io/reference/ranges/to.html

int main() {
    using namespace std::literals;

    auto str = "the quick brown fox"sv;
    auto words = std::views::split(str, ' ') | std::ranges::to<std::vector<std::string>>();

    for(const auto& word: words) {
        std::println("{}", word);
    }
}
