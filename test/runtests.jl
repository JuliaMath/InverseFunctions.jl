# This file is a part of InverseFunctions.jl, licensed under the MIT License (MIT).

using InverseFunctions
using Documenter
using Test

@testset "Package InverseFunctions" begin
    include("test_inverse.jl")

    # doctests
    DocMeta.setdocmeta!(
        InverseFunctions,
        :DocTestSetup,
        :(using InverseFunctions);
        recursive=true,
    )
    doctest(InverseFunctions)
end # testset
