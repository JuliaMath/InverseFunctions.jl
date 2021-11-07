# This file is a part of InverseFunctions.jl, licensed under the MIT License (MIT).

"""
    inverse(f)

Return the inverse of function `f`.

`inverse` supports mapped and broadcasted functions (via `Base.Fix1`) and
function composition (requires Julia >= 1.6).

# Examples

```jldoctest
julia> foo(x) = inv(exp(-x) + 1);

julia> inv_foo(y) = log(y / (1 - y));

julia> InverseFunctions.inverse(::typeof(foo)) = inv_foo;

julia> InverseFunctions.inverse(::typeof(inv_foo)) = foo;

julia> x = 4.2;

julia> inverse(foo)(foo(x)) ≈ x
true

julia> inverse(inverse(foo)) === foo
true

julia> broadcast_foo = Base.Fix1(broadcast, foo);

julia> X = rand(10);

julia> inverse(broadcast_foo)(broadcast_foo(X)) ≈ X
true

julia> bar = log ∘ foo;

julia> VERSION < v"1.6" || inverse(bar)(bar(x)) ≈ x
true
```

# Implementation

Implementations of `inverse(::typeof(f))` have to satisfy

* `inverse(f)(f(x)) ≈ x` for all `x` in the domain of `f`, and
* `inverse(inverse(f))` is defined and `inverse(inverse(f))(x) ≈ f(x)` for all `x` in the domain of `f`.

You can check your implementation with [`InverseFunctions.test_inverse`](@ref).
"""
inverse(f)
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

inverse(::typeof(sqrt)) = square
inverse(::typeof(square)) = sqrt
