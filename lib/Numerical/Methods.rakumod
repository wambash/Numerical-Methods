unit module Numerical::Methods;

# Numerical methods for optimization
# All methods implemented as lazy iterators

# =============================================================================
# NEWTON'S METHOD
# =============================================================================

our &newton-step is export = sub ($x, &f, &df) {
    $x - f($x) / df($x)
};

our &newton-seq is export = sub ($x0, &f, &df) {
    my $x = $x0;
    lazy gather {
        loop {
            take $x;
            $x = newton-step($x, &f, &df);
        }
    }
};

our &find-zero is export = sub ($x0, &f, &df, :$tol=1e-10) {
    first(-> $x { abs(f($x)) < $tol }, newton-seq($x0, &f, &df))
};

# =============================================================================
# FIBONACCI METHOD
# =============================================================================

our @fibs is export = 1, 1, *+* ... *;

our &fibonacci is export = sub ($n) {
    @fibs[$n - 1]
};

our &fibonacci-intervals is export = sub ($a0, $b0, &f, $n) {
    my $a = $a0;
    my $b = $b0;
    my $k = $n;

    # Inicializace
    my $Fn   = @fibs[$k];
    my $Fn_1 = @fibs[$k - 1];
    my $Fn_2 = @fibs[$k - 2];
    my $c = $a + ($Fn_2 / $Fn) * ($b - $a);
    my $d = $a + ($Fn_1 / $Fn) * ($b - $a);
    my $fc = f($c);
    my $fd = f($d);

    if $fc < $fd { $b = $d } else { $a = $c }

    return ($a, $b), -> ($_, $) {
        $k--;
        last if $k <= 3;

        $Fn   = @fibs[$k];
        $Fn_1 = @fibs[$k - 1];
        $Fn_2 = @fibs[$k - 2];
        $c = $a + ($Fn_2 / $Fn) * ($b - $a);
        $d = $a + ($Fn_1 / $Fn) * ($b - $a);
        $fc = f($c);
        $fd = f($d);

        if $fc < $fd { $b = $d } else { $a = $c }
        ($a, $b)
    } ... *
};

our &fibonacci-min is export = sub ($a0, $b0, &f, $n) {
    my @intervals = fibonacci-intervals($a0, $b0, &f, $n).eager;
    my $result = @intervals.tail;
    ($result[0] + $result[1]) / 2
};

# =============================================================================
# GOLDEN SECTION METHOD
# =============================================================================

constant GOLDEN_RATIO is export = (1 + sqrt(5)) / 2;
constant GOLDEN_SECTION is export = 1 / GOLDEN_RATIO;

our &golden-section-intervals is export = sub ($a0, $b0, &f) {
    my @s = $a0, $b0, 0, 0, 0, 0;  # a, b, c, d, fc, fd
    @s[2] = @s[0] + (1 - GOLDEN_SECTION) * (@s[1] - @s[0]);
    @s[3] = @s[0] + GOLDEN_SECTION * (@s[1] - @s[0]);
    @s[4] = f(@s[2]);
    @s[5] = f(@s[3]);

    return (@s[0], @s[1]), -> ($_, $) {
        if @s[4] < @s[5] {
            (@s[1], @s[3], @s[5]) = (@s[3], @s[2], @s[4]);
            @s[2] = @s[0] + (1 - GOLDEN_SECTION) * (@s[1] - @s[0]);
            @s[4] = f(@s[2]);
        } else {
            (@s[0], @s[2], @s[4]) = (@s[2], @s[3], @s[5]);
            @s[3] = @s[0] + GOLDEN_SECTION * (@s[1] - @s[0]);
            @s[5] = f(@s[3]);
        }
        (@s[0], @s[1])
    } ... *
};

our &golden-section-min is export = sub ($a0, $b0, &f, :$tol=1e-10) {
    for golden-section-intervals($a0, $b0, &f) -> ($a, $b) {
        return ($a + $b) / 2 if $b - $a < $tol;
    }
};

# =============================================================================
# GRADIENT DESCENT
# =============================================================================

our &gradient-step is export = sub ($x, &grad-f, $α) {
    $x - $α * grad-f($x)
};

our &gradient-seq is export = sub ($x0, &grad-f, $α) {
    my $x = $x0;
    lazy gather {
        loop {
            take $x;
            $x = gradient-step($x, &grad-f, $α);
        }
    }
};

our &gradient-descent is export = sub ($x0, &grad-f, $α, :$tol=1e-10) {
    first(-> $x { abs(grad-f($x)) < $tol }, gradient-seq($x0, &grad-f, $α))
};
