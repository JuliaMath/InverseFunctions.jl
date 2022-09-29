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
    if x ≥ zero(x) || isodd(p)
        copysign(abs(x)^inv(p), x)
    else
        throw(DomainError(x, "inverse for x^$p is not defined at $x"))
    end
end
function invpow2(x::Real, p::Real)
    if x ≥ zero(x)
        x^inv(p)
    else
        throw(DomainError(x, "inverse for x^$p is not defined at $x"))
    end
end
function invpow2(x, p::Real)
    # complex x^p is only invertible for p = 1/n
    if isinteger(inv(p))
        x^inv(p)
    else
        throw(DomainError(x, "inverse for x^$p is not defined at $x"))
    end
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
invlog1(b, x) = b^x

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
