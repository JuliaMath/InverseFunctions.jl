var documenterSearchIndex = {"docs":
[{"location":"api/#API","page":"API","title":"API","text":"","category":"section"},{"location":"api/#Interface","page":"API","title":"Interface","text":"","category":"section"},{"location":"api/","page":"API","title":"API","text":"inverse\nNoInverse\nsetinverse","category":"page"},{"location":"api/#InverseFunctions.inverse","page":"API","title":"InverseFunctions.inverse","text":"inverse(f)\n\nReturn the inverse of function f.\n\ninverse supports mapped and broadcasted functions (via Base.Broadcast.BroadcastFunction or Base.Fix1) and function composition (requires Julia >= 1.6).\n\nExamples\n\njulia> foo(x) = inv(exp(-x) + 1);\n\njulia> inv_foo(y) = log(y / (1 - y));\n\njulia> InverseFunctions.inverse(::typeof(foo)) = inv_foo;\n\njulia> InverseFunctions.inverse(::typeof(inv_foo)) = foo;\n\njulia> x = 4.2;\n\njulia> inverse(foo)(foo(x)) ≈ x\ntrue\n\njulia> inverse(inverse(foo)) === foo\ntrue\n\njulia> broadcast_foo = VERSION >= v\"1.6\" ? Base.Broadcast.BroadcastFunction(foo) : Base.Fix1(broadcast, foo);\n\njulia> X = rand(10);\n\njulia> inverse(broadcast_foo)(broadcast_foo(X)) ≈ X\ntrue\n\njulia> bar = log ∘ foo;\n\njulia> VERSION < v\"1.6\" || inverse(bar)(bar(x)) ≈ x\ntrue\n\nImplementation\n\nImplementations of inverse(::typeof(f)) have to satisfy\n\ninverse(f)(f(x)) ≈ x for all x in the domain of f, and\ninverse(inverse(f)) is defined and inverse(inverse(f))(x) ≈ f(x) for all x in the domain of f.\n\nYou can check your implementation with InverseFunctions.test_inverse.\n\n\n\n\n\n","category":"function"},{"location":"api/#InverseFunctions.NoInverse","page":"API","title":"InverseFunctions.NoInverse","text":"struct NoInverse{F}\n\nAn instance NoInverse(f) signifies that inverse(f) is not defined.\n\n\n\n\n\n","category":"type"},{"location":"api/#InverseFunctions.setinverse","page":"API","title":"InverseFunctions.setinverse","text":"setinverse(f, invf)\n\nReturn a function that behaves like f and uses invf as its inverse.\n\nUseful in cases where no inverse is defined for f or to set an inverse that is only valid within a given context, e.g. only for a limited argument range that is guaranteed by the use case but not in general.\n\nFor example, asin is not a valid inverse of sin for arbitrary arguments of sin, but can be a valid inverse if the use case guarantees that the argument of sin will always be within -π and π:\n\njulia> foo = setinverse(sin, asin);\n\njulia> x = π/3;\n\njulia> foo(x) == sin(x)\ntrue\n\njulia> inverse(foo)(foo(x)) ≈ x\ntrue\n\njulia> inverse(foo) === setinverse(asin, sin)\ntrue\n\n\n\n\n\n","category":"function"},{"location":"api/#Test-utility","page":"API","title":"Test utility","text":"","category":"section"},{"location":"api/","page":"API","title":"API","text":"InverseFunctions.test_inverse","category":"page"},{"location":"api/#InverseFunctions.test_inverse","page":"API","title":"InverseFunctions.test_inverse","text":"InverseFunctions.test_inverse(f, x; compare=isapprox, kwargs...)\n\nTest if inverse(f) is implemented correctly.\n\nThe function tests (as a Test.@testset) if\n\ncompare(inverse(f)(f(x)), x) == true and\ncompare(inverse(inverse(f))(x), f(x)) == true.\n\nkwargs... are forwarded to compare.\n\n!!! Note     On Julia >= 1.9, you have to load the Test standard library to be able to use     this function.\n\n\n\n\n\n","category":"function"},{"location":"api/#Additional-functionality","page":"API","title":"Additional functionality","text":"","category":"section"},{"location":"api/","page":"API","title":"API","text":"InverseFunctions.square\nInverseFunctions.FunctionWithInverse","category":"page"},{"location":"api/#InverseFunctions.square","page":"API","title":"InverseFunctions.square","text":"square(x::Real)\n\nInverse of sqrt(x) for non-negative x.\n\n\n\n\n\n","category":"function"},{"location":"api/#InverseFunctions.FunctionWithInverse","page":"API","title":"InverseFunctions.FunctionWithInverse","text":"struct FunctionWithInverse{F,InvF} <: Function\n\nA function with an inverse.\n\nDo not construct directly, use setinverse(f, invf) instead.\n\n\n\n\n\n","category":"type"},{"location":"LICENSE/#LICENSE","page":"LICENSE","title":"LICENSE","text":"","category":"section"},{"location":"LICENSE/","page":"LICENSE","title":"LICENSE","text":"using Markdown\nMarkdown.parse_file(joinpath(@__DIR__, \"..\", \"..\", \"LICENSE.md\"))","category":"page"},{"location":"#InverseFunctions.jl","page":"Home","title":"InverseFunctions.jl","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"InverseFunctions","category":"page"},{"location":"#InverseFunctions","page":"Home","title":"InverseFunctions","text":"InverseFunctions\n\nLightweight package that defines an interface to invert functions.\n\n\n\n\n\n","category":"module"},{"location":"","page":"Home","title":"Home","text":"This package defines the function inverse. inverse(f) returns the inverse function of a function f, so that inverse(f)(f(x)) ≈ x.","category":"page"},{"location":"","page":"Home","title":"Home","text":"inverse supports mapped/broadcasted functions (via Base.Broadcast.BroadcastFunction or Base.Fix1) and function composition.","category":"page"},{"location":"","page":"Home","title":"Home","text":"Implementations of inverse(f) for identity, inv, adjoint and transpose as well as for exp, log, exp2, log2, exp10, log10, expm1, log1p and sqrt are included.","category":"page"}]
}
