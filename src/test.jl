"""
    InverseFunctions.test_inverse(f, x; inv_inv_test = ===, kwargs...)

Check if [`inverse(f)`](@ref) is implemented correctly.

The function checks if
- `inverse(f)(f(x)) ≈ x` and
- `inv_inv_test(inverse(inverse(f)), f)`.

With `inv_inv_test = ≈`, tests if the result of `inverse(inverse(f))(x)`
is equal or approximately equal to `f(x)`.

`kwargs...` are passed to `isapprox`.
"""
function test_inverse(f, x; inv_inv_test = ===, kwargs...)
    @testset "test_inverse: $f with input $x" begin
        y = f(x)
        @test (x2 = inverse(f)(y); x2 == x || isapprox(x2, x; kwargs...))
        @test let inv_inv_f = inverse(inverse(f))
            if inv_inv_test == ≈
                (y2 = inv_inv_f(x); y2 == y || isapprox(y2, y; kwargs...))
            else
                inv_inv_test(inv_inv_f, f)
            end
        end
    end
    return nothing
end
