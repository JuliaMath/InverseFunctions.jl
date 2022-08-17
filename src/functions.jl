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


invpow2(x::Real, p::Integer) = x ≥ zero(x) || isodd(p) ? sign(x) * abs(x)^inv(p) : throw(DomainError(x, "inverse for x^$p is not defined at $x"))
invpow2(x::Real, p::Real) = x ≥ zero(x) ? x^inv(p) : throw(DomainError(x, "inverse for x^$p is not defined at $x"))

invpow1(b::Real, x::Real) = b ≥ zero(b) && x ≥ zero(x) ? log(b, x) : throw(DomainError(x, "inverse for $b^x is not defined at $x"))

invlog1(b::Real, x::Real) = b ≥ zero(b) ? b^x : throw(DomainError(x, "inverse for log($b, x) is not defined at $x"))
invlog1(b, x) = b^x

invlog2(b, x) = x^inv(b)
