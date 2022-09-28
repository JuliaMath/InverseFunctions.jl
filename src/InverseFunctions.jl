# This file is a part of InverseFunctions.jl, licensed under the MIT License (MIT).
"""
    InverseFunctions

Lightweight package that defines an interface to invert functions.
"""
module InverseFunctions

using Test

include("functions.jl")
include("inverse.jl")
include("setinverse.jl")
include("test.jl")

end # module
