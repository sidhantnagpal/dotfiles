#include "benchmark.h"

#include <boost/python.hpp>
#include <boost/python/call.hpp>
#include <boost/python/class.hpp>
#include <boost/python/suite/indexing/vector_indexing_suite.hpp>
#include <boost/python/wrapper.hpp>

namespace bp = boost::python;

namespace twr {

class ListenerWrap : public Listener, public bp::wrapper<Listener>
{
public:
    void callback(uint64_t number) { this->get_override("callback")(number); }
};

}  // namespace twr

BOOST_PYTHON_MODULE(benchmark_boost)
{
    bp::def("get_string_hash", &twr::get_string_hash);

    bp::class_<std::vector<uint32_t> >("Uint32Vec")
        .def(bp::vector_indexing_suite<std::vector<uint32_t> >());
    bp::def("get_number_range", &twr::get_number_range);

    bp::class_<twr::ListenerWrap, boost::noncopyable>("Listener", bp::init<>())
        .def("callback", bp::pure_virtual(&twr::Listener::callback));
    bp::def("callback", &twr::callback);
}
