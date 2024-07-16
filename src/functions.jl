# This file is a part of InverseFunctions.jl, licensed under the MIT License (MIT).

"""
    square(x::Real)

Inverse of `sqrt(x)` for non-negative `x`.
"""
function square(x)
    if is_real_type(typeof(x)) && x < zero(x)
        throw(DomainError(x, "`square` is defined as the inverse of `sqrt` and can only be evaluated for non-negative values"))
    end
    return x^2
end


function invpow_arg2(x::Number, p::Real)
    if is_real_type(typeof(x))
        x ≥ zero(x) ? x^inv(p) :  # x > 0 - trivially invertible
            isinteger(p) && isodd(Integer(p)) ? copysign(abs(x)^inv(p), x) :  # p odd - invertible even for x < 0
            throw(DomainError(x, "inverse for x^$p is not defined at $x"))
    else
        # complex x^p is invertible only for p = 1/n
        isinteger(inv(p)) ? x^inv(p) : throw(DomainError(x, "inverse for x^$p is not defined at $x"))
    end
end

function invpow_arg1(b::Real, x::Real)
    if b ≥ zero(b) && x ≥ zero(x)
        log(b, x)
    else
        throw(DomainError(x, "inverse for $b^x is not defined at $x"))
    end
end

function invlog_arg1(b::Real, x::Real)
    if b ≥ zero(b)
        b^x
    else
        throw(DomainError(x, "inverse for log($b, x) is not defined at $x"))
    end
end
invlog_arg1(b::Number, x::Number) = b^x

invlog_arg2(b::Number, x::Number) = x^inv(b)


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


# check if T is a real-Number type
# this is not the same as T <: Real which immediately excludes custom Number subtypes such as unitful numbers
# also, isreal(x) != is_real_type(typeof(x)): the former is true for complex numbers with zero imaginary part
@inline is_real_type(@nospecialize _::Type{<:Real}) = true
@inline is_real_type(::Type{T}) where {T<:Number} = real(T) == T
@inline is_real_type(@nospecialize _::Type) = false
