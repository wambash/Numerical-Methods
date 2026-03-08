=begin pod
=head1 Numerical::Methods

Numerical methods for optimization implemented as lazy iterators in Raku.

=head1 Synopsis

    use Numerical::Methods;

    # Newton's method for finding roots
    my $root = find-zero(2.0, -> $x { $x**2 - 2 }, -> $x { 2*$x });

    # Fibonacci method for finding minimum on interval
    my $min = fibonacci-min(1.0, 3.0, -> $x { $x**2 - 7*$x }, 25);

    # Golden section method
    my $min = golden-section-min(1.0, 3.0, -> $x { $x**2 - 7*$x });

    # Gradient descent
    my $min = gradient-descent(2.0, -> $x { 2*$x }, 0.1);

=head1 Description

This module provides lazy iterators for common numerical optimization methods.
All methods are implemented using Raku's sequence operator and lazy evaluation,
making them memory-efficient and composable.

=head1 Exports

=head2 Newton's Method

=over 4

=item C<newton-step($x, &f, &df)>

Single Newton iteration step. Returns C<$x - f($x)/df($x)>.

=item C<newton-seq($x0, &f, &df)>

Lazy sequence of Newton iterations starting from C<$x0>.

=item C<find-zero($x0, &f, &df, :$tol)>

Find root of function using Newton's method.
Returns first value where C<f(x) ≈ 0> within tolerance.

=back

=head2 Fibonacci Method

=over 4

=item C<@fibs>

Lazy Fibonacci sequence: C<0, 1, 1, 2, 3, 5, 8, ...>

=item C<fibonacci-min($a0, $b0, &f, $n)>

Find minimum of function on interval using Fibonacci method.
Uses C<$n> iterations.

=back

=head2 Golden Section Method

=over 4

=item C<GOLDEN_RATIO>

Mathematical constant φ = (1 + √5) / 2 ≈ 1.618

=item C<GOLDEN_SECTION>

Reciprocal of golden ratio: 1/φ ≈ 0.618

=item C<golden-section-min($a0, $b0, &f, :$tol)>

Find minimum of function on interval using golden section search.
Iterates until interval width is less than tolerance.

=back

=head2 Gradient Descent

=over 4

=item C<gradient-step($x, &grad-f, $α)>

Single gradient descent step. Returns C<$x - $α * grad-f($x)>.

=item C<gradient-seq($x0, &grad-f, $α)>

Lazy sequence of gradient descent steps starting from C<$x0>.

=item C<gradient-descent($x0, &grad-f, $α, :$tol)>

Find minimum using gradient descent.
Returns first value where C<grad-f(x) ≈ 0> within tolerance.

=back

=head1 Submodules

=over 4

=item L<Numerical::Methods::Newton>

=item L<Numerical::Methods::Interval>

=item L<Numerical::Methods::Gradient>

=back

=head1 Examples

=head2 Finding square root of 2

    use Numerical::Methods;

    my $sqrt2 = find-zero(2.0, -> $x { $x**2 - 2 }, -> $x { 2*$x });
    say $sqrt2;  # 1.41421356...

=head2 Finding minimum of x² - 7x

    use Numerical::Methods;

    my $f = -> $x { $x**2 - 7*$x };
    my $min = golden-section-min(0, 10, $f);
    say $min;  # 3.5

=head1 See Also

=over 4

=item L<https://en.wikipedia.org/wiki/Newton%27s_method>

=item L<https://en.wikipedia.org/wiki/Golden-section_search>

=item L<https://en.wikipedia.org/wiki/Fibonacci_search_technique>

=item L<https://en.wikipedia.org/wiki/Gradient_descent>

=back

=head1 License

Artistic License 2.0

=end pod

use Numerical::Methods::Newton;
use Numerical::Methods::Interval;
use Numerical::Methods::Gradient;

sub EXPORT {
    %(
        '&newton-step'          => &newton-step,
        '&newton-seq'           => &newton-seq,
        '&find-zero'            => &find-zero,

        # Fibonacci method
        '@fibs'                 => @fibs,
        '&fibonacci-min'        => &fibonacci-min,

        # Golden Section method
        '&GOLDEN_RATIO'         => &GOLDEN_RATIO,
        '&GOLDEN_SECTION'       => &GOLDEN_SECTION,
        '&golden-section-min'   => &golden-section-min,

        # Gradient descent
        '&gradient-step'        => &gradient-step,
        '&gradient-seq'         => &gradient-seq,
        '&gradient-descent'     => &gradient-descent,
    )
}
