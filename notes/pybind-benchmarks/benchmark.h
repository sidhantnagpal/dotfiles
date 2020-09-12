#pragma once

#include <cstddef>
#include <cstdint>
#include <functional>
#include <iterator>
#include <numeric>
#include <string>
#include <vector>

namespace twr {

inline size_t get_string_hash(const std::string& bytes)
{
    return std::hash<std::string>()(bytes);
}

inline std::vector<uint32_t> get_number_range(std::size_t n)
{
    std::vector<uint32_t> number_range(n);
    std::iota(std::begin(number_range), std::end(number_range), 0);
    return number_range;
}

class Listener
{
public:
    virtual ~Listener()                    = default;
    virtual void callback(uint64_t number) = 0;
};

inline void callback(Listener* listener, uint64_t number)
{
    return listener->callback(number);
}

}  // namespace twr
