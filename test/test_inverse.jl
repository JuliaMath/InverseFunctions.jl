# This file is a part of InverseFunctions.jl, licensed under the MIT License (MIT).

using Test
using InverseFunctions


foo(x) = inv(exp(-x) + 1)
inv_foo(y) = log(y / (1 - y))

InverseFunctions.inverse(::typeof(foo)) = inv_foo
InverseFunctions.inverse(::typeof(inv_foo)) = foo


struct Bar{MT<:AbstractMatrix}
    A::MT
end

(f::Bar)(x) = f.A * x
InverseFunctions.inverse(f::Bar) = Bar(inv(f.A))


@testset "inverse" begin
    f_without_inverse(x) = 1
    @test inverse(f_without_inverse) isa NoInverse
    @test_throws ErrorException inverse(f_without_inverse)(42)
    @test inverse(inverse(f_without_inverse)) === f_without_inverse

    for f in (f_without_inverse ∘ exp, exp ∘ f_without_inverse, Base.Fix1(broadcast, f_without_inverse), Base.Fix1(map, f_without_inverse))
        @test inverse(f) == NoInverse(f)
        @test inverse(inverse(f)) == f
    end

    InverseFunctions.test_inverse(inverse, log, compare = ===)

    InverseFunctions.test_inverse(!, false)

    x = rand()
    for f in (
            foo, inv_foo, log, log2, log10, log1p, sqrt,
            Base.Fix2(^, rand()), Base.Fix2(^, rand([-10:-1; 1:10])), Base.Fix1(^, rand()), Base.Fix1(log, rand()), Base.Fix2(log, rand()),
        )
        InverseFunctions.test_inverse(f, x)
    end
    for f in (
            +, -, exp, exp2, exp10, expm1, cbrt, deg2rad, rad2deg, conj,
            Base.Fix1(+, rand()), Base.Fix2(+, rand()), Base.Fix1(-, rand()), Base.Fix2(-, rand()),
            Base.Fix1(*, rand()), Base.Fix2(*, rand()), Base.Fix1(/, rand()), Base.Fix2(/, rand()), Base.Fix1(\, rand()), Base.Fix2(\, rand()),
            Base.Fix2(^, rand(-11:2:11)),
        )
        InverseFunctions.test_inverse(f, x)
        InverseFunctions.test_inverse(f, -x)
    end
    InverseFunctions.test_inverse(conj, 2 - 3im)

    # ensure that inverses have domains compatible with original functions
    @test_throws DomainError inverse(Base.Fix1(*, 0))
    @test_throws DomainError inverse(Base.Fix2(^, 0))
    @test_throws DomainError inverse(Base.Fix1(log, 2))(-5)
    InverseFunctions.test_inverse(Base.Fix1(log, 2), -5 + 0im)
    @test_throws DomainError inverse(Base.Fix2(^, 0.5))(-5)
    InverseFunctions.test_inverse(Base.Fix2(^, 0.5), -5 + 0im)

    A = rand(5, 5)
    for f in (
            identity, inv, adjoint, transpose,
            log, sqrt, +, -, exp,
            Base.Fix1(+, rand(5, 5)), Base.Fix2(+, rand(5, 5)), Base.Fix1(-, rand(5, 5)), Base.Fix2(-, rand(5, 5)),
            Base.Fix1(*, rand()), Base.Fix2(*, rand()), Base.Fix1(*, rand(5, 5)), Base.Fix2(*, rand(5, 5)),
            Base.Fix2(/, rand()), Base.Fix1(/, rand(5, 5)), Base.Fix2(/, rand(5, 5)),
            Base.Fix1(\, rand()), Base.Fix1(\, rand(5, 5)), Base.Fix2(\, rand(5, 5)),
        )
        if f != log || VERSION >= v"1.6"
            # exp(log(A::AbstractMatrix)) ≈ A is broken on at least Julia v1.0
            InverseFunctions.test_inverse(f, A)
        end
    end

    X = rand(5)
    for f in (Base.Fix1(broadcast, foo), Base.Fix1(map, foo))
        for x in (x, fill(x, 3), X)
            InverseFunctions.test_inverse(f, x)
        end
    end

    InverseFunctions.test_inverse(Bar(rand(3,3)), rand(3))

    @static if VERSION >= v"1.6"
        InverseFunctions.test_inverse(log ∘ foo, x)
    end
end
