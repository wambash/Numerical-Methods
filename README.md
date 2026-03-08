[![Actions Status](https://github.com/wambash/Numerical-Methods/actions/workflows/test.yml/badge.svg)](https://github.com/wambash/Numerical-Methods/actions)

Numerical::Methods
==================

Numerical methods for optimization implemented as lazy iterators in Raku.

Synopsis
========

    use Numerical::Methods;

    # Newton's method for finding roots
    my $root = find-zero(2.0, -> $x { $x**2 - 2 }, -> $x { 2*$x });

    # Fibonacci method for finding minimum on interval
    my $min = fibonacci-min(1.0, 3.0, -> $x { $x**2 - 7*$x }, 25);

    # Golden section method
    my $min = golden-section-min(1.0, 3.0, -> $x { $x**2 - 7*$x });

    # Gradient descent
    my $min = gradient-descent(2.0, -> $x { 2*$x }, 0.1);

Description
===========

This module provides lazy iterators for common numerical optimization methods. All methods are implemented using Raku's sequence operator and lazy evaluation, making them memory-efficient and composable.

Exports
=======

Newton's Method
---------------

over
====

4

  * `newton-step($x, &f, &df)`

Single Newton iteration step. Returns `$x - f($x)/df($x)`.

  * `newton-seq($x0, &f, &df)`

Lazy sequence of Newton iterations starting from `$x0`.

  * `find-zero($x0, &f, &df, :$tol)`

Find root of function using Newton's method. Returns first value where `f(x) ≈ 0` within tolerance.

back
====



Fibonacci Method
----------------

over
====

4

  * `@fibs`

Lazy Fibonacci sequence: `0, 1, 1, 2, 3, 5, 8, ...`

  * `fibonacci-min($a0, $b0, &f, $n)`

Find minimum of function on interval using Fibonacci method. Uses `$n` iterations.

back
====



Golden Section Method
---------------------

over
====

4

  * `GOLDEN_RATIO`

Mathematical constant φ = (1 + √5) / 2 ≈ 1.618

  * `GOLDEN_SECTION`

Reciprocal of golden ratio: 1/φ ≈ 0.618

  * `golden-section-min($a0, $b0, &f, :$tol)`

Find minimum of function on interval using golden section search. Iterates until interval width is less than tolerance.

back
====



Gradient Descent
----------------

over
====

4

  * `gradient-step($x, &grad-f, $α)`

Single gradient descent step. Returns `$x - $α * grad-f($x)`.

  * `gradient-seq($x0, &grad-f, $α)`

Lazy sequence of gradient descent steps starting from `$x0`.

  * `gradient-descent($x0, &grad-f, $α, :$tol)`

Find minimum using gradient descent. Returns first value where `grad-f(x) ≈ 0` within tolerance.

back
====



Submodules
==========

over
====

4

  * [Numerical::Methods::Newton](Numerical::Methods::Newton)

  * [Numerical::Methods::Interval](Numerical::Methods::Interval)

  * [Numerical::Methods::Gradient](Numerical::Methods::Gradient)

back
====



Examples
========

Finding square root of 2
------------------------

    use Numerical::Methods;

    my $sqrt2 = find-zero(2.0, -> $x { $x**2 - 2 }, -> $x { 2*$x });
    say $sqrt2;  # 1.41421356...

Finding minimum of x² - 7x
--------------------------

    use Numerical::Methods;

    my $f = -> $x { $x**2 - 7*$x };
    my $min = golden-section-min(0, 10, $f);
    say $min;  # 3.5

See Also
========

over
====

4

  * [https://en.wikipedia.org/wiki/Newton%27s_method](https://en.wikipedia.org/wiki/Newton%27s_method)

  * [https://en.wikipedia.org/wiki/Golden-section_search](https://en.wikipedia.org/wiki/Golden-section_search)

  * [https://en.wikipedia.org/wiki/Fibonacci_search_technique](https://en.wikipedia.org/wiki/Fibonacci_search_technique)

  * [https://en.wikipedia.org/wiki/Gradient_descent](https://en.wikipedia.org/wiki/Gradient_descent)

back
====



License
=======

Artistic License 2.0

