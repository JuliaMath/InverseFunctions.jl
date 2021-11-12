# This file is a part of InverseFunctions.jl, licensed under the MIT License (MIT).

"""
    square(x::Real)

Inverse of `sqrt(x)` for non-negative `x`.
"""
function square(x::Real)
    x < zero(x) && throw(DomainError(x, "`square` is defined as the inverse of `sqrt` and can only be evaluated for non-negative values"))
    return x^2
end
