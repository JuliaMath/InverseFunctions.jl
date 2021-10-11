"""
    InverseFunctions.test_inverse(f, x; kwargs...)

Check if [`inverse(f)`](@ref) is implemented correctly.

The function checks if
- `inverse(f)(f(x)) ≈ x` and
- `inverse(inverse(f)) === f`.

All keyword arguments are passed to `isapprox`.
"""
function test_inverse(f, x; kwargs...)
    @testset "test_inverse: $f with input $x" begin
        inverse_f = inverse(f)
        @test (x2 = inverse_f(f(x)); x2 == x || isapprox(inverse_f(f(x)), x; kwargs...))
        @test inverse(inverse_f) === f
    end
    return nothing
end
