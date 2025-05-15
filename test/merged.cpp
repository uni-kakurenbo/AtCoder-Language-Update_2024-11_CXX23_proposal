

#include <iostream>
#include <boost/stacktrace.hpp>


namespace boost_stacktrace {


auto a() __attribute__((noinline, noclone));
auto b() __attribute__((noinline, noclone));
auto c() __attribute__((noinline, noclone));
auto d() __attribute__((noinline, noclone));


auto a() {
  return boost::stacktrace::stacktrace();
}

auto b() {
    return a();
}

auto c() {
    return b();
}

auto d() {
    return c();
}


} // namespace boost_stacktrace


void test_01_boost_stacktrace(int, char* []) {
    using namespace boost_stacktrace;

    std::cout << a() << "\n";
    std::cout << b() << "\n";
    std::cout << c() << "\n";
    std::cout << d() << "\n";
}

//  rational number example program  ----------------------------------------//

//  (C) Copyright Paul Moore 1999. Permission to copy, use, modify, sell
//  and distribute this software is granted provided this copyright notice
//  appears in all copies. This software is provided "as is" without express or
//  implied warranty, and with no claim as to its suitability for any purpose.

//  Revision History
//  14 Dec 99  Initial version

#include <cassert>
#include <iostream>
#include <cassert>
#include <cstdlib>
#include <boost/config.hpp>
#ifndef BOOST_NO_LIMITS
#include <limits>
#else
#include <limits.h>
#endif
#include <exception>
#include <boost/rational.hpp>

using std::cout;
using std::endl;
using boost::rational;

#ifdef BOOST_NO_ARGUMENT_DEPENDENT_LOOKUP
// This is a nasty hack, required because MSVC does not implement "Koenig
// Lookup". Basically, if I call abs(r), the C++ standard says that the
// compiler should look for a definition of abs in the namespace which
// contains r's class (in this case boost) - among other places.

// Koenig Lookup is a relatively recent feature, and other compilers may not
// implement it yet. If so, try including this line.

using boost::abs;
#endif

void test_01_boost_rational(int, char* []) {
    rational<int> half(1,2);
    rational<int> one(1);
    rational<int> two(2);

    // Some basic checks
    assert(half.numerator() == 1);
    assert(half.denominator() == 2);
    assert(boost::rational_cast<double>(half) == 0.5);

    // Arithmetic
    assert(half + half == one);
    assert(one - half == half);
    assert(two * half == one);
    assert(one / half == two);

    // With conversions to integer
    assert(half+half == 1);
    assert(2 * half == one);
    assert(2 * half == 1);
    assert(one / half == 2);
    assert(1 / half == 2);

    // Sign handling
    rational<int> minus_half(-1,2);
    assert(-half == minus_half);
    assert(abs(minus_half) == half);

    // Do we avoid overflow?
#ifndef BOOST_NO_LIMITS
    int maxint = std::numeric_limits<int>::max();
#else
    int maxint = INT_MAX;
#endif
    rational<int> big(maxint, 2);
    assert(2 * big == maxint);

    // Print some of the above results
    cout << half << "+" << half << "=" << one << endl;
    cout << one << "-" << half << "=" << half << endl;
    cout << two << "*" << half << "=" << one << endl;
    cout << one << "/" << half << "=" << two << endl;
    cout << "abs(" << minus_half << ")=" << half << endl;
    cout << "2 * " << big << "=" << maxint
         << " (rational: " << rational<int>(maxint) << ")" << endl;

    // Some extras
    rational<int> pi(22,7);
    cout << "pi = " << boost::rational_cast<double>(pi) << " (nearly)" << endl;

    // Exception handling
    try {
        rational<int> r;        // Forgot to initialise - set to 0
        r = 1/r;                // Boom!
    }
    catch (const boost::bad_rational &e) {
        cout << "Bad rational, as expected: " << e.what() << endl;
    }
    catch (...) {
        cout << "Wrong exception raised!" << endl;
        assert(false);
    }
}

#include <ranges>
#include <vector>
#include <stack>
#include <queue>


void test_00_plane_library_construct_with_iterator_pair(int, char* []) {
    std::vector<int> v = { 10, 20, 30, 40 };

    std::stack<int> s(std::ranges::begin(v), std::ranges::end(v));
    std::queue<int> q(std::ranges::begin(v), std::ranges::end(v));
}

#include <cassert>
#include <string>
#include <ranges>
#include <flat_map>


void test_00_plane_library_flat_map(int, char* []) {
    std::flat_map<std::string, int> fm = {
        { "0", 0 },
        { "1", 1 },
        { "2", 2 },
    };


    for(const auto &[key, value] : fm) {
        assert(std::stoi(key) == value);
    }
}

#include <ranges>
#include <print>
#include <experimental/simd>


int A[16], B[16], C[16];


void test_00_plane_library_simd(int, char* []) {
    for(const auto i : std::views::iota(0, 16)){
        A[i] = i;
        B[i] = i * 100;
    }

    std::experimental::fixed_size_simd<int,16> a(&A[0], std::experimental::element_aligned), b;
    b.copy_from(&B[0], std::experimental::element_aligned);


#   ifdef __clang__


    auto d = a;


#   else


    auto c = a + b;

    c.copy_to(&C[0], std::experimental::element_aligned);

    for(const auto v : C) std::print("{} ", v);
    std::println();

    std::experimental::native_simd<double> d = 100, e([](int i){ return i * i * i * i; });
    d += std::experimental::sqrt(e);


#   endif


    for(const auto i : std::views::iota(0) | std::views::take(d.size())) std::print("{} ", int(d[i]));
    std::println();
}

#ifdef __clang__


#pragma message("skipped")

void test_00_plane_library_stacktrace(int, char* []) {}


#else


#include <print>
#include <stacktrace>


namespace stacktrace {


auto a() __attribute__((noinline, noclone));
auto b() __attribute__((noinline, noclone));
auto c() __attribute__((noinline, noclone));
auto d() __attribute__((noinline, noclone));


auto a() {
  return std::stacktrace::current();
}

auto b() {
    return a();
}

auto c() {
    return b();
}

auto d() {
    return c();
}


} // namespace stacktrace


void test_00_plane_library_stacktrace(int, char* []) {
    using namespace stacktrace;

    std::println("{}", a());
    std::println("{}", b());
    std::println("{}", c());
    std::println("{}", d());
}


#endif

#ifndef __clang


#pragma message("skipped")

void test_00_plane_library_mdspan(int, char* []) {}


#else


#include <print>
#include <mdspan>


// ref: https://cpprefjp.github.io/reference/mdspan/mdspan.html

void test_00_plane_library_mdspan(int, char* []) {
    using extentes_2x3 = std::extents<size_t, 2, 3>;
    const double arr[] = {1, 2, 3, 4, 5, 6};

    std::mdspan<double, extentes_2x3> mat{arr};

    for(size_t i = 0; i < mat.extent(0); ++i) {
        for(size_t j = 0; j < mat.extent(1); ++j) {
            std::print("{} ", mat[i, j]);
        }

        std::println();
    }
}


#endif

#ifdef __clang__


#pragma message("skipped")

void test_00_plane_library_spanstream(int, char* []) {}


#else


#include <cassert>
#include <iostream>
#include <string_view>
#include <spanstream>
#include <sstream>


// ref: https://cppmap.github.io/standardization/cpp23/#stdstringstream-stdspan-stdspanstream-p0448r4

void test_00_plane_library_spanstream(int, char* []) {
    const char input[] = "0 1 2";

    std::ispanstream is{ input };
    int a, b, c;
    is >> a >> b >> c;

    char buffer[30]{};

    std::ospanstream os{ buffer };
    os << (a * 100) << (b * 100) << (c * 100);

    assert(std::string_view{ os.span() } == "0100200");
}


#endif

#include <iostream>
#include <utility>

enum class char_enum : char {
    element
};

enum class default_enum {
    element
};

void test_00_plane_library_to_underlying(int, char* []) {
    static_assert(std::same_as<decltype(std::to_underlying(char_enum::element)), char>);
    static_assert(std::same_as<decltype(std::to_underlying(default_enum::element)), int>);
}

#ifdef __clang__


#pragma message("skipped")

void test_00_plane_library_ranges_cartesian_product_view(int, char* []) {}


#else


#include <cassert>
#include <list>
#include <print>
#include <ranges>
#include <vector>


// ref: https://cpprefjp.github.io/reference/ranges/cartesian_product_view.html

void test_00_plane_library_ranges_cartesian_product_view(int, char* []) {
    std::vector v = {1, 2};
    const std::list l = {'a', 'b', 'c'};

    for(const auto& [ i, x ] : std::views::cartesian_product(v, l)) {
        std::println("({}, {})", i, x);
    }

    assert(std::views::cartesian_product().size() == 1);
}


#endif

#include <iterator>
#include <print>
#include <ranges>
#include <vector>


// ref: https://cpprefjp.github.io/reference/ranges/as_rvalue_view.html

void test_00_plane_library_ranges_as_rvalue_view(int, char* []) {
    std::vector<std::string> words = { "the", "quick", "brown", "fox", "ate", "a", "pterodactyl" };
    std::vector<std::string> new_words;

    std::ranges::copy(words | std::views::as_rvalue, std::back_inserter(new_words));

    for(const auto& x : new_words) {
        std::print("{}", x);
    }
}

#ifdef __clang__


#pragma message("skipped")

void test_00_plane_library_ranges_stride_view(int, char* []) {}


#else


#include <print>
#include <ranges>
#include <vector>


// ref: https://cpprefjp.github.io/reference/ranges/stride_view.html

void test_00_plane_library_ranges_stride_view(int, char* []) {
    std::vector v = {0, 1, 2, 3, 4, 5, 6};

    for(auto&& i : v | std::views::stride(3)) {
        i *= 10;
    }

    for(const auto& x: v) {
        std::println("{}", x);
    }
}


#endif

#include <cassert>
#include <list>
#include <print>
#include <ranges>
#include <unordered_map>
#include <vector>


// ref: https://cpprefjp.github.io/reference/ranges/zip_view.html

void test_00_plane_library_ranges_zip_view(int, char* []) {
    std::vector v = {1, 2};
    const std::list l = {'a', 'b', 'c'};

    for(auto &&[i, c] : std::views::zip(v, l)) {
        i *= 10;
    }

    for(const auto& [ i, x ]: std::views::zip(v, l)) {
        std::println("{}: {}", i, x);
    }

    assert(std::ranges::size(std::views::zip()) == 0uz);
}

