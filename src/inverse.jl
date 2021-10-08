# This file is a part of InverseFunctions.jl, licensed under the MIT License (MIT).


"""
    inverse(f)

Returns the inverse of a function `f`.

The following conditions must be satisfied:

* `inverse(f) ∘ f` must be equivalent to `identity`.
* `inverse(f)(f(x)) ≈ x`
* `inverse(inverse(f))` must be equivalent (ideally identical) to `f`.

`inverse` supports mapped/broadcasted functions (via `Base.Fix1`) and (on
Julia >=v1.6) function composition.


Example:

```julia
foo(x) = inv(exp(-x) + 1)
inv_foo(y) = log(y / (1 - y))

InverseFunctions.inverse(::typeof(foo)) = inv_foo
InverseFunctions.inverse(::typeof(inv_foo)) = foo

x = 4.2
@assert inverse(foo)(foo(x)) ≈ x
@assert inverse(inverse(foo)) == foo

X = rand(10)
broadcasted_foo = Base.Fix1(broadcast, foo)
Y = broadcasted_foo(X)
@assert inverse(broadcasted_foo)(Y) ≈ X

# Requires Julia >= v1.6:
bar = log ∘ foo
@assert inverse(bar)(bar(x)) ≈ x
```
"""
function inverse end
export inverse


inverse(::typeof(inverse)) = inverse

@static if VERSION >= v"1.6"
    inverse(f::Base.ComposedFunction) = Base.ComposedFunction(inverse(f.inner), inverse(f.outer))
end

inverse(mapped_f::Base.Fix1{<:Union{typeof(map),typeof(broadcast)}}) = Base.Fix1(mapped_f.f, inverse(mapped_f.x))

inverse(::typeof(identity)) = identity
inverse(::typeof(inv)) = inv
inverse(::typeof(adjoint)) = adjoint
inverse(::typeof(transpose)) = transpose


inverse(::typeof(exp)) = log
inverse(::typeof(log)) = exp

inverse(::typeof(exp2)) = log2
inverse(::typeof(log2)) = exp2

inverse(::typeof(exp10)) = log10
inverse(::typeof(log10)) = exp10

inverse(::typeof(expm1)) = log1p
inverse(::typeof(log1p)) = expm1
