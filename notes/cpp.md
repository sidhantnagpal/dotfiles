C++
===
- No class can access private variables. Not even subclasses.
- Only subclasses can access protected variables.
- All classes can access public variables.

Features/Concepts
-----------------
* inline static intialization of class variables
* constexpr compile-time constants (unlike const)
* templated alias declarations with using keyword
* variadic templates
* variadic arguments
* template metaprogramming (TMP)
* pure virtual functions (abstract classes)
* lambdas
* clang80cxx17 > gcc8cxx17

* `std::true_type`, `std::false_type`
* `std::string_view`
* `std::is_same`, `std::conditional`
* `std::variant`
* `static_assert(std::is_base_of<A, B>::value, "")`
* `static_cast`
	- performs implicit conversions
	- and (possibly unsafe) base to derived conversions
* `reinterpret_cast`
	- (use sparingly) turns one type directly into another

* smart pointers (avoid use of new / delete altogether, transfer ownership using `std::move`)
	* `std::unique_ptr`, `std::make_unique`
	* `std::shared_ptr` (reference counting), `std::make_shared`
	* both the above smart pointers support * and -> operators like raw pointers in addition to `.get()`, `.reset()`, `.release()`
	* `std::shared_ptr<void>` can be used for golang-like defer in C++
		- see https://stackoverflow.com/a/33055669
		- see https://www.boost.org/doc/libs/1_59_0/libs/smart_ptr/sp_techniques.html#handle

* use dynamically allocated arrays (memory claimed from heap)
	- VLAs (variable length arrays) are claimed from function stack and should be avoided
		* The argument is, if you know the size beforehand, you can use a static array. And if you don't know the size beforehand, you will write unsafe code.
		* eg.
```
void foo(int n) {
    int values[n]; // declare a variable length array - unsafe
}
```
	- dynamic allocation
```
 Feature                  | new/delete                     | malloc/free
--------------------------+--------------------------------+-------------------------------
 Memory allocated from    | 'Free Store'                   | 'Heap'
 Returns                  | Fully typed pointer            | void*
 On failure               | Throws (never returns NULL)    | Returns NULL
 Required size            | Calculated by compiler         | Must be specified in bytes
 Handling arrays          | Has an explicit version        | Requires manual calculations
 Reallocating             | Not handled intuitively        | Simple (no copy constructor)
 Call of reverse          | Implementation defined         | No
 Low memory cases         | Can add a new memory allocator | Not handled by user code
 Overridable              | Yes                            | No
 Use of (con-)/destructor | Yes                            | No
```

* strongly typed enums (over the old-style enums)
	- old-style enums do not have their own scope

```
enum Animals {Bear, Cat, Chicken};
enum Birds {Eagle, Duck, Chicken}; // error! Chicken has already been declared!

enum class Fruits { Apple, Pear, Orange };
enum class Colours { Blue, White, Orange }; // no problem!
```
	- old-style enums implicitly convert to integral types, which can lead to strange behavior
```
enum class Foo : char { A, B, C};
```

* C++ allows the following types of templates:
	- template parameters
	```
	template <typename T>
	void func();
	```
	- template template parameters
	```
	template <typename T, template <typename, typename> class U>
	void func();
	```

Advanced Concepts
-----------------
* RAII (Resource Acquisition is Initialization) idiom
	- Intent: To guarantee the release of resource(s) at the end of a scope.
	- Implementation: Wrap resource into a class; resource acquired in the constructor immediately after its allocation; and automatically released in the destructor; resource used via an interface of the class;
	- AKA: Scope-bound resource management

* Named Constructor idiom
	- Intent: safer construction
	- Implementation: private/protected constructors called through static methods

* Virtual Constructor idiom
	- AKA: Factory Pattern
	- Intent: To create a copy or new object without knowing its concrete type.

* Return Type Resolver
	- AKA: Return type overloading
	- Implementation: Uses templatized conversion operator and `if constexpr`.
```
class from_string
{
    const string m_str;
public:
    from_string(const char *str) : m_str(str) {}
    template <typename type>
    operator type(){
        if constexpr(is_same_v<type, float>)   return stof(m_str);
        else if constexpr(is_same_v<type, int>)return stoi(m_str);
    }
};
int n_int = from_string("123");
float n_float = from_string("123.111");
// Will only work with C++17 due to `is_same_v` (also see `is_same_t`)
```

* Type Erasure
	- AKA: Duck-typing
	- Intent: To create generic container that can handle a variety of concrete types.
	- Implementation:
		* void* (not safe)
		* templates (may increase compile-time due to template instantiations)
		* runtime polymorphism using virtual functions (run-time cost due to dynamic dispatch, indirection, vtable, etc.)
		* std::any
		* std::variant (type-safe union)
		* std::optional (can represent nullable type)

* CRTP (Curiously Recurring Template Pattern)
	- AKA: Static Polymorphism
	- Implementation: Base class template specialization

* SFINAE (Substitution Failure Is Not An Error)
	- Intent: To filter out functions that do not yield valid template instantiations from a set of overloaded functions.
	- Implementation: Achieved automatically by compiler or exploited using `std::enable_if`.
	- Use-case: Template Metaprogramming (TMP)
