C++
===
- No class can access private variables. Not even subclasses.
- Only subclasses can access protected variables.
- All classes can access public variables.

Features/Concepts
-----------------
* inline static intialization of class variables
* constexpr compile-time constants
* template metaprogramming (TMP)
* templated alias declarations with using keyword
* variadic templates `template <typename T, typename... Args> T func(T, Args...);`
* variadic arguments `int printx(const char* fmt, ...);`
* pure virtual functions (abstract classes)
* lambdas
* clang80cxx17 > gcc8cxx17

* `std::true_type`, `std::false_type`
* `std::is_same`, `std::conditional`
* `std::variant`
* `static_assert(std::is_base_of<A, B>::value, "")`
* `static_cast`
	- performs implicit conversions
	- and (possibly unsafe) base to derived conversions
	- one very common case is CRTP:
	```
	template <class Derived>
	class Base {
	    Derived& Self() { return *static_cast<Derived*>(this); }
	    // ...
	};
	class Foo : Base<Foo> { ... };
	```

* `reinterpret_cast`
	- (use sparingly) turns one type directly into another

* `std::move`
	- unconditional cast to an r-value reference of the given type
	```
	std::string s;
	std::move(s);  // unconditional cast to std::string &&
	```

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
	- old-style enums do not have their own scope and are called "unscoped enums"
	- strongly typed enums are called "scoped enums"

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


Good practices
--------------

(see compiler generated code on CEX - https://godbolt.org/)

* auto
	- Good to use
	- Does not coerce types, preventing implicit conversions

* Constants (`static` if lifetime is same as program)
	* Compile-time (`constexpr` or `enums` - scoped/unscoped)
	* Run-time (`const`)

	- `static constexpr` is preferred over `static const`
		- `static constexpr` allows compiler optimizations which plain `static` may not
	- `const` everything
		- forces to use more organized code
		- prevents common code errors
		- encourages more use of algorithms (std::array, <numeric>, <algorithm>)
		- except: do not return const values, as they break move semantics

* Use (algorithms & lambdas) over raw loops as the former express intent

* Avoid raw pointers and explicit memory (de)allocations using new / delete

* `const_cast` is a code smell as it'd be UB if const is cast away and mutation happens

* `static const` and `extern const` are code smells - use `static constexpr` instead of former and `constexpr` for the latter

* Variables (and members) should be `const` unless marked mutable, functions should be `noexcept` unless marked except.

* `explicit` keyword can be used for constructors to disallow implicit conversion constructor from being invoked.

* explicitly deleted functions and defaulted functions in C++11
	```
	class A {
	public:
	    A() = default;  // compiler will generate efficient default implementation
	    A(const A&) = delete;  // delete the copy constructor
	    A& operator=(const A&) = delete;  // delete the copy assignment operator
	};
	```

* static accumulate
	```
	template <typename T>
	constexpr T static_accumulate(size_t idx, const T* arr)
	{
	    return idx > 0 ? arr[idx] + static_accumulate(idx - 1, arr) : arr[0];
	}
	#define STATIC_ACCUMULATE(X) (static_accumulate(sizeof(X) / sizeof(*X), (X)))
	```

* union and struct bitfields
	```
    union Attributes
    {
        unsigned char bitfield;
        struct
        {
            unsigned char a : 3;  // bitfield declaration
            unsigned char b : 2;
            unsigned char c : 1;
            unsigned char d : 1;
            unsigned char e : 1;
        };
    };
    ```

* anonymous namespaces (`namespace { ... }`) can be used to declare unique identifiers without making them global static. The variables enclosed in an anonymous namespace can only be accessed within the file in which the namespace was created.

Miscellaneous
-------------
* alignment, padding, packing
	* Packing
		- `__attribute__((packed))` tells the compiler to minimize the struct size (ie not insert any padding between the members of the struct).
		- `#pragma pack(push, 1)` and `#pragma pack(pop)` may also be used for the same purpose. They're originally introduced by VC++.
			- `#pragma pack(n)` simply sets the new alignment (where n is the alignment in bytes, valid values being 1, 2, 4, 8 (default), 16)
			- `#pragma pack(push[,n])` pushes the current alignment to (internal) stack and then optionally sets the new alignment.
			- `#pragma pack(pop)` pops the current alignment and sets it as the new alignment.
	* Alignment
		- `__attribute__((aligned(16)))` for Uint128/Int128 struct use-case.

	_When to use pragma pack: https://stackoverflow.com/a/7823632/10960444_
	_Note:
	1. `packed` means it will use the smallest possible space for `struct` - i.e. it will cram fields together without padding.
	2. `aligned(4)` means each `struct` will begin on a 4 byte boundary - i.e. for any `struct`, its address will be divisible by 4.
	These are GCC extensions, not part of any C standard._

* boost::mpl (metaprogramming library): https://www.boost.org/doc/libs/1_45_0/libs/mpl/doc/refmanual.pdf

* GCC (GNU Compiler Collection) supports zero-length arrays to represent flexible arrays.  A zero-length array can be useful as the last element of a structure that is really a header for a variable-length object:
	```
	struct line {
	  int length;
	  char contents[0];  // or char contents[]; -- called flexible array member
	};
	struct line *thisline = (struct line *)
	  malloc (sizeof (struct line) + this_length);
	thisline->length = this_length;
	```
	_if zero-length is not supported by the compiler, `char contents[1]` can be used to makeshift._
