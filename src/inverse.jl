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



"""
    struct NoInverse{F}

An instance `NoInverse(f)` signifies that `inverse(f)` is not defined.
"""
struct NoInverse{F}
    f::F
end
export NoInverse

(f::NoInverse)(x) = error("inverse of ", f.f, " is not defined")

inverse(f) = NoInverse(f)

inverse(f::NoInverse) = f.f



inverse(::typeof(inverse)) = inverse

@static if VERSION >= v"1.6"
    function inverse(f::Base.ComposedFunction)
        inv_inner = inverse(f.inner)
        inv_outer = inverse(f.outer)
        if inv_inner isa NoInverse || inv_outer isa NoInverse
            NoInverse(f)
        else
            Base.ComposedFunction(inv_inner, inv_outer)
        end
    end
end

function inverse(mapped_f::Base.Fix1{<:Union{typeof(map),typeof(broadcast)}})
    inv_f_kernel = inverse(mapped_f.x)
    if inv_f_kernel isa NoInverse
        NoInverse(mapped_f)
    else
        Base.Fix1(mapped_f.f, inverse(mapped_f.x))
    end
end

inverse(::typeof(identity)) = identity
inverse(::typeof(inv)) = inv
inverse(::typeof(adjoint)) = adjoint
inverse(::typeof(transpose)) = transpose
inverse(::typeof(conj)) = conj

inverse(::typeof(!)) = !
inverse(::typeof(+)) = +
inverse(::typeof(-)) = -

inverse(f::Base.Fix1{typeof(+)}) = Base.Fix2(-, f.x)
inverse(f::Base.Fix2{typeof(+)}) = Base.Fix2(-, f.x)
inverse(f::Base.Fix1{typeof(-)}) = Base.Fix1(-, f.x)
inverse(f::Base.Fix2{typeof(-)}) = Base.Fix1(+, f.x)
inverse(f::Base.Fix1{typeof(*)}) = iszero(f.x) ? throw(DomainError(f.x, "Cannot invert multiplication by zero")) : Base.Fix1(\, f.x)
inverse(f::Base.Fix2{typeof(*)}) = iszero(f.x) ? throw(DomainError(f.x, "Cannot invert multiplication by zero")) : Base.Fix2(/, f.x)
inverse(f::Base.Fix1{typeof(/)}) = Base.Fix2(\, f.x)
inverse(f::Base.Fix2{typeof(/)}) = Base.Fix2(*, f.x)
inverse(f::Base.Fix1{typeof(\)}) = Base.Fix1(*, f.x)
inverse(f::Base.Fix2{typeof(\)}) = Base.Fix1(/, f.x)

inverse(::typeof(deg2rad)) = rad2deg
inverse(::typeof(rad2deg)) = deg2rad

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

inverse(::typeof(cbrt)) = Base.Fix2(^, 3)
inverse(f::Base.Fix2{typeof(^)}) = iszero(f.x) ? throw(DomainError(f.x, "Cannot invert x^$(f.x)")) : Base.Fix2(invpow2, f.x)
inverse(f::Base.Fix2{typeof(invpow2)}) = Base.Fix2(^, f.x)
inverse(f::Base.Fix1{typeof(^)}) = Base.Fix1(invpow1, f.x)
inverse(f::Base.Fix1{typeof(invpow1)}) = Base.Fix1(^, f.x)
inverse(f::Base.Fix1{typeof(log)}) = Base.Fix1(invlog1, f.x)
inverse(f::Base.Fix1{typeof(invlog1)}) = Base.Fix1(log, f.x)
inverse(f::Base.Fix2{typeof(log)}) = Base.Fix2(invlog2, f.x)
inverse(f::Base.Fix2{typeof(invlog2)}) = Base.Fix2(log, f.x)

inverse(::typeof(sin)) = asin
inverse(::typeof(cos)) = acos
inverse(::typeof(tan)) = atan
inverse(::typeof(csc)) = acsc
inverse(::typeof(sec)) = asec
inverse(::typeof(cot)) = acot

inverse(::typeof(asin)) = sin
inverse(::typeof(acos)) = cos
inverse(::typeof(atan)) = tan
inverse(::typeof(acsc)) = csc
inverse(::typeof(asec)) = sec
inverse(::typeof(acot)) = cot

inverse(::typeof(sinh)) = asin
inverse(::typeof(cosh)) = acos
inverse(::typeof(tanh)) = atan
inverse(::typeof(csch)) = acsc
inverse(::typeof(sech)) = asec
inverse(::typeof(coth)) = acot

inverse(::typeof(asinh)) = sinh
inverse(::typeof(acosh)) = cosh
inverse(::typeof(atanh)) = tanh
inverse(::typeof(acsch)) = csch
inverse(::typeof(asech)) = sech
inverse(::typeof(acoth)) = coth

inverse(f::Base.Fix1{typeof(sin)}) = Base.Fix1(asin, f.x)
inverse(f::Base.Fix1{typeof(cos)}) = Base.Fix1(acos, f.x)
inverse(f::Base.Fix1{typeof(tan)}) = Base.Fix1(atan, f.x)
inverse(f::Base.Fix1{typeof(csc)}) = Base.Fix1(acsc, f.x)
inverse(f::Base.Fix1{typeof(sec)}) = Base.Fix1(asec, f.x)
inverse(f::Base.Fix1{typeof(cot)}) = Base.Fix1(acot, f.x)
    
inverse(f::Base.Fix1{typeof(asin)}) = Base.Fix1(sin, f.x)
inverse(f::Base.Fix1{typeof(acos)}) = Base.Fix1(cos, f.x)
inverse(f::Base.Fix1{typeof(atan)}) = Base.Fix1(tan, f.x)
inverse(f::Base.Fix1{typeof(acsc)}) = Base.Fix1(csc, f.x)
inverse(f::Base.Fix1{typeof(asec)}) = Base.Fix1(sec, f.x)
inverse(f::Base.Fix1{typeof(acot)}) = Base.Fix1(cot, f.x)

inverse(f::Base.Fix1{typeof(sinh)}) = Base.Fix1(asinh, f.x)
inverse(f::Base.Fix1{typeof(cosh)}) = Base.Fix1(acosh, f.x)
inverse(f::Base.Fix1{typeof(tanh)}) = Base.Fix1(atanh, f.x)
inverse(f::Base.Fix1{typeof(csch)}) = Base.Fix1(acsch, f.x)
inverse(f::Base.Fix1{typeof(sech)}) = Base.Fix1(asech, f.x)
inverse(f::Base.Fix1{typeof(coth)}) = Base.Fix1(acoth, f.x)
    
inverse(f::Base.Fix1{typeof(asinh)}) = Base.Fix1(sinh, f.x)
inverse(f::Base.Fix1{typeof(acosh)}) = Base.Fix1(cosh, f.x)
inverse(f::Base.Fix1{typeof(atanh)}) = Base.Fix1(tanh, f.x)
inverse(f::Base.Fix1{typeof(acsch)}) = Base.Fix1(csch, f.x)
inverse(f::Base.Fix1{typeof(asech)}) = Base.Fix1(sech, f.x)
inverse(f::Base.Fix1{typeof(acoth)}) = Base.Fix1(coth, f.x)

    
  
