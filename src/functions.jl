# This file is a part of InverseFunctions.jl, licensed under the MIT License (MIT).

"""
    square(x::Real)

Inverse of `sqrt(x)` for non-negative `x`.
"""
function square(x)
    if isreal_type(x) && x < zero(x)
        throw(DomainError(x, "`square` is defined as the inverse of `sqrt` and can only be evaluated for non-negative values"))
    end
    return x^2
end


function invpow2(x::Number, p::Integer)
    if isreal_type(x)
        # real x^p::Int is invertible for x > 0 or p odd 
        x ≥ zero(x) || isodd(p) ?
            copysign(abs(x)^inv(p), x) :
            throw(DomainError(x, "inverse for x^$p is not defined at $x"))
    else
        # complex x^p is invertible only for p = 1/n
        isinteger(inv(p)) ? x^inv(p) : throw(DomainError(x, "inverse for x^$p is not defined at $x"))
    end
end
function invpow2(x::Number, p::Real)
    isdefined = isreal_type(x) ?
        x ≥ zero(x) :  # real x^p is invertible for x ≥ 0
        isinteger(inv(p))  # complex x^p is invertible for p = 1/n
    isdefined ? x^inv(p) : throw(DomainError(x, "inverse for x^$p is not defined at $x"))
end

function invpow1(b::Real, x::Real)
    if b ≥ zero(b) && x ≥ zero(x)
        log(b, x)
    else
        throw(DomainError(x, "inverse for $b^x is not defined at $x"))
    end
end

function invlog1(b::Real, x::Real)
    if b ≥ zero(b)
        b^x
    else
        throw(DomainError(x, "inverse for log($b, x) is not defined at $x"))
    end
end
invlog1(b::Number, x::Number) = b^x

invlog2(b::Number, x::Number) = x^inv(b)


function invdivrem((q, r)::NTuple{2,Number}, divisor::Number)
    res = muladd(q, divisor, r)
    if abs(r) ≤ abs(divisor) && (iszero(r) || sign(r) == sign(res))
        res
    else
        throw(DomainError((q, r), "inverse for divrem(x) is not defined at this point"))
    end
end

function invfldmod((q, r)::NTuple{2,Number}, divisor::Number)
    if abs(r) ≤ abs(divisor) && (iszero(r) || sign(r) == sign(divisor))
        muladd(q, divisor, r)
    else
        throw(DomainError((q, r), "inverse for fldmod(x) is not defined at this point"))
    end
end


# check if x is of a real-Number type
# this is not the same as `x isa Real` which immediately excludes custom Number subtypes such as unitful numbers
# this is also not the same as isreal(x) which is true for complex numbers with zero imaginary part
isreal_type(x::T) where {T<:Number} = real(T) == T
isreal_type(x) = false
