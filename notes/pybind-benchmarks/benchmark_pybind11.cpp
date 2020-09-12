#include "benchmark.h"

#include <pybind11/pybind11.h>
#include <pybind11/stl.h>

namespace py = pybind11;

namespace twr {

class Pybind11Listener : public Listener
{
public:
    void callback(uint64_t number) override
    {
        PYBIND11_OVERLOAD_PURE(void,     /* Return type */
                               Listener, /* Parent class */
                               callback, /* Name of function in C++ (must match Python name) */
                               number    /* Argument(s) */
                               );
    }
};

}  // namespace twr

PYBIND11_MODULE(benchmark_pybind11, module)
{
    module.def("get_string_hash", &twr::get_string_hash);
    module.def("get_number_range", &twr::get_number_range);

    py::class_<twr::Listener, twr::Pybind11Listener>(module, "Listener")
        .def(py::init<>())
        .def("callback", &twr::Listener::callback);
    module.def("callback", &twr::callback);
}

