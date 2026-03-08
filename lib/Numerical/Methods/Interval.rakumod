unit module Numerical::Methods::Interval;

# =============================================================================
# FIBONACCIHO METODA
# =============================================================================

our @fibs is export = 0, 1, *+* ... *;

class FibonacciState {
    has ($.a, $.b, $.c, $.d, $.fc, $.fd, &.f);
}


sub fibonacci-init ($a0, $b0, &f, $ratio) is export {
    my $c = $b0 - $ratio * ($b0 - $a0);
    my $d = $a0 + $ratio * ($b0 - $a0);

    FibonacciState.new(:a($a0), :b($b0), :$c, :$d, :fc(f($c)), :fd(f($d)), :&f)
}

sub fibonacci-step ($_) is export {
    my &f  = .f;

    if .fc < .fd {
        my $new-c = .a + (.d - .c);

        FibonacciState.new(
            :a(.a), :c($new-c), :d(.c), :b(.d),
            :fc(f($new-c)), :fd(.fc), :&f
        )
    } else {
        my $new-d = .b - (.d - .c);

        FibonacciState.new(
            :a(.c), :c(.d), :d($new-d), :b(.b),
            :fc(.fd), :fd(f($new-d)), :&f
        )
    }
}

sub fibonacci-intervals ($a0, $b0, &f, $n) is export {
    my $state = fibonacci-init($a0, $b0, &f, @fibs[$n]/@fibs[$n+1]);

    $state, &fibonacci-step ... { .c == .a }\
}

sub fibonacci-min ($a0, $b0, &f, $n) is export {
    fibonacci-intervals($a0, $b0, &f, $n)
    andthen .tail
    andthen (.a + .b) / 2
}

# =============================================================================
# METODA ZLATÉHO ŘEZU - OPTIMALIZOVANÁ VERZE (1 volání f() per iterace)
# =============================================================================

constant GOLDEN_RATIO   is export = (1 + sqrt(5)) / 2;
constant GOLDEN_SECTION is export = 1 / GOLDEN_RATIO;


sub golden-section-intervals ($a0, $b0, &f ) is export {
    my $state = fibonacci-init($a0, $b0, &f, GOLDEN_SECTION);

    $state, &fibonacci-step ... *
}

sub golden-section-min ($a0, $b0, &f, :$tol=1e-6) is export {
    my $*TOLERANCE = $tol;

    golden-section-intervals($a0, $b0, &f)
    andthen .first: { .a ≅ .b  }\
    andthen ( .a + .b ) / 2
}
