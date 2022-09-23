# This file is a part of InverseFunctions.jl, licensed under the MIT License (MIT).


"""
    struct FunctionWithInverse{F,InvF}::Function

A function with an inverse.

Do not construct directly, use [`setinverse(f, invf)`](@ref) instead.
"""
struct FunctionWithInverse{F,InvF} <: Function
    f::F
    invf::InvF
end


(f::FunctionWithInverse)(x) = f.f(x)

inverse(f::FunctionWithInverse) = FunctionWithInverse(f.invf, f.f)


"""
    setinverse(f, invf)::Function

Returns a function that behaves like `f` and uses `invf` it implement its
inverse.

Useful in cases where no inverse is defined for `f` or to set an inverse that
is only valid within a given context, e.g. for only for a limited argument
range that is guaranteed by the use case but not in general.

For example, `asin` not is a valid inverse of `sin` for arbitrary arguments
of `sin`, but can be a valid inverse if the use case guarantees that the
argument of `sin` will always be within `-π` and `π`:

```jldoctest
julia> foo = setinverse(sin, asin);

julia> x = π/3;

julia> foo(x) == sin(x)
true

julia> inverse(foo)(foo(x)) ≈ x
true

julia> inverse(foo) === setinverse(asin, sin)
true
```
"""
function setinverse end
export setinverse

setinverse(f, invf) = FunctionWithInverse(f, invf)
setinverse(f::FunctionWithInverse, invf) = FunctionWithInverse(f.f, invf)
setinverse(f, invf::FunctionWithInverse) = FunctionWithInverse(f, invf.f)
setinverse(f::FunctionWithInverse, invf::FunctionWithInverse) = FunctionWithInverse(f.f, invf.f)
