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

!!! note
    On Julia >= 1.9, you have to load the `Test` standard library to be able to use
    this function.
"""
function test_inverse(f, x; kwargs...)
    hasmethod(_test_inverse, Tuple{Any,Any}) || throw(ArgumentError(
        "InverseFunctions.test_inverse requires the Test standard library: `using Test`."
    ))
    return _test_inverse(f, x; kwargs...)
end

# implemented by InverseFunctionsTestExt
function _test_inverse end

@static if !isdefined(Base, :get_extension)
    include("../ext/InverseFunctionsDatesExt.jl")
    include("../ext/InverseFunctionsTestExt.jl") 
end

end # module