#include <print>
#include <ranges>
#include <vector>


// ref: https://cpprefjp.github.io/reference/ranges/chunk_by_view.html

void test_00_plane_library_ranges_chunk_by_view(int, char* []) {
    std::vector v = { 1, 2, 3, 4, 5, 6 };

    for(const auto& x : v | std::views::chunk_by(std::ranges::less_equal{})) {
        for(const auto& y : x) {
            std::println("{}", y);
        }
    }
}

#include <print>
#include <ranges>
#include <string>
#include <string_view>
#include <vector>


// ref: https://cpprefjp.github.io/reference/ranges/to.html

void test_00_plane_library_ranges_to(int, char* []) {
    using namespace std::literals;

    auto str = "the quick brown fox"sv;
    auto words = std::views::split(str, ' ') | std::ranges::to<std::vector<std::string>>();

    for(const auto& word: words) {
        std::println("{}", word);
    }
}

#ifdef __clang__


#pragma message("skipped")

void test_00_plane_library_ranges_join_with_view(int, char* []) {}


#else


#include <print>
#include <ranges>
#include <string>
#include <vector>


// ref: https://cpprefjp.github.io/reference/ranges/join_with_view.html

void test_00_plane_library_ranges_join_with_view(int, char* []) {
    using namespace std;
    vector<string> sv = {"hello", "world"};

    for(char c : sv | views::join_with('-')) {
        println("{}", c);
    }
}


#endif

#include <print>
#include <ranges>


void test_00_plane_library_ranges_repeate_view(int, char* []) {
    for(const auto& x : std::views::repeat(0, 10)) {
        std::println("{}", x);
    }
}

#ifdef __clang__


#pragma message("skipped")

void test_00_plane_library_ranges_slide_view(int, char* []) {}


#else


#include <print>
#include <ranges>
#include <vector>


void test_00_plane_library_ranges_slide_view(int, char* []) {
    std::vector v = { 1, 2, 3, 4, 5, 6 };


    for(const auto& x : v | std::views::slide(2)) {
        for(const auto& y : x) {
            std::println("{}", y);
        }
    }
}


#endif

#ifdef __clang__


#pragma message("skipped")

void test_00_plane_library_ranges_chunk_view(int, char* []) {}


#else


#include <print>
#include <ranges>
#include <vector>


void test_00_plane_library_ranges_chunk_view(int, char* []) {
    std::vector v = { 1, 2, 3, 4, 5, 6 };

    for(const auto& x : v | std::views::chunk(3)) {
        for(const auto& y : x) {
            std::println("{}", y);
        }
    }
}


#endif

#ifdef __clang__


#pragma message("skipped")

void test_00_plane_library_ranges_range_fold_algorithms(int, char* []) {}


#else


#include <algorithm>
#include <functional>
#include <print>
#include <ranges>
#include <vector>


// ref: https://cpprefjp.github.io/reference/algorithm/ranges_fold_left.html

void test_00_plane_library_ranges_range_fold_algorithms(int, char* []) {
    using namespace std::ranges;

    range auto rng = views::iota('a', 'g');

    const std::string init = "init";

    auto op_left = [](std::string acc, char elem) {
        acc += " -> ";
        acc += elem;
        return acc;
    };

    auto op_right = [op_left](char elem, std::string acc) {
        return op_left(std::move(acc), elem);
    };

    auto resl = fold_left(rng, init, op_left);
    auto resr = fold_right(rng, init, op_right);

    std::println("{:s}", resl);
    std::println("{:s}", resr);
}


#endif

#ifdef __clang__


#pragma message("skipped")

void test_00_plane_library_ranges_enumerate_view(int, char* []) {}


#else


#include <print>
#include <ranges>
#include <vector>


// ref: https://cpprefjp.github.io/reference/ranges/enumerate_view.html

void test_00_plane_library_ranges_enumerate_view(int, char* []) {
    const std::vector v = {'a', 'b', 'c'};

    for(const auto& [ i, x ] : v | std::views::enumerate) {
        std::println("{}: {}", i, x);
    }
}


#endif

#ifdef __clang__


#pragma message("skipped")

void test_00_plane_library_float128_t(int, char* []) {}


#else


#include <stdfloat>
#include <type_traits>
#include <print>


void test_00_plane_library_float128_t(int, char* []) {
    std::float128_t x = 1.0f128 / 1234567890;
    std::println("{}", x);

    static_assert(std::floating_point<std::float128_t>);
    static_assert(std::numeric_limits<std::float128_t>::digits == 113);
}


#endif

#include <cassert>
#include <string>


void test_00_plane_library_contains(int, char* []) {
    std::string_view s = "abc";

    assert(s.contains('b'));
    assert(!s.contains('d'));
}

#ifdef __clang__


#pragma message("skipped")

void test_00_plane_library_flat_set(int, char* []) {}


#else


#include <cassert>
#include <string>
#include <ranges>
#include <flat_set>


void test_00_plane_library_flat_set(int, char* []) {
    std::flat_set<std::string> fm = { "0", "1", "2" };


    for(const auto & [ i, v ] : fm | std::views::enumerate) {
        assert(std::stoi(v) == i);
    }
}


#endif

#include <print>
#include <iostream>
#include <expected>
#include <iomanip>
#include <string>


// ref: https://cpprefjp.github.io/reference/expected/expected.html

namespace expected {


std::expected<int, std::string> idiv(int a, int b) {
    if(b == 0) { return std::unexpected{ "divide by zero" }; }
    if(a % b != 0) { return std::unexpected{ "out of domain" }; }

    return a / b;
}


void dump_result(const std::expected<int, std::string> &v) {
    if(v) {
        std::println("{}", *v);
    }
    else {
        std::cout << std::quoted(v.error()) << "\n";
    }
}


} // namespace expected


void test_00_plane_library_expected(int, char* []) {
    using namespace expected;

    dump_result(idiv(10, 2));
    dump_result(idiv(10, 3));
    dump_result(idiv(10, 0));
}

#ifdef __clang__


#pragma message("skipped")

void test_00_plane_library_generator(int, char* []) {}


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


void test_00_plane_library_generator(int, char* []) {
    for(auto v : iota<int>(10)) std::println("{}", v);
}


#endif

#include <iostream>
#include <type_traits>


enum unscoped_enum {};
enum class scoped_enum {};


void test_00_plane_library_is_scoped_enum(int, char* []) {
    static_assert(!std::is_enum_v<int>);
    static_assert(std::is_enum_v<unscoped_enum>);
    static_assert(std::is_enum_v<scoped_enum>);

    static_assert(!std::is_scoped_enum_v<int>);
    static_assert(!std::is_scoped_enum_v<unscoped_enum>);
    static_assert(std::is_scoped_enum_v<scoped_enum>);
}

#include <print>


void test_00_plane_library_println(int, char* []) {
    std::println("Hello, world.");
}

#include <bits/stdc++.h>

void test_00_plane_misc_bits_stdcxx_h(int, char* []) {
    std::println();
}

#include <cassert>


constexpr bool if_consteval() {
    if consteval {
        return true;
    }
    else {
        return false;
    }
}

constexpr bool if_not_consteval() {
    if !consteval {
        return true;
    }
    else {
        return false;
    }
}



void test_00_plane_language_if_consteval(int, char* []) {
    static_assert(if_consteval());
    assert(!if_consteval());

    static_assert(!if_not_consteval());
    assert(if_not_consteval());
}

#include <cassert>


void test_00_plane_language_attributes_on_lambda_expressions(int, char* []) {
    assert(([] [[nodiscard]] { return true; })());
}

#include <print>

void test_00_plane_language_labels_at_the_end_of_compound_statements(int, char* []) {
  first:

    std::println("a");

  second:

    std::println("b");

  last:
}

#include <optional>


namespace non_const_evaluated_constexpr_function {


template<typename T>
constexpr void f(std::optional<T>& optional) {
    optional.reset();
}


} // namespace non_const_evaluated_constexpr_function


void test_00_plane_language_non_const_evaluated_constexpr_function(int, char* []) {
    using namespace non_const_evaluated_constexpr_function;

    std::optional<int> v = 0;
    f(v);
}

#include <algorithm>


// ref: https://cpprefjp.github.io/lang/cpp23/consteval_needs_to_propagate_up.html


consteval bool is_even(int x) {
  return x % 2 == 0;
}


void test_00_plane_language_consteval_conditionally_makes_constexpr_function_consteval(int, char* []) {
    constexpr int ar[] = {1, 3, 5};


    static_assert(
        std::ranges::none_of(
            ar,
            [](int x) { return is_even(x); }
        )
    );


    static_assert(
        std::ranges::none_of(
            ar,
            [](int x) consteval { return is_even(x); }
        )
    );


    static_assert(std::ranges::none_of(ar, is_even));
}

#include <cassert>


template <class T>
constexpr T zero = 0;

template <class T>
constexpr T* zero<T*> = nullptr;


void test_00_plane_language_generalized_wording_for_partial_specializations(int, char* []) {
    assert(zero<int> == 0);
    assert(zero<int*> == nullptr);
}

#include <cassert>


namespace portable_assumptions {


int f(int x) {
    [[assume(x-- == 0)]];

    return x;
}


} // namespace portable_assumptions


void test_00_plane_language_portable_assumptions(int, char* []) {
    using namespace portable_assumptions;

    assert(f(1));
}

#include <cassert>


struct statically_invokable {
  static bool operator()(int x) {
    return x > 0;
  }
};


void test_00_plane_language_static_operator(int, char* []) {
    auto f = []() static { return 1; };
    assert(statically_invokable::operator()(f()));
}

#include <cassert>
#include <algorithm>
#include <vector>


void test_00_plane_language_literal_suffix_for_size_t(int, char* []) {
    std::vector<int> v{ 0, 1, 2, 3 };

    assert(std::max(1uz, v.size()) == 4uz);
}

constexpr int N = 1;

void test_00_plane_language_narrowing_contextual_conversions_to_bool(int, char* []) {
    if constexpr(N) {}
    if constexpr(N % 4) {}

    static_assert(N);
    static_assert(N % 4);
}

#ifdef SOMETHING

#error unreachable

#elifndef __GNUC__

#error unreachable

#elifdef __cplusplus


#warning reachable

void test_00_plane_language_elifdef_and_elifndef_and_warning(int, char* []) {}


#else

#error unreachable

#endif

#include <cassert>


