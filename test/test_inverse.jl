# This file is a part of InverseFunctions.jl, licensed under the MIT License (MIT).

using InverseFunctions
using Test


foo(x) = inv(exp(-x) + 1)
inv_foo(y) = log(y / (1 - y))

InverseFunctions.inverse(::typeof(foo)) = inv_foo
InverseFunctions.inverse(::typeof(inv_foo)) = foo


@testset "inverse" begin
    @test inverse(inverse)(inverse(log)) == log

    x = 4.2
    X = rand(10)
    A = rand(5, 5)

    @test @inferred(inverse(foo)(foo(x))) ≈ x
    @test @inferred(inverse(inverse(foo))) == foo

    @static if VERSION >= v"1.6"
        log_foo = log ∘ foo
        @test inverse(log_foo)(log_foo(x)) ≈ x
        @test @inferred(inverse(log_foo)) == inv_foo ∘ exp
    end


    broadcasted_foo = Base.Fix1(broadcast, foo)
    @test @inferred(inverse(inverse(broadcasted_foo))) == broadcasted_foo
    @test @inferred(inverse(broadcasted_foo)(broadcasted_foo(x))) ≈ x
    @test @inferred(inverse(broadcasted_foo)(broadcasted_foo(fill(x)))) ≈ x
    @test @inferred(inverse(broadcasted_foo)(broadcasted_foo(Ref(x)))) ≈ x
    @test @inferred(inverse(broadcasted_foo)(broadcasted_foo((x,))))[1] ≈ x
    @test @inferred(inverse(broadcasted_foo)(broadcasted_foo(X))) ≈ X

    mapped_foo = Base.Fix1(map, foo)
    @test @inferred(inverse(inverse(mapped_foo))) == mapped_foo
    @test @inferred(inverse(mapped_foo)(mapped_foo(x))) ≈ x
    @test @inferred(inverse(mapped_foo)(mapped_foo(fill(x)))) ≈ fill(x)
    @test @inferred(inverse(mapped_foo)(mapped_foo(Ref(x)))) ≈ fill(x)
    @test @inferred(inverse(mapped_foo)(mapped_foo((x,))))[1] ≈ x
    @test @inferred(inverse(mapped_foo)(mapped_foo(X))) ≈ X


    mapped_foo = Base.Fix1(broadcast, foo)
    Y = mapped_foo(X)
    @test @inferred(inverse(mapped_foo)(Y)) ≈ X

    for f in (identity, inv, adjoint, transpose)
        @test @inferred(inverse(f)(f(A))) ≈ A
        @test @inferred(inverse(f)) == f
    end    

    for f in (exp, log, exp2, log2, exp10, log10, expm1, log1p)
        @test @inferred(inverse(f)(f(x))) ≈ x
        @test @inferred(inverse(inverse(f))) == f
    end
end
