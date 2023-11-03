# This file is a part of InverseFunctions.jl, licensed under the MIT License (MIT).
"""
    InverseFunctions

Lightweight package that defines an interface to invert functions.
"""
module InverseFunctions


include("functions.jl")
include("inverse.jl")
include("setinverse.jl")
include("partinverse.jl")
include("test.jl")

end # module
