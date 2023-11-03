# default methods for when an inverse exists
export r_inv, l_inv, retraction, coretraction

"""
    r_inv(function)
    retraction(function)

Return the left inverse of a function, i.e. a function that "undoes" `f`. Formally, 
    ``\\text{retraction}(f)(f(x)) = x``
"""
r_inv(args...; kwargs...) = inverse(args...; kwargs...)

"""
    l_inv(function)
    coretraction(function)

Return the right inverse of a function, i.e. a function that can be "undone" by applying 
`f`. Formally, 
``f(\\text{coretraction}(f)(x)) = x``
"""
l_inv(args...; kwargs...) = inverse(args...; kwargs...)

# synonyms common in category theory
# coretractions are often called "section"s, but name is likely too generic
retraction = r_inv
coretraction = l_inv

# Generate trig and htrig inverses
let trigfuns = ("sin", "cos", "tan", "sec", "csc", "cot")
    # regular, degrees, hyperbolic
    funcs = (trigfuns..., (trigfuns .* "d")..., (trigfuns .* "h")...)
    invfuncs = "a" .* funcs
    funcs, invfuncs = Symbol.(funcs), Symbol.(invfuncs)
    for (func, invfunc) in zip(funcs, invfuncs)
        @eval l_inv(::typeof($func)) = $invfunc
        @eval r_inv(::typeof($invfunc)) = $func
    end
end
