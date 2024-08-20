# This file is a part of InverseFunctions.jl, licensed under the MIT License (MIT).

"""
    square(x::Real)

Inverse of `sqrt(x)` for non-negative `x`.
"""
square(x) = x^2
function square(x::Real)
    x < zero(x) && throw(DomainError(x, "`square` is defined as the inverse of `sqrt` and can only be evaluated for non-negative values"))
    return x^2
end


function invpow2(x::Real, p::Integer)
    # exception should never happen in actual use: this check is done in inverse(f)
    isodd(p) || throw(DomainError(x, "inverse for x^$p is not defined at $x"))
    copysign(abs(x)^inv(p), x)
end
function invpow2(x::Real, p::Real)
    x ≥ zero(x) || throw(DomainError(x, "inverse for x^$p is not defined at $x"))
    x^inv(p)
end
function invpow2(x, p::Real)
    # complex x^p is only invertible for p = 1/n
    isinteger(inv(p)) || throw(DomainError(x, "inverse for x^$p is not defined at $x"))
    x^inv(p)
end

function invpow1(b::Real, x::Real)
    # b < 0 should never happen in actual use: this check is done in inverse(f)
    if b ≥ zero(b) && x ≥ zero(x)
        log(b, x)
    else
        throw(DomainError(x, "inverse for $b^x is not defined at $x"))
    end
end

function invlog1(b::Real, x::Real)
    # exception may happen here: check cannot be done in inverse(f) because of log(Real, Complex)
    b > zero(b) && !isone(b) || throw(DomainError(x, "inverse for log($b, x) is not defined at $x"))
    b^x
end
invlog1(b, x) = b^x

function invlog2(b::Real, x::Real)
    # exception may happen here: check cannot be done in inverse(f) because of log(Complex, Real)
    x > zero(x) && x != one(x) || throw(DomainError(x, "inverse for log($b, x) is not defined at $x"))
    x^inv(b)
end
invlog2(b, x) = x^inv(b)


function invdivrem((q, r), divisor)
    res = muladd(q, divisor, r)
    if abs(r) ≤ abs(divisor) && (iszero(r) || sign(r) == sign(res))
        res
    else
        throw(DomainError((q, r), "inverse for divrem(x) is not defined at this point"))
    end
end

function invfldmod((q, r), divisor)
    if abs(r) ≤ abs(divisor) && (iszero(r) || sign(r) == sign(divisor))
        muladd(q, divisor, r)
    else
        throw(DomainError((q, r), "inverse for fldmod(x) is not defined at this point"))
    end
end
