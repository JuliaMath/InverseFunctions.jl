# This file is a part of InverseFunctions.jl, licensed under the MIT License (MIT).

using Test
using InverseFunctions


@testset "square" begin
    for x in (-0.72, 0.73, randn(3, 3))
        @test InverseFunctions.square(x) ≈ x * x
    end
end
