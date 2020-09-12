import timeit
import benchmark_pybind11
import benchmark_boost
# import faulthandler

# faulthandler.enable()

print('get_string_hash[pybind11] {}'.format(
    timeit.timeit(
        lambda: benchmark_pybind11.get_string_hash('Hello World!' * 125),
        number=1000000)))
print('get_string_hash[boost] {}'.format(
    timeit.timeit(
        lambda: benchmark_boost.get_string_hash('Hello World!' * 125),
        number=1000000)))

print('get_number_range[pybind11] {}'.format(
    timeit.timeit(lambda: list(benchmark_pybind11.get_number_range(32)),
                  number=1000000)))
print('get_number_range[boost] {}'.format(
    timeit.timeit(lambda: list(benchmark_boost.get_number_range(32)),
                  number=1000000)))

class Pybind11Listener(benchmark_pybind11.Listener):
    def __init__(self):
        benchmark_pybind11.Listener.__init__(self)

    def callback(self, number):
        pass


class BoostListener(benchmark_boost.Listener):
    def __init__(self):
        benchmark_boost.Listener.__init__(self)

    def callback(self, number):
        pass

print('callback[pybind11] {}'.format(
    timeit.timeit(lambda: benchmark_pybind11.callback(Pybind11Listener(), 0xD),
                  number=1000000)))
print('callback[boost] {}'.format(
    timeit.timeit(lambda: benchmark_boost.callback(BoostListener(), 0xD),
                  number=1000000)))