namespace static_constexpr_variables_in_constexpr_functions {


constexpr auto f(int i) {
    static constexpr char STR[] = "ABC";
    return STR[i];
}


} // namespace static_constexpr_variables_in_constexpr_functions


void test_00_plane_language_static_constexpr_variables_in_constexpr_functions(int, char* []) {
    using namespace static_constexpr_variables_in_constexpr_functions;

    assert(f(0) == 'A');
}

#include <cassert>
#include <utility>


void test_00_plane_language_lambda_expressions_with_parentheses_omitted(int, char* []) {
    int a = 1;
    assert(([b = std::move(a)] mutable { return b; })());

    assert(([] constexpr mutable noexcept -> bool { return true; })());
}

#include <cassert>
#include <print>


void test_00_plane_language_alias_declaration_in_init_statement(int, char* []) {
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

#include <print>
#include <vector>
#include <string>


std::vector<std::string> get_vector_string() {
    return { "element" };
}


void test_00_plane_language_life_extension_in_range_based_for_loop(int, char* []) {
    for(auto&& c : get_vector_string()[0]) {
        std::println("{}", c);
    }
}

#include <cassert>


namespace non_literal_variables_in_constexpr_function {


constexpr int f(int x) {
    if consteval {
        return x;
    } else {
        thread_local int n = x;
        return n + x;
    }
}


} // namespace non_literal_variables_in_constexpr_function


void test_00_plane_language_non_literal_variables_and_labels_and_gotos_in_constexpr_functions(int, char* []) {
    using namespace non_literal_variables_in_constexpr_function;

    static_assert(f(1));
    assert(f(1));
}

#include <cassert>


void test_00_plane_language_named_universal_character_escapes(int, char* []) {
    const char8_t* a = u8"\u0100\u0300";
    const char8_t* b = u8"\N{LATIN CAPITAL LETTER A WITH MACRON}\N{COMBINING GRAVE ACCENT}";

    assert(reinterpret_cast<const char*>(a) == reinterpret_cast<const char*>(b));
}

#include <concepts>


namespace simpler_implicit_move {


struct movable {
    movable() = default;
    movable(movable&&);
};

struct rvalue_reference_qualified_convertible {
    int x = 0;
    operator int&() && {
        return this->x;
    };
};


movable&& implicitly_move_local_rvalue_reference(movable&& x) {
    return x;
}

int& implicitly_move_local_value_with_convertion(rvalue_reference_qualified_convertible x) {
    return x;
}


auto return_movable_expression(int n) -> auto&& {
  return n;
}

auto return_parentheses_enclosed_expression(int n) -> decltype(auto) {
    return (n);
}


} // namespace simpler_implicit_move


void test_00_plane_language_simpler_implicit_move(int, char* []) {
    using namespace simpler_implicit_move;

    static_assert(std::same_as<decltype(implicitly_move_local_rvalue_reference({})), movable&&>);
    static_assert(std::same_as<decltype(implicitly_move_local_value_with_convertion({})), int&>);

    static_assert(std::same_as<decltype(return_movable_expression({})), int&&>);
    static_assert(std::same_as<decltype(return_parentheses_enclosed_expression({})), int&&>);
}

#ifdef __clang__


#pragma message("skipped")

void test_00_plane_language_wording_for_class_template_argument_deduction_from_inherited_constructors(int, char* []) {}


#else


#include <concepts>


template<class T, class U, class V>
struct basic_class_template {
    using value_type = T;
    basic_class_template(T, U, V) {};
};


template<class T, class U>
struct derived_class_template : basic_class_template<U, T, int> {
   using basic_class_template<U, T, int>::basic_class_template;
};


void test_00_plane_language_wording_for_class_template_argument_deduction_from_inherited_constructors(int, char* []) {
    static_assert(
        std::same_as<
            decltype(derived_class_template(true, 'a', 1))::value_type,
            bool
        >
    );
}


#endif

#include <print>


namespace deducing_this {


struct X {
    void f() const& {
        std::println("f");
    }

    void g(this const X& self) {
        std::println("g");

        self.f();
    }
};


} // namespace deducing_this


void test_00_plane_language_deducing_this(int, char* []) {
    using namespace deducing_this;

    X{}.g();
}

#include <algorithm>
#include <cassert>
#include <ranges>


#ifdef __clang__


using std::ranges::starts_with;


#else


#include <range/v3/algorithm/starts_with.hpp>
using ranges::starts_with;


#endif


void test_02_other_starts_with(int, char* []) {
    auto a = std::views::iota(0, 20);
    auto b = std::views::iota(0, 10);

    assert(starts_with(a, b));
}

#include <print>
#include <omp.h>

void test_01_open_mp_get_max_threads(int, char* []) {
    std::println("max threads: {}", omp_get_max_threads());
}

#include <print>
#include <string>
#include <ranges>
#include <range/v3/algorithm/for_each.hpp>
#include <range/v3/view/concat.hpp>
#include <range/v3/view/cycle.hpp>
#include <range/v3/view/take.hpp>
#include <range/v3/range/conversion.hpp>

void test_01_range_v3_mixed(int, char* []) {
    const std::string a = "ABCD";
    const std::string b = "1234";

    std::println(
        "{}",
        ranges::views::concat(a, b) |
            ranges::views::cycle |
            std::views::drop(10) |
            std::views::take(13) |
            std::ranges::to<std::string>()
    );
}

#include <print>
#include <string>
#include <range/v3/algorithm/for_each.hpp>

void test_01_range_v3_for_each(int, char* []) {
    const std::string msg = "Hello, world.";

    ranges::for_each(msg, [](auto c) { std::print("{} ", c); });
    std::println();
}

#include <print>
#include <ankerl/unordered_dense.h>

void test_01_unordered_dense_map(int, char* []) {
    ankerl::unordered_dense::map<int, std::string> map;

    map[31415] = "3.1415";
    map[27182] = "2.7182";

    for(const auto& [key, val] : map) {
        println("{}: {}", key, val);
    }
}

// ref: https://github.com/Z3Prover/z3/blob/master/examples/c%2B%2B/example.cpp

/*++

The MIT License (MIT)

Copyright (c) Microsoft Corporation

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

--*/

#include <z3++.h>
#include <iostream>
#include <sstream>
#include <vector>


namespace z3_example {


using namespace z3;


/**
   Demonstration of how Z3 can be used to prove validity of
   De Morgan's Duality Law: {e not(x and y) <-> (not x) or ( not y) }
*/
void demorgan() {
    std::cout << "de-Morgan example\n";

    context c;

    expr x = c.bool_const("x");
    expr y = c.bool_const("y");
    expr conjecture = (!(x && y)) == (!x || !y);

    solver s(c);
    // adding the negation of the conjecture as a constraint.
    s.add(!conjecture);
    std::cout << s << "\n";
    std::cout << s.to_smt2() << "\n";
    switch (s.check()) {
    case unsat:   std::cout << "de-Morgan is valid\n"; break;
    case sat:     std::cout << "de-Morgan is not valid\n"; break;
    case unknown: std::cout << "unknown\n"; break;
    }
}

/**
   \brief Find a model for <tt>x >= 1 and y < x + 3</tt>.
*/
void find_model_example1() {
    std::cout << "find_model_example1\n";
    context c;
    expr x = c.int_const("x");
    expr y = c.int_const("y");
    solver s(c);

    s.add(x >= 1);
    s.add(y < x + 3);
    std::cout << s.check() << "\n";

    model m = s.get_model();
    std::cout << m << "\n";
    // traversing the model
    for (unsigned i = 0; i < m.size(); i++) {
        func_decl v = m[i];
        // this problem contains only constants
        assert(v.arity() == 0);
        std::cout << v.name() << " = " << m.get_const_interp(v) << "\n";
    }
    // we can evaluate expressions in the model.
    std::cout << "x + y + 1 = " << m.eval(x + y + 1) << "\n";
}


/**
   \brief Prove <tt>x = y implies g(x) = g(y)</tt>, and
   disprove <tt>x = y implies g(g(x)) = g(y)</tt>.

   This function demonstrates how to create uninterpreted types and
   functions.
*/
void prove_example1() {
    std::cout << "prove_example1\n";

    context c;
    expr x      = c.int_const("x");
    expr y      = c.int_const("y");
    sort I      = c.int_sort();
    func_decl g = function("g", I, I);

    solver s(c);
    expr conjecture1 = implies(x == y, g(x) == g(y));
    std::cout << "conjecture 1\n" << conjecture1 << "\n";
    s.add(!conjecture1);
    if (s.check() == unsat)
        std::cout << "proved" << "\n";
    else
        std::cout << "failed to prove" << "\n";

    s.reset(); // remove all assertions from solver s

    expr conjecture2 = implies(x == y, g(g(x)) == g(y));
    std::cout << "conjecture 2\n" << conjecture2 << "\n";
    s.add(!conjecture2);
    if (s.check() == unsat) {
        std::cout << "proved" << "\n";
    }
    else {
        std::cout << "failed to prove" << "\n";
        model m = s.get_model();
        std::cout << "counterexample:\n" << m << "\n";
        std::cout << "g(g(x)) = " << m.eval(g(g(x))) << "\n";
        std::cout << "g(y)    = " << m.eval(g(y)) << "\n";
    }
}

/**
   \brief Prove <tt>not(g(g(x) - g(y)) = g(z)), x + z <= y <= x implies z < 0 </tt>.
   Then, show that <tt>z < -1</tt> is not implied.

   This example demonstrates how to combine uninterpreted functions and arithmetic.
*/
void prove_example2() {
    std::cout << "prove_example1\n";
    context c;
    expr x      = c.int_const("x");
    expr y      = c.int_const("y");
    expr z      = c.int_const("z");
    sort I      = c.int_sort();
    func_decl g = function("g", I, I);

    expr conjecture1 = implies(g(g(x) - g(y)) != g(z) && x + z <= y && y <= x,
                               z < 0);

    solver s(c);
    s.add(!conjecture1);
    std::cout << "conjecture 1:\n" << conjecture1 << "\n";
    if (s.check() == unsat)
        std::cout << "proved" << "\n";
    else
        std::cout << "failed to prove" << "\n";

    expr conjecture2 = implies(g(g(x) - g(y)) != g(z) && x + z <= y && y <= x,
                               z < -1);
    s.reset();
    s.add(!conjecture2);
    std::cout << "conjecture 2:\n" << conjecture2 << "\n";

    if (s.check() == unsat) {
        std::cout << "proved" << "\n";
    }
    else {
        std::cout << "failed to prove" << "\n";
        std::cout << "counterexample:\n" << s.get_model() << "\n";
    }
}

/**
   \brief Nonlinear arithmetic example 1
*/
void nonlinear_example1() {
    std::cout << "nonlinear example 1\n";
    config cfg;
    cfg.set("auto_config", true);
    context c(cfg);

    expr x = c.real_const("x");
    expr y = c.real_const("y");
    expr z = c.real_const("z");

    solver s(c);

    s.add(x*x + y*y == 1);                     // x^2 + y^2 == 1
    s.add(x*x*x + z*z*z < c.real_val("1/2"));  // x^3 + z^3 < 1/2
    s.add(z != 0);
    std::cout << s.check() << "\n";
    model m = s.get_model();
    std::cout << m << "\n";
    set_param("pp.decimal", true); // set decimal notation
    std::cout << "model in decimal notation\n";
    std::cout << m << "\n";
    set_param("pp.decimal-precision", 50); // increase number of decimal places to 50.
    std::cout << "model using 50 decimal places\n";
    std::cout << m << "\n";
    set_param("pp.decimal", false); // disable decimal notation
}

/**
   \brief Simple function that tries to prove the given conjecture using the following steps:
   1- create a solver
   2- assert the negation of the conjecture
   3- checks if the result is unsat.
*/
void prove(expr conjecture) {
    context & c = conjecture.ctx();
    solver s(c);
    s.add(!conjecture);
    std::cout << "conjecture:\n" << conjecture << "\n";
    if (s.check() == unsat) {
        std::cout << "proved" << "\n";
    }
    else {
        std::cout << "failed to prove" << "\n";
        std::cout << "counterexample:\n" << s.get_model() << "\n";
    }
}

/**
   \brief Simple bit-vector example. This example disproves that x - 10 <= 0 IFF x <= 10 for (32-bit) machine integers
*/
void bitvector_example1() {
    std::cout << "bitvector example 1\n";
    context c;
    expr x = c.bv_const("x", 32);

    // using signed <=
    prove((x - 10 <= 0) == (x <= 10));

    // using unsigned <=
    prove(ule(x - 10, 0) == ule(x, 10));

    expr y = c.bv_const("y", 32);
    prove(implies(concat(x, y) == concat(y, x), x == y));
}

/**
   \brief Find x and y such that: x ^ y - 103 == x * y
*/
void bitvector_example2() {
    std::cout << "bitvector example 2\n";
    context c;
    expr x = c.bv_const("x", 32);
    expr y = c.bv_const("y", 32);
    solver s(c);
    // In C++, the operator == has higher precedence than ^.
    s.add((x ^ y) - 103 == x * y);
    std::cout << s << "\n";
    std::cout << s.check() << "\n";
    std::cout << s.get_model() << "\n";
}

/**
   \brief Mixing C and C++ APIs.
*/
void capi_example() {
    std::cout << "capi example\n";
    context c;
    expr x = c.bv_const("x", 32);
    expr y = c.bv_const("y", 32);
    // Invoking a C API function, and wrapping the result using an expr object.
    expr r = to_expr(c, Z3_mk_bvsrem(c, x, y));
    std::cout << "r: " << r << "\n";
}

/**
   \brief Demonstrate how to evaluate expressions in a model.
*/
void eval_example1() {
    std::cout << "eval example 1\n";
    context c;
    expr x = c.int_const("x");
    expr y = c.int_const("y");
    solver s(c);

    /* assert x < y */
    s.add(x < y);
    /* assert x > 2 */
    s.add(x > 2);

    std::cout << s.check() << "\n";

    model m = s.get_model();
    std::cout << "Model:\n" << m << "\n";
    std::cout << "x+y = " << m.eval(x+y) << "\n";
}

/**
   \brief Several contexts can be used simultaneously.
*/
void two_contexts_example1() {
    std::cout << "two contexts example 1\n";
    context c1, c2;

    expr x = c1.int_const("x");
    expr n = x + 1;
    // We cannot mix expressions from different contexts, but we can copy
    // an expression from one context to another.
    // The following statement copies the expression n from c1 to c2.
    expr n1 = to_expr(c2, Z3_translate(c1, n, c2));
    std::cout << n1 << "\n";
}

/**
   \brief Demonstrates how to catch API usage errors.
 */
void error_example() {
    std::cout << "error example\n";

    context c;
    expr x = c.bool_const("x");

    // Error using the C API can be detected using Z3_get_error_code.
    // The next call fails because x is a constant.
    //Z3_ast arg = Z3_get_app_arg(c, x, 0);
    if (Z3_get_error_code(c) != Z3_OK) {
        std::cout << "last call failed.\n";
    }

    // The C++ layer converts API usage errors into exceptions.
    try {
        // The next call fails because x is a Boolean.
        expr n = x + 1;
    }
    catch (exception & ex) {
        std::cout << "failed: " << ex << "\n";
    }

    // The functions to_expr, to_sort and to_func_decl also convert C API errors into exceptions.
    try {
        expr arg = to_expr(c, Z3_get_app_arg(c, x, 0));
    }
    catch (exception & ex) {
        std::cout << "failed: " << ex << "\n";
    }
}

/**
    \brief Demonstrate different ways of creating rational numbers: decimal and fractional representations.
*/
void numeral_example() {
    std::cout << "numeral example\n";
    context c;

    expr n1 = c.real_val("1/2");
    expr n2 = c.real_val("0.5");
    expr n3 = c.real_val(1, 2);
    std::cout << n1 << " " << n2 << " " << n3 << "\n";
    prove(n1 == n2 && n1 == n3);

    n1 = c.real_val("-1/3");
    n2 = c.real_val("-0.3333333333333333333333333333333333");
    std::cout << n1 << " " << n2 << "\n";
    prove(n1 != n2);
}

/**
   \brief Test ite-term (if-then-else terms).
*/
void ite_example() {
    std::cout << "if-then-else example\n";
    context c;

    expr f    = c.bool_val(false);
    expr one  = c.int_val(1);
    expr zero = c.int_val(0);
    expr ite  = to_expr(c, Z3_mk_ite(c, f, one, zero));

    std::cout << "term: " << ite << "\n";
}

void ite_example2() {
    std::cout << "if-then-else example2\n";
    context c;
    expr b = c.bool_const("b");
    expr x = c.int_const("x");
    expr y = c.int_const("y");
    std::cout << (ite(b, x, y) > 0) << "\n";
}

/**
   \brief Small example using quantifiers.
*/
void quantifier_example() {
    std::cout << "quantifier example\n";
    context c;

    expr x = c.int_const("x");
    expr y = c.int_const("y");
    sort I = c.int_sort();
    func_decl f = function("f", I, I, I);

    solver s(c);

    // making sure model based quantifier instantiation is enabled.
    params p(c);
    p.set("mbqi", true);
    s.set(p);

    s.add(forall(x, y, f(x, y) >= 0));
    expr a = c.int_const("a");
    s.add(f(a, a) < a);
    std::cout << s << "\n";
    std::cout << s.check() << "\n";
    std::cout << s.get_model() << "\n";
    s.add(a < 0);
    std::cout << s.check() << "\n";
}

/**
   \brief Unsat core example
*/
void unsat_core_example1() {
    std::cout << "unsat core example1\n";
    context c;
    // We use answer literals to track assertions.
    // An answer literal is essentially a fresh Boolean marker
    // that is used to track an assertion.
    // For example, if we want to track assertion F, we
    // create a fresh Boolean variable p and assert (p => F)
    // Then we provide p as an argument for the check method.
    expr p1 = c.bool_const("p1");
    expr p2 = c.bool_const("p2");
    expr p3 = c.bool_const("p3");
    expr x  = c.int_const("x");
    expr y  = c.int_const("y");
    solver s(c);
    s.add(implies(p1, x > 10));
    s.add(implies(p1, y > x));
    s.add(implies(p2, y < 5));
    s.add(implies(p3, y > 0));
    expr assumptions[3] = { p1, p2, p3 };
    std::cout << s.check(3, assumptions) << "\n";
    expr_vector core = s.unsat_core();
    std::cout << core << "\n";
    std::cout << "size: " << core.size() << "\n";
    for (unsigned i = 0; i < core.size(); i++) {
        std::cout << core[i] << "\n";
    }
    // Trying again without p2
    expr assumptions2[2] = { p1, p3 };
    std::cout << s.check(2, assumptions2) << "\n";
}

/**
   \brief Unsat core example 2
*/
void unsat_core_example2() {
    std::cout << "unsat core example 2\n";
    context c;
    // The answer literal mechanism, described in the previous example,
    // tracks assertions. An assertion can be a complicated
    // formula containing containing the conjunction of many subformulas.
    expr p1 = c.bool_const("p1");
    expr x  = c.int_const("x");
    expr y  = c.int_const("y");
    solver s(c);
    expr F  = x > 10 && y > x && y < 5 && y > 0;
    s.add(implies(p1, F));
    expr assumptions[1] = { p1 };
    std::cout << s.check(1, assumptions) << "\n";
    expr_vector core = s.unsat_core();
    std::cout << core << "\n";
    std::cout << "size: " << core.size() << "\n";
    for (unsigned i = 0; i < core.size(); i++) {
        std::cout << core[i] << "\n";
    }
    // The core is not very informative, since p1 is tracking the formula F
    // that is a conjunction of subformulas.
    // Now, we use the following piece of code to break this conjunction
    // into individual subformulas. First, we flat the conjunctions by
    // using the method simplify.
    std::vector<expr> qs; // auxiliary vector used to store new answer literals.
    assert(F.is_app()); // I'm assuming F is an application.
    if (F.decl().decl_kind() == Z3_OP_AND) {
        // F is a conjunction
        std::cout << "F num. args (before simplify): " << F.num_args() << "\n";
        F = F.simplify();
        std::cout << "F num. args (after simplify):  " << F.num_args() << "\n";
        for (unsigned i = 0; i < F.num_args(); i++) {
            std::cout << "Creating answer literal q" << i << " for " << F.arg(i) << "\n";
            std::stringstream qname; qname << "q" << i;
            expr qi = c.bool_const(qname.str().c_str()); // create a new answer literal
            s.add(implies(qi, F.arg(i)));
            qs.push_back(qi);
        }
    }
    // The solver s already contains p1 => F
    // To disable F, we add (not p1) as an additional assumption
    qs.push_back(!p1);
    std::cout << s.check(static_cast<unsigned>(qs.size()), &qs[0]) << "\n";
    expr_vector core2 = s.unsat_core();
    std::cout << core2 << "\n";
    std::cout << "size: " << core2.size() << "\n";
    for (unsigned i = 0; i < core2.size(); i++) {
        std::cout << core2[i] << "\n";
    }
}

/**
   \brief Unsat core example 3
*/
void unsat_core_example3() {
    // Extract unsat core using tracked assertions
    std::cout << "unsat core example 3\n";
    context c;
    expr x  = c.int_const("x");
    expr y  = c.int_const("y");
    solver s(c);

    // enabling unsat core tracking
    params p(c);
    p.set("unsat_core", true);
    s.set(p);

    // The following assertion will not be tracked.
    s.add(x > 0);

    // The following assertion will be tracked using Boolean variable p1.
    // The C++ wrapper will automatically create the Boolean variable.
    s.add(y > 0, "p1");

    // Asserting other tracked assertions.
    s.add(x < 10, "p2");
    s.add(y < 0,  "p3");

    std::cout << s.check() << "\n";
    std::cout << s.unsat_core() << "\n";
}

void tactic_example1() {
    /*
      Z3 implements a methodology for orchestrating reasoning engines where "big" symbolic
      reasoning steps are represented as functions known as tactics, and tactics are composed
      using combinators known as tacticals. Tactics process sets of formulas called Goals.

      When a tactic is applied to some goal G, four different outcomes are possible. The tactic succeeds
      in showing G to be satisfiable (i.e., feasible); succeeds in showing G to be unsatisfiable (i.e., infeasible);
      produces a sequence of subgoals; or fails. When reducing a goal G to a sequence of subgoals G1, ..., Gn,
      we face the problem of model conversion. A model converter construct a model for G using a model for some subgoal Gi.

      In this example, we create a goal g consisting of three formulas, and a tactic t composed of two built-in tactics:
      simplify and solve-eqs. The tactic simplify apply transformations equivalent to the ones found in the command simplify.
      The tactic solver-eqs eliminate variables using Gaussian elimination. Actually, solve-eqs is not restricted
      only to linear arithmetic. It can also eliminate arbitrary variables.
      Then, sequential composition combinator & applies simplify to the input goal and solve-eqs to each subgoal produced by simplify.
      In this example, only one subgoal is produced.
    */
    std::cout << "tactic example 1\n";
    context c;
    expr x = c.real_const("x");
    expr y = c.real_const("y");
    goal g(c);
    g.add(x > 0);
    g.add(y > 0);
    g.add(x == y + 2);
    std::cout << g << "\n";
    tactic t1(c, "simplify");
    tactic t2(c, "solve-eqs");
    tactic t = t1 & t2;
    apply_result r = t(g);
    std::cout << r << "\n";
}

void tactic_example2() {
    /*
      In Z3, we say a clause is any constraint of the form (f_1 || ... || f_n).
      The tactic split-clause will select a clause in the input goal, and split it n subgoals.
      One for each subformula f_i.
    */
    std::cout << "tactic example 2\n";
    context c;
    expr x = c.real_const("x");
    expr y = c.real_const("y");
    goal g(c);
    g.add(x < 0 || x > 0);
    g.add(x == y + 1);
    g.add(y < 0);
    tactic t(c, "split-clause");
    apply_result r = t(g);
    for (unsigned i = 0; i < r.size(); i++) {
        std::cout << "subgoal " << i << "\n" << r[i] << "\n";
    }
}

void tactic_example3() {
    /*
      - The choice combinator t | s first applies t to the given goal, if it fails then returns the result of s applied to the given goal.
      - repeat(t) Keep applying the given tactic until no subgoal is modified by it.
      - repeat(t, n) Keep applying the given tactic until no subgoal is modified by it, or the number of iterations is greater than n.
      - try_for(t, ms) Apply tactic t to the input goal, if it does not return in ms milliseconds, it fails.
      - with(t, params) Apply the given tactic using the given parameters.
    */
    std::cout << "tactic example 3\n";
    context c;
    expr x = c.real_const("x");
    expr y = c.real_const("y");
    expr z = c.real_const("z");
    goal g(c);
    g.add(x == 0 || x == 1);
    g.add(y == 0 || y == 1);
    g.add(z == 0 || z == 1);
    g.add(x + y + z > 2);
    // split all clauses
    tactic split_all = repeat(tactic(c, "split-clause") | tactic(c, "skip"));
    std::cout << split_all(g) << "\n";
    tactic split_at_most_2 = repeat(tactic(c, "split-clause") | tactic(c, "skip"), 1);
    std::cout << split_at_most_2(g) << "\n";
    // In the tactic split_solver, the tactic solve-eqs discharges all but one goal.
    // Note that, this tactic generates one goal: the empty goal which is trivially satisfiable (i.e., feasible)
    tactic split_solve = split_all & tactic(c, "solve-eqs");
    std::cout << split_solve(g) << "\n";
}

void tactic_example4() {
    /*
      A tactic can be converted into a solver object using the method mk_solver().
      If the tactic produces the empty goal, then the associated solver returns sat.
      If the tactic produces a single goal containing False, then the solver returns unsat.
      Otherwise, it returns unknown.

      In this example, the tactic t implements a basic bit-vector solver using equation solving,
      bit-blasting, and a propositional SAT solver.
      We use the combinator `with` to configure our little solver.
      We also include the tactic `aig` which tries to compress Boolean formulas using And-Inverted Graphs.
    */
    std::cout << "tactic example 4\n";
    context c;
    params p(c);
    p.set("mul2concat", true);
    tactic t =
        with(tactic(c, "simplify"), p) &
        tactic(c, "solve-eqs") &
        tactic(c, "bit-blast") &
        tactic(c, "aig") &
        tactic(c, "sat");
    solver s = t.mk_solver();
    expr x = c.bv_const("x", 16);
    expr y = c.bv_const("y", 16);
    s.add(x*32 + y == 13);
    // In C++, the operator < has higher precedence than &.
    s.add((x & y) < 10);
    s.add(y > -100);
    std::cout << s.check() << "\n";
    model m = s.get_model();
    std::cout << m << "\n";
    std::cout << "x*32 + y = " << m.eval(x*32 + y) << "\n";
    std::cout << "x & y    = " << m.eval(x & y) << "\n";
}

void tactic_example5() {
    /*
      The tactic smt wraps the main solver in Z3 as a tactic.
    */
    std::cout << "tactic example 5\n";
    context c;
    expr x = c.int_const("x");
    expr y = c.int_const("y");
    solver s = tactic(c, "smt").mk_solver();
    s.add(x > y + 1);
    std::cout << s.check() << "\n";
    std::cout << s.get_model() << "\n";
}

void tactic_example6() {
    /*
      In this example, we show how to implement a solver for integer arithmetic using SAT.
      The solver is complete only for problems where every variable has a lower and upper bound.
    */
    std::cout << "tactic example 6\n";
    context c;
    params p(c);
    p.set("arith_lhs", true);
    p.set("som", true); // sum-of-monomials normal form
    solver s =
        (with(tactic(c, "simplify"), p) &
         tactic(c, "normalize-bounds") &
         tactic(c, "lia2pb") &
         tactic(c, "pb2bv") &
         tactic(c, "bit-blast") &
         tactic(c, "sat")).mk_solver();
    expr x = c.int_const("x");
    expr y = c.int_const("y");
    expr z = c.int_const("z");
    s.add(x > 0 && x < 10);
    s.add(y > 0 && y < 10);
    s.add(z > 0 && z < 10);
    s.add(3*y + 2*x == z);
    std::cout << s.check() << "\n";
    std::cout << s.get_model() << "\n";
    s.reset();
    s.add(3*y + 2*x == z);
    std::cout << s.check() << "\n";
}

void tactic_example7() {
    /*
      Tactics can be combined with solvers.
      For example, we can apply a tactic to a goal, produced a set of subgoals,
      then select one of the subgoals and solve it using a solver.
      This example demonstrates how to do that, and
      how to use model converters to convert a model for a subgoal into a model for the original goal.
    */
    std::cout << "tactic example 7\n";
    context c;
    tactic t =
        tactic(c, "simplify") &
        tactic(c, "normalize-bounds") &
        tactic(c, "solve-eqs");
    expr x = c.int_const("x");
    expr y = c.int_const("y");
    expr z = c.int_const("z");
    goal g(c);
    g.add(x > 10);
    g.add(y == x + 3);
    g.add(z > y);
    apply_result r = t(g);
    // r contains only one subgoal
    std::cout << r << "\n";
    solver s(c);
    goal subgoal = r[0];
    for (unsigned i = 0; i < subgoal.size(); i++) {
        s.add(subgoal[i]);
    }
    std::cout << s.check() << "\n";
    model m = s.get_model();
    std::cout << "model for subgoal:\n" << m << "\n";
    std::cout << "model for original goal:\n" << subgoal.convert_model(m) << "\n";
}

void tactic_example8() {
    /*
      Probes (aka formula measures) are evaluated over goals.
      Boolean expressions over them can be built using relational operators and Boolean connectives.
      The tactic fail_if(cond) fails if the given goal does not satisfy the condition cond.
      Many numeric and Boolean measures are available in Z3.

      In this example, we build a simple tactic using fail_if.
      It also shows that a probe can be applied directly to a goal.
    */
    std::cout << "tactic example 8\n";
    context c;

    expr x = c.int_const("x");
    expr y = c.int_const("y");
    expr z = c.int_const("z");

    goal g(c);
    g.add(x + y + z > 0);

    probe p(c, "num-consts");
    std::cout << "num-consts: " << p(g) << "\n";

    tactic t = fail_if(p > 2);
    try {
        t(g);
    }
    catch (exception&) {
        std::cout << "tactic failed...\n";
    }
    std::cout << "trying again...\n";
    g.reset();
    g.add(x + y > 0);
    std::cout << t(g) << "\n";
}

void tactic_example9() {
    /*
      The combinator (tactical) cond(p, t1, t2) is a shorthand for:

      (fail_if(p) & t1) | t2

      The combinator when(p, t) is a shorthand for:

      cond(p, t, tactic(c, "skip"))

      The tactic skip just returns the input goal.
      This example demonstrates how to use the cond combinator.
    */
    std::cout << "tactic example 9\n";
    context c;

    expr x = c.int_const("x");
    expr y = c.int_const("y");
    expr z = c.int_const("z");

    goal g(c);
    g.add(x*x - y*y >= 0);

    probe p(c, "num-consts");
    tactic t = cond(p > 2, tactic(c, "simplify"), tactic(c, "factor"));
    std::cout << t(g) << "\n";

    g.reset();
    g.add(x + x + y + z >= 0);
    g.add(x*x - y*y >= 0);
    std::cout << t(g) << "\n";
}

void tactic_qe() {
    std::cout << "tactic example using quantifier elimination\n";
    context c;

    // Create a solver using "qe" and "smt" tactics
    solver s =
        (tactic(c, "qe") &
         tactic(c, "smt")).mk_solver();

    expr a = c.int_const("a");
    expr b = c.int_const("b");
    expr x = c.int_const("x");
    expr f = implies(x <= a, x < b);

    expr qf = forall(x, f);

    std::cout << qf << "\n";

    s.add(qf);
    std::cout << s.check() << "\n";
    std::cout << s.get_model() << "\n";
}

void visit(std::vector<bool>& visited, expr const & e) {
    if (visited.size() <= e.id()) {
        visited.resize(e.id()+1, false);
    }
    if (visited[e.id()]) {
        return;
    }
    visited[e.id()] = true;

    if (e.is_app()) {
        unsigned num = e.num_args();
        for (unsigned i = 0; i < num; i++) {
            visit(visited, e.arg(i));
        }
        // do something
        // Example: print the visited expression
        func_decl f = e.decl();
        std::cout << "application of " << f.name() << ": " << e << "\n";
    }
    else if (e.is_quantifier()) {
        visit(visited, e.body());
        // do something
    }
    else {
        assert(e.is_var());
        // do something
    }
}

void tst_visit() {
    std::cout << "visit example\n";
    context c;

    // only one of the occurrences of x*x is visited
    // because they are the same subterms
    expr x = c.int_const("x");
    expr y = c.int_const("y");
    expr z = c.int_const("z");
    expr f = x*x + x*x - y*y >= 0;
    std::vector<bool> visited;
    visit(visited, f);
}

void tst_numeral() {
    std::cout << "numeral example\n";
    context c;
    expr x = c.real_val("1/3");
    double d = 0;
    if (!x.is_numeral(d)) {
        std::cout << x << " is not recognized as a numeral\n";
        return;
    }
    std::cout << x << " is " << d << "\n";
}

void incremental_example1() {
    std::cout << "incremental example1\n";
    context c;
    expr x = c.int_const("x");
    solver s(c);
    s.add(x > 0);
    std::cout << s.check() << "\n";
    // We can add more formulas to the solver
    s.add(x < 0);
    // and, invoke s.check() again...
    std::cout << s.check() << "\n";
}

void incremental_example2() {
    // In this example, we show how push() and pop() can be used
    // to remove formulas added to the solver.
    std::cout << "incremental example2\n";
    context c;
    expr x = c.int_const("x");
    solver s(c);
    s.add(x > 0);
    std::cout << s.check() << "\n";
    // push() creates a backtracking point (aka a snapshot).
    s.push();
    // We can add more formulas to the solver
    s.add(x < 0);
    // and, invoke s.check() again...
    std::cout << s.check() << "\n";
    // pop() will remove all formulas added between this pop() and the matching push()
    s.pop();
    // The context is satisfiable again
    std::cout << s.check() << "\n";
    // and contains only x > 0
    std::cout << s << "\n";
}

void incremental_example3() {
    // In this example, we show how to use assumptions to "remove"
    // formulas added to a solver. Actually, we disable them.
    std::cout << "incremental example3\n";
    context c;
    expr x = c.int_const("x");
    solver s(c);
    s.add(x > 0);
    std::cout << s.check() << "\n";
    // Now, suppose we want to add x < 0 to the solver, but we also want
    // to be able to disable it later.
    // To do that, we create an auxiliary Boolean variable
    expr b = c.bool_const("b");
    // and, assert (b implies x < 0)
    s.add(implies(b, x < 0));
    // Now, we check whether s is satisfiable under the assumption "b" is true.
    expr_vector a1(c);
    a1.push_back(b);
    std::cout << s.check(a1) << "\n";
    // To "disable" (x > 0), we may just ask with the assumption "not b" or not provide any assumption.
    std::cout << s.check() << "\n";
    expr_vector a2(c);
    a2.push_back(!b);
    std::cout << s.check(a2) << "\n";
}

void enum_sort_example() {
    std::cout << "enumeration sort example\n";
    context ctx;
    const char * enum_names[] = { "a", "b", "c" };
    func_decl_vector enum_consts(ctx);
    func_decl_vector enum_testers(ctx);
    sort s = ctx.enumeration_sort("enumT", 3, enum_names, enum_consts, enum_testers);
    // enum_consts[0] is a func_decl of arity 0.
    // we convert it to an expression using the operator()
    expr a = enum_consts[0u]();
    expr b = enum_consts[1u]();
    expr x = ctx.constant("x", s);
    expr test = (x==a) && (x==b);
    std::cout << "1: " << test << std::endl;
    tactic qe(ctx, "ctx-solver-simplify");
    goal g(ctx);
    g.add(test);
    expr res(ctx);
    apply_result result_of_elimination = qe.apply(g);
    goal result_goal = result_of_elimination[0];
    std::cout << "2: " << result_goal.as_expr() << std::endl;
}

void tuple_example() {
    std::cout << "tuple example\n";
    context ctx;
    const char * names[] = { "first", "second" };
    sort sorts[2] = { ctx.int_sort(), ctx.bool_sort() };
    func_decl_vector projs(ctx);
    func_decl pair = ctx.tuple_sort("pair", 2, names, sorts, projs);
    sorts[1] = pair.range();
    func_decl pair2 = ctx.tuple_sort("pair2", 2, names, sorts, projs);

    std::cout << pair2 << "\n";
}

void datatype_example() {
    std::cout << "datatype example\n";
    context ctx;
    constructors cs(ctx);
    symbol ilist = ctx.str_symbol("ilist");
    symbol accs[2] = { ctx.str_symbol("hd"), ctx.str_symbol("tl") };
    sort sorts[2] = { ctx.int_sort(), ctx.datatype_sort(ilist) };
    cs.add(ctx.str_symbol("nil"), ctx.str_symbol("is-nil"), 0, nullptr, nullptr);
    cs.add(ctx.str_symbol("cons"), ctx.str_symbol("is-cons"), 2, accs, sorts);
    sort ls = ctx.datatype(ilist, cs);
    std::cout << ls << "\n";
    func_decl nil(ctx), is_nil(ctx);
    func_decl_vector nil_acc(ctx);
    cs.query(0, nil, is_nil, nil_acc);
    func_decl cons(ctx), is_cons(ctx);
    func_decl_vector cons_acc(ctx);
    cs.query(1, cons, is_cons, cons_acc);
    std::cout << nil << " " << is_nil << " " << nil_acc << "\n";
    std::cout << cons << " " << is_cons << " " << cons_acc << "\n";

    symbol tree = ctx.str_symbol("tree");
    symbol tlist = ctx.str_symbol("tree_list");
    symbol accs1[2] = { ctx.str_symbol("left"), ctx.str_symbol("right") };
    symbol accs2[2] = { ctx.str_symbol("hd"), ctx.str_symbol("tail") };
    sort sorts1[2] = { ctx.datatype_sort(tlist), ctx.datatype_sort(tlist) };
    sort sorts2[2] = { ctx.int_sort(), ctx.datatype_sort(tree) };
    constructors cs1(ctx), cs2(ctx);
    cs1.add(ctx.str_symbol("tnil"), ctx.str_symbol("is-tnil"), 0, nullptr, nullptr);
    cs1.add(ctx.str_symbol("tnode"), ctx.str_symbol("is-tnode"), 2, accs1, sorts1);
    constructor_list cl1(cs1);
    cs2.add(ctx.str_symbol("lnil"), ctx.str_symbol("is-lnil"), 0, nullptr, nullptr);
    cs2.add(ctx.str_symbol("lcons"), ctx.str_symbol("is-lcons"), 2, accs2, sorts2);
    constructor_list cl2(cs2);
    symbol names[2] = { tree, tlist };
    constructor_list* cl[2] = { &cl1, &cl2 };
    sort_vector dsorts = ctx.datatypes(2, names, cl);
    std::cout << dsorts << "\n";
    cs1.query(0, nil, is_nil, nil_acc);
    cs1.query(1, cons, is_cons, cons_acc);
    std::cout << nil << " " << is_nil << " " << nil_acc << "\n";
    std::cout << cons << " " << is_cons << " " << cons_acc << "\n";

    cs2.query(0, nil, is_nil, nil_acc);
    cs2.query(1, cons, is_cons, cons_acc);
    std::cout << nil << " " << is_nil << " " << nil_acc << "\n";
    std::cout << cons << " " << is_cons << " " << cons_acc << "\n";

}

void expr_vector_example() {
    std::cout << "expr_vector example\n";
    context c;
    const unsigned N = 10;

    expr_vector x(c);

    for (unsigned i = 0; i < N; i++) {
        std::stringstream x_name;
        x_name << "x_" << i;
        x.push_back(c.int_const(x_name.str().c_str()));
    }

    solver s(c);
    for (unsigned i = 0; i < N; i++) {
        s.add(x[i] >= 1);
    }

    std::cout << s << "\n" << "solving...\n" << s.check() << "\n";
    model m = s.get_model();
    std::cout << "solution\n" << m;
}

void exists_expr_vector_example() {
    std::cout << "exists expr_vector example\n";
    context c;
    const unsigned N = 10;

    expr_vector xs(c);
    expr x(c);
    expr b(c);
    b = c.bool_val(true);

    for (unsigned i = 0; i < N; i++) {
        std::stringstream x_name;
        x_name << "x_" << i;
        x = c.int_const(x_name.str().c_str());
        xs.push_back(x);
        b = b && x >= 0;
    }

    expr ex(c);
    ex = exists(xs, b);
    std::cout << ex << std::endl;
}

void substitute_example() {
    std::cout << "substitute example\n";
    context c;
    expr x(c);
    x = c.int_const("x");
    expr f(c);
    f = (x == 2) || (x == 1);
    std::cout << f << std::endl;

    expr two(c), three(c);
    two   = c.int_val(2);
    three = c.int_val(3);
    Z3_ast from[] = { two };
    Z3_ast to[]   = { three };
    expr new_f(c);
    new_f = to_expr(c, Z3_substitute(c, f, 1, from, to));

    std::cout << new_f << std::endl;
}

void opt_example() {
    context c;
    optimize opt(c);
    params p(c);
    p.set("priority",c.str_symbol("pareto"));
    opt.set(p);
    expr x = c.int_const("x");
    expr y = c.int_const("y");
    opt.add(10 >= x && x >= 0);
    opt.add(10 >= y && y >= 0);
    opt.add(x + y <= 11);
    optimize::handle h1 = opt.maximize(x);
    optimize::handle h2 = opt.maximize(y);
    while (true) {
        if (sat == opt.check()) {
            std::cout << x << ": " << opt.lower(h1) << " " << y << ": " << opt.lower(h2) << "\n";
        }
        else {
            break;
        }
    }
}

/**
 * translate from one optimization context to another.
 */
void opt_translate_example() {
    context c1, c2;
    optimize o1(c1);
    expr x = c1.int_const("x");
    expr y = c1.int_const("y");
    o1.add(10 >= x && x >= 0);
    o1.add(10 >= y && y >= 0);
    o1.add(x + y <= 11);
    optimize::handle h1 = o1.maximize(x);
    optimize::handle h2 = o1.maximize(y);
    (void)h1;
    (void)h2;
    optimize o2(c2, o1);
    expr z = c2.int_const("z");
    expr x2 = c2.int_const("x");
    o2.add(x2 + z == 2);
    o2.minimize(z);
    std::cout << o2 << "\n";
}

void extract_example() {
    std::cout << "extract example\n";
    context c;
    expr x(c);
    x = c.constant("x", c.bv_sort(32));
    expr y = x.extract(21, 10);
    std::cout << y << " " << y.hi() << " " << y.lo() << "\n";
}

void sudoku_example() {
    std::cout << "sudoku example\n";

    context c;

    // 9x9 matrix of integer variables
    expr_vector x(c);
    for (unsigned i = 0; i < 9; ++i)
        for (unsigned j = 0; j < 9; ++j) {
            std::stringstream x_name;

            x_name << "x_" << i << '_' << j;
            x.push_back(c.int_const(x_name.str().c_str()));
        }

    solver s(c);

    // each cell contains a value in {1, ..., 9}
    for (unsigned i = 0; i < 9; ++i)
        for (unsigned j = 0; j < 9; ++j) {
            s.add(x[i * 9 + j] >= 1 && x[i * 9 + j] <= 9);
        }

    // each row contains a digit at most once
    for (unsigned i = 0; i < 9; ++i) {
        expr_vector t(c);
        for (unsigned j = 0; j < 9; ++j)
            t.push_back(x[i * 9 + j]);
        s.add(distinct(t));
    }

    // each column contains a digit at most once
    for (unsigned j = 0; j < 9; ++j) {
        expr_vector t(c);
        for (unsigned i = 0; i < 9; ++i)
            t.push_back(x[i * 9 + j]);
        s.add(distinct(t));
    }

    // each 3x3 square contains a digit at most once
    for (unsigned i0 = 0; i0 < 3; i0++) {
        for (unsigned j0 = 0; j0 < 3; j0++) {
            expr_vector t(c);
            for (unsigned i = 0; i < 3; i++)
                for (unsigned j = 0; j < 3; j++)
                    t.push_back(x[(i0 * 3 + i) * 9 + j0 * 3 + j]);
            s.add(distinct(t));
        }
    }

    // sudoku instance, we use '0' for empty cells
    int instance[9][9] = {{0,0,0,0,9,4,0,3,0},
                          {0,0,0,5,1,0,0,0,7},
                          {0,8,9,0,0,0,0,4,0},
                          {0,0,0,0,0,0,2,0,8},
                          {0,6,0,2,0,1,0,5,0},
                          {1,0,2,0,0,0,0,0,0},
                          {0,7,0,0,0,0,5,2,0},
                          {9,0,0,0,6,5,0,0,0},
                          {0,4,0,9,7,0,0,0,0}};

    for (unsigned i = 0; i < 9; i++)
        for (unsigned j = 0; j < 9; j++)
            if (instance[i][j] != 0)
                s.add(x[i * 9 + j] == instance[i][j]);

    std::cout << s.check() << std::endl;
    std::cout << s << std::endl;

    model m = s.get_model();
    for (unsigned i = 0; i < 9; ++i) {
        for (unsigned j = 0; j < 9; ++j)
            std::cout << m.eval(x[i * 9 + j]);
        std::cout << '\n';
    }
}

void param_descrs_example() {
    std::cout << "parameter description example\n";
    context c;
    param_descrs p = param_descrs::simplify_param_descrs(c);
    std::cout << p << "\n";
    unsigned sz = p.size();
    for (unsigned i = 0; i < sz; ++i) {
        symbol nm = p.name(i);
        char const* kind = "other";
        Z3_param_kind k = p.kind(nm);
        if (k == Z3_PK_UINT) kind = "uint";
        if (k == Z3_PK_BOOL) kind = "bool";
        std::cout << nm << ": " << p.documentation(nm) << " kind: " << kind << "\n";
    }
}

void consequence_example() {
    std::cout << "consequence example\n";
    context c;
    expr A = c.bool_const("a");
    expr B = c.bool_const("b");
    expr C = c.bool_const("c");
    solver s(c);
    s.add(implies(A, B));
    s.add(implies(B, C));
    expr_vector assumptions(c), vars(c), consequences(c);
    assumptions.push_back(!C);
    vars.push_back(A);
    vars.push_back(B);
    vars.push_back(C);
    std::cout << s.consequences(assumptions, vars, consequences) << "\n";
    std::cout << consequences << "\n";
}

static void parse_example() {
    std::cout << "parse example\n";
    context c;
    sort_vector sorts(c);
    func_decl_vector decls(c);
    sort B = c.bool_sort();
    decls.push_back(c.function("a", 0, 0, B));
    expr_vector a = c.parse_string("(assert a)", sorts, decls);
    std::cout << a << "\n";

    // expr b = c.parse_string("(benchmark tst :extrafuns ((x Int) (y Int)) :formula (> x y) :formula (> x 0))");
}

static void parse_string() {
    std::cout << "parse string\n";
    z3::context c;
    z3::solver s(c);
    s.from_string("(declare-const x Int)(assert (> x 10))");
    std::cout << s.check() << "\n";
}

void mk_model_example() {
    context c;

    // construct empty model
    model m(c);

    // create constants "a", "b" and get their func_decl
    expr a = c.int_const("a");
    expr b = c.int_const("b");
    func_decl a_decl = a.decl();
    func_decl b_decl = b.decl();

    // create numerals to be used in model
    expr zero_numeral = c.int_val(0);
    expr one_numeral = c.int_val(1);

    // add assignment to model
    m.add_const_interp(a_decl, zero_numeral);
    m.add_const_interp(b_decl, one_numeral);

    // evaluate a + b < 2 in the model
    std::cout << m.eval(a + b < 2)<< std::endl;
}

void recfun_example() {
    std::cout << "recfun example\n";
    context c;
    expr x = c.int_const("x");
    expr y = c.int_const("y");
    expr b = c.bool_const("b");
    sort I = c.int_sort();
    sort B = c.bool_sort();
    func_decl f = recfun("f", I, B, I);
    expr_vector args(c);
    args.push_back(x); args.push_back(b);
    c.recdef(f, args, ite(b, x, f(x + 1, !b)));
    prove(f(x,c.bool_val(false)) > x);
}

static void string_values() {
    context c;
    std::cout << "string_values\n";
    expr s = c.string_val("abc\n\n\0\0", 7);
    std::cout << s << "\n";
    std::string s1 = s.get_string();
    std::cout << s1 << "\n";
    std::u32string buffer = s.get_u32string();
    for (unsigned ch : buffer)
        std::cout << "char: " << ch << "\n";
}

expr MakeStringConstant(context* context, std::string value) {
    return context->string_val(value.c_str());
}

expr MakeStringFunction(context* c, std::string s) {
    sort sort = c->string_sort();
    symbol name = c->str_symbol(s.c_str());
    return c->constant(name, sort);
}

static void string_issue_2298() {
    context c;
    solver s(c);
    s.push();
    expr func1 = MakeStringFunction(&c, "func1");
    expr func2 = MakeStringFunction(&c, "func2");

    expr abc = MakeStringConstant(&c, "abc");
    expr cde = MakeStringConstant(&c, "cde");

    expr length = func1.length();
    expr five = c.int_val(5);

    s.add(func2 == abc || func1 == cde);
    s.add(func2 == abc || func2 == cde);
    s.add(length <= five);

    s.check();
    s.pop();
}

void iterate_args() {
    std::cout << "iterate arguments\n";
    context c;
    expr x      = c.int_const("x");
    expr y      = c.int_const("y");
    sort I      = c.int_sort();
    func_decl g = function("g", I, I, I);
    expr e = g(x, y);
    std::cout << "expression " << e << "\n";
    for (expr arg : e)
        std::cout << "arg " << arg << "\n";

}


} // namespace z3_example


void test_01_z3_example(int, char* []) {
    using namespace z3_example;

    try {
        demorgan(); std::cout << "\n";
        find_model_example1(); std::cout << "\n";
        prove_example1(); std::cout << "\n";
        prove_example2(); std::cout << "\n";
        nonlinear_example1(); std::cout << "\n";
        bitvector_example1(); std::cout << "\n";
        bitvector_example2(); std::cout << "\n";
        capi_example(); std::cout << "\n";
        eval_example1(); std::cout << "\n";
        two_contexts_example1(); std::cout << "\n";
        error_example(); std::cout << "\n";
        numeral_example(); std::cout << "\n";
        ite_example(); std::cout << "\n";
        ite_example2(); std::cout << "\n";
        quantifier_example(); std::cout << "\n";
        unsat_core_example1(); std::cout << "\n";
        unsat_core_example2(); std::cout << "\n";
        unsat_core_example3(); std::cout << "\n";
        tactic_example1(); std::cout << "\n";
        tactic_example2(); std::cout << "\n";
        tactic_example3(); std::cout << "\n";
        tactic_example4(); std::cout << "\n";
        tactic_example5(); std::cout << "\n";
        tactic_example6(); std::cout << "\n";
        tactic_example7(); std::cout << "\n";
        tactic_example8(); std::cout << "\n";
        tactic_example9(); std::cout << "\n";
        tactic_qe(); std::cout << "\n";
        tst_visit(); std::cout << "\n";
        tst_numeral(); std::cout << "\n";
        incremental_example1(); std::cout << "\n";
        incremental_example2(); std::cout << "\n";
        incremental_example3(); std::cout << "\n";
        enum_sort_example(); std::cout << "\n";
        tuple_example(); std::cout << "\n";
        datatype_example(); std::cout << "\n";
        expr_vector_example(); std::cout << "\n";
        exists_expr_vector_example(); std::cout << "\n";
        substitute_example(); std::cout << "\n";
        opt_example(); std::cout << "\n";
        opt_translate_example(); std::cout << "\n";
        extract_example(); std::cout << "\n";
        param_descrs_example(); std::cout << "\n";
        sudoku_example(); std::cout << "\n";
        consequence_example(); std::cout << "\n";
        parse_example(); std::cout << "\n";
        parse_string(); std::cout << "\n";
        mk_model_example(); std::cout << "\n";
        recfun_example(); std::cout << "\n";
        string_values(); std::cout << "\n";
        string_issue_2298(); std::cout << "\n";
	iterate_args(); std::cout << "\n";
        std::cout << "done\n";
    }
    catch (exception & ex) {
        std::cout << "unexpected error: " << ex << "\n";
    }
    Z3_finalize_memory();
}

// ref: https://developers.google.com/optimization/introduction/cpp
// Minimal example to call the GLOP solver.
#include <cstdlib>
#include <memory>

#include <absl/flags/flag.h>
#include <absl/log/flags.h>
#include <ortools/base/init_google.h>
#include <ortools/base/logging.h>
#include <ortools/init/init.h>
#include <ortools/linear_solver/linear_solver.h>

namespace operations_research {
void BasicExample() {
  LOG(INFO) << "Google OR-Tools version : " << OrToolsVersion::VersionString();

  // Create the linear solver with the GLOP backend.
  std::unique_ptr<MPSolver> solver(MPSolver::CreateSolver("GLOP"));
  if (!solver) {
    LOG(WARNING) << "Could not create solver GLOP";
    return;
  }

  // Create the variables x and y.
  MPVariable* const x = solver->MakeNumVar(0.0, 1, "x");
  MPVariable* const y = solver->MakeNumVar(0.0, 2, "y");

  LOG(INFO) << "Number of variables = " << solver->NumVariables();

  // Create a linear constraint, x + y <= 2.
  const double infinity = solver->infinity();
  MPConstraint* const ct = solver->MakeRowConstraint(-infinity, 2.0, "ct");
  ct->SetCoefficient(x, 1);
  ct->SetCoefficient(y, 1);

  LOG(INFO) << "Number of constraints = " << solver->NumConstraints();

  // Create the objective function, 3 * x + y.
  MPObjective* const objective = solver->MutableObjective();
  objective->SetCoefficient(x, 3);
  objective->SetCoefficient(y, 1);
  objective->SetMaximization();

  LOG(INFO) << "Solving with " << solver->SolverVersion();
  const MPSolver::ResultStatus result_status = solver->Solve();

  // Check that the problem has an optimal solution.
  LOG(INFO) << "Status: " << result_status;
  if (result_status != MPSolver::OPTIMAL) {
    LOG(INFO) << "The problem does not have an optimal solution!";
    if (result_status == MPSolver::FEASIBLE) {
      LOG(INFO) << "A potentially suboptimal solution was found";
    } else {
      LOG(WARNING) << "The solver could not solve the problem.";
      return;
    }
  }

  LOG(INFO) << "Solution:";
  LOG(INFO) << "Objective value = " << objective->Value();
  LOG(INFO) << "x = " << x->solution_value();
  LOG(INFO) << "y = " << y->solution_value();

  LOG(INFO) << "Advanced usage:";
  LOG(INFO) << "Problem solved in " << solver->wall_time() << " milliseconds";
  LOG(INFO) << "Problem solved in " << solver->iterations() << " iterations";
}
}  // namespace operations_research

void test_01_or_tools_basic_example(int argc, char *argv[]) {
  InitGoogle(argv[0], &argc, &argv, true);
  absl::SetFlag(&FLAGS_stderrthreshold, 0);
  operations_research::BasicExample();
}

#include <iostream>
#include <Eigen/Dense>

using namespace Eigen;

// ref: https://qiita.com/shiro-kuma/items/0faa02aa064a3c0a460b
void test_01_eigen_nearest_neighbor(int, char* []) {
  Eigen::MatrixXf m(2,4);
  Eigen::VectorXf v(2);

  m << 1, 23, 6, 9,
       3, 11, 7, 2;

  v << 2,
       3;

  MatrixXf::Index index;
  (m.colwise() - v).colwise().squaredNorm().minCoeff(&index);

  std::cout << "Nearest neighbor is column " << index << ":" << std::endl;
  std::cout << m.col(index) << std::endl;
}

// ref: https://pytorch.org/cppdocs/installing.html

#ifdef __clang__


#pragma message("skipped")

void test_01_libtorch_tensor_rand(int, char* []) {}


#else


#include <torch/torch.h>
#include <iostream>

void test_01_libtorch_tensor_rand(int, char* []) {
  torch::Tensor tensor = torch::rand({2, 3});
  std::cout << tensor << std::endl;
}


#endif

#include <time.h>
#include <gmp.h>

void test_01_gmp_mpz(int, char* []) {
    mpz_t a;
    mpz_init(a);

    gmp_randstate_t state;
    gmp_randinit_default(state);

    time_t rtime;
    time(&rtime);
    gmp_randseed_ui(state, rtime);

    mpz_urandomb(a, state, 256);

    gmp_printf("%Zx\n", a);

    mpz_clear(a);
    gmp_randclear(state);
}

#include <print>
#include <atcoder/modint>

void test_01_ac_library_modint(int, char* []) {
    std::println("{}", atcoder::modint998244353(2).pow(10000).val());
}

#include <print>
#include <LightGBM/c_api.h>

void test_01_light_gbm_set_max_threads(int, char* []) {
    std::println("{}", LGBM_SetMaxThreads(2));
}

// ref: https://abseil.io/docs/cpp/quickstart-cmake#creating-your-test-code
#include <print>
#include <string>
#include <vector>
#include <absl/strings/str_join.h>

void test_01_abseil_str_join(int, char* []) {
  const std::vector<std::string> v = {"foo", "bar", "baz"};
  const auto s = absl::StrJoin(v, "-");

  println("{}", s);
}

import std.compat;

void test_00_plane_modules_std_compat(int, char* []) {
    std::println("{}", "Hello, import std.compact.");
}

import std;

void test_00_plane_modules_std(int, char* []) {
    std::println("{}", "Hello, import std.");
}

int main(int argc, char* argv[]) {
test_01_boost_stacktrace(argc, argv);
test_01_boost_rational(argc, argv);
test_00_plane_library_construct_with_iterator_pair(argc, argv);
test_00_plane_library_flat_map(argc, argv);
test_00_plane_library_simd(argc, argv);
test_00_plane_library_stacktrace(argc, argv);
test_00_plane_library_mdspan(argc, argv);
test_00_plane_library_spanstream(argc, argv);
test_00_plane_library_to_underlying(argc, argv);
test_00_plane_library_ranges_cartesian_product_view(argc, argv);
test_00_plane_library_ranges_as_rvalue_view(argc, argv);
test_00_plane_library_ranges_stride_view(argc, argv);
test_00_plane_library_ranges_zip_view(argc, argv);
test_00_plane_library_ranges_chunk_by_view(argc, argv);
test_00_plane_library_ranges_to(argc, argv);
test_00_plane_library_ranges_join_with_view(argc, argv);
test_00_plane_library_ranges_repeate_view(argc, argv);
test_00_plane_library_ranges_slide_view(argc, argv);
test_00_plane_library_ranges_chunk_view(argc, argv);
test_00_plane_library_ranges_range_fold_algorithms(argc, argv);
test_00_plane_library_ranges_enumerate_view(argc, argv);
test_00_plane_library_float128_t(argc, argv);
test_00_plane_library_contains(argc, argv);
test_00_plane_library_flat_set(argc, argv);
test_00_plane_library_expected(argc, argv);
test_00_plane_library_generator(argc, argv);
test_00_plane_library_is_scoped_enum(argc, argv);
test_00_plane_library_println(argc, argv);
test_00_plane_misc_bits_stdcxx_h(argc, argv);
test_00_plane_language_if_consteval(argc, argv);
test_00_plane_language_attributes_on_lambda_expressions(argc, argv);
test_00_plane_language_labels_at_the_end_of_compound_statements(argc, argv);
test_00_plane_language_non_const_evaluated_constexpr_function(argc, argv);
test_00_plane_language_consteval_conditionally_makes_constexpr_function_consteval(argc, argv);
test_00_plane_language_generalized_wording_for_partial_specializations(argc, argv);
test_00_plane_language_portable_assumptions(argc, argv);
test_00_plane_language_static_operator(argc, argv);
test_00_plane_language_literal_suffix_for_size_t(argc, argv);
test_00_plane_language_narrowing_contextual_conversions_to_bool(argc, argv);
test_00_plane_language_elifdef_and_elifndef_and_warning(argc, argv);
test_00_plane_language_static_constexpr_variables_in_constexpr_functions(argc, argv);
test_00_plane_language_lambda_expressions_with_parentheses_omitted(argc, argv);
test_00_plane_language_alias_declaration_in_init_statement(argc, argv);
test_00_plane_language_life_extension_in_range_based_for_loop(argc, argv);
test_00_plane_language_non_literal_variables_and_labels_and_gotos_in_constexpr_functions(argc, argv);
test_00_plane_language_named_universal_character_escapes(argc, argv);
test_00_plane_language_simpler_implicit_move(argc, argv);
test_00_plane_language_wording_for_class_template_argument_deduction_from_inherited_constructors(argc, argv);
test_00_plane_language_deducing_this(argc, argv);
test_02_other_starts_with(argc, argv);
test_01_open_mp_get_max_threads(argc, argv);
test_01_range_v3_mixed(argc, argv);
test_01_range_v3_for_each(argc, argv);
test_01_unordered_dense_map(argc, argv);
test_01_z3_example(argc, argv);
test_01_or_tools_basic_example(argc, argv);
test_01_eigen_nearest_neighbor(argc, argv);
test_01_libtorch_tensor_rand(argc, argv);
test_01_gmp_mpz(argc, argv);
test_01_ac_library_modint(argc, argv);
test_01_light_gbm_set_max_threads(argc, argv);
test_01_abseil_str_join(argc, argv);
test_00_plane_modules_std_compat(argc, argv);
test_00_plane_modules_std(argc, argv);
}
