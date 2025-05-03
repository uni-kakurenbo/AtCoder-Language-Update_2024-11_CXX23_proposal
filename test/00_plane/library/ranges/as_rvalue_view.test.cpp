#include <iterator>
#include <print>
#include <ranges>
#include <vector>


// ref: https://cpprefjp.github.io/reference/ranges/as_rvalue_view.html

int main() {
    std::vector<std::string> words = { "the", "quick", "brown", "fox", "ate", "a", "pterodactyl" };
    std::vector<std::string> new_words;

    std::ranges::copy(words | std::views::as_rvalue, std::back_inserter(new_words));

    for(const auto& x : new_words) {
        std::print("{}", x);
    }
}
