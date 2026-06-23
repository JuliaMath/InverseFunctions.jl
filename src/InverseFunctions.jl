# This file is a part of InverseFunctions.jl, licensed under the MIT License (MIT).
"""
    InverseFunctions

Lightweight package that defines an interface to invert functions.
"""
module InverseFunctions

include("functions.jl")
include("inverse.jl")
include("setinverse.jl")

"""
    InverseFunctions.test_inverse(f, x; compare=isapprox, kwargs...)

Test if [`inverse(f)`](@ref) is implemented correctly.

The function tests (as a `Test.@testset`) if

* `compare(inverse(f)(f(x)), x) == true` and
* `compare(inverse(inverse(f))(x), f(x)) == true`.

`kwargs...` are forwarded to `compare`.

!!! Note
    On Julia >= 1.9, you have to load the `Test` standard library to be able to use
    this function.
"""
function test_inverse(args...; kwargs...)
    length(args) == 2 || throw(MethodError(test_inverse, args))
    throw(ArgumentError("InverseFunctions.test_inverse requires the Test standard library. Did you forget to load Test?"))
end

@static if !isdefined(Base, :get_extension)
    include("../ext/InverseFunctionsDatesExt.jl")
    include("../ext/InverseFunctionsTestExt.jl")
end

end # module
