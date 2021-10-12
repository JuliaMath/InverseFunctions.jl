"""
    InverseFunctions.test_inverse(f, x; compare=isapprox, kwargs...)

Test if [`inverse(f)`](@ref) is implemented correctly.

The function tests (as a `Test.@testset`) if

* `compare(inverse(f)(f(x)), x) == true` and
* `compare(inverse(inverse(f))(x), f(x)) == true`.

`kwargs...` are forwarded to `compare`.
"""
function test_inverse(f, x; compare=isapprox, kwargs...)
    @testset "test_inverse: $f with input $x" begin
        y = f(x)
        inverse_f = inverse(f)
        @test compare(inverse_f(y), x; kwargs...)
        inverse_inverse_f = inverse(inverse_f)
        @test compare(inverse_inverse_f(x), y; kwargs...)
    end
    return nothing
end
