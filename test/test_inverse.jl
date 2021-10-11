# This file is a part of InverseFunctions.jl, licensed under the MIT License (MIT).

using Test
using InverseFunctions


foo(x) = inv(exp(-x) + 1)
inv_foo(y) = log(y / (1 - y))

InverseFunctions.inverse(::typeof(foo)) = inv_foo
InverseFunctions.inverse(::typeof(inv_foo)) = foo

@testset "inverse" begin
    InverseFunctions.test_inverse(inverse, log)

    x = rand()
    for f in (foo, inv_foo, exp, log, exp2, log2, exp10, log10, expm1, log1p)
        InverseFunctions.test_inverse(f, x)
    end

    A = rand(5, 5)
    for f in (identity, inv, adjoint, transpose)
        InverseFunctions.test_inverse(f, A)
    end

    X = rand(5)
    for f in (Base.Fix1(broadcast, foo), Base.Fix1(map, foo))
        for x in (x, fill(x, 3), X)
            InverseFunctions.test_inverse(f, x)
        end
    end

    @static if VERSION >= v"1.6"
        InverseFunctions.test_inverse(log ∘ foo, x)
    end
end
