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


invpow2(x::Real, p::Integer) = sign(x) * abs(x)^inv(p)
invpow2(x::Real, p::Real) = x ≥ zero(x) ? x^inv(p) : throw(DomainError(x, "inverse for x^$p is not defined at $x"))
invpow2(x, p) = x^inv(p)

invpow1(b, x) = log(abs(b), abs(x))

invlog1(b::Real, x::Real) = b ≥ zero(b) && x ≥ zero(x) ? b^x : throw(DomainError(x, "inverse for log($b, x) is not defined at $x"))
invlog1(b, x) = b^x

invlog2(b, x) = x^inv(b)


function invdivrem((q, r), divisor)
    res = muladd(q, divisor, r)
    abs(r) ≤ abs(divisor) && _issamesign(r, res) || throw(DomainError((q, r), "inverse for divrem(x) is not defined at this point"))
    return res
end

function invfldmod((q, r), divisor)
    abs(r) ≤ abs(divisor) && _issamesign(r, divisor) || throw(DomainError((q, r), "inverse for fldmod(x) is not defined at this point"))
    return muladd(q, divisor, r)
end

_issamesign(x, y) = iszero(x) || iszero(y) || sign(x) == sign(y)
