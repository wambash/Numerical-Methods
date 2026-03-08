#!/usr/bin/env raku
#
# Testy pro Numerical::Methods::Interval (Fibonacci + Golden Section)
#

use lib 'lib';
use Test;
use Numerical::Methods::Interval;

plan 7;

# Funkce pro hledání minima
sub g($x) { $x**4 - 7*$x }
sub g-prime($x) { 4*$x**3 - 7 }
sub g-prime-sq($x) { g-prime($x)**2 }

subtest '@fibs - lazy Fibonacci sequence', {
    plan 2;
    is @fibs.head(11), (0,1,1,2,3,5,8,13,21,34,55), 'first 10 Fibonacci numbers';
    is @fibs[10], 55, '10th Fibonacci number is 55';
}

subtest 'fibonacci-init', {
    plan 6;

    with fibonacci-init(1,3, &g, @fibs[3]/@fibs[4]) {
        is .a, 1;
        is .b, 3;
        is .c, 5/3;
        is .d, 7/3;
        is .fc, g(.c);
        is .fd, g(.d);
    }
}

subtest 'fibonacci-step', {
    plan 6;
    my $s = fibonacci-init(1,3, &g, @fibs[3]/@fibs[4]);
    with fibonacci-step($s) {
        is .a, 1;
        is .b, $s.d;
        is .c - .a, .b - .d;
        is .d, $s.c;
        is .fc, g(.c);
        is .fd, $s.fc;
    }
}

subtest 'fibonacci-intervals', {
    plan 1;
    my @intervals = fibonacci-intervals(1.0, 3.0, &g, 10);
    is @intervals.elems, 10, 'returns some intervals';
}

subtest 'fibonacci-min', {
    plan 2;
    my $root = fibonacci-min(1.0, 3.0, &g, 50);
    is-approx g-prime($root), 0.0,  'g-prime(root) ≈ 0';
    is-approx $root, (7/4)**(1/3),  'root ≈ (7/4)^(1/3)';
}

subtest 'golden-section-intervals', {
    plan 1;
    my $seq = golden-section-intervals(1.0, 3.0, &g);
    ok $seq.defined, 'sequence is defined';
}

subtest 'golden-section-min', {
    plan 2;
    my $root = golden-section-min(1.0, 3.0, &g);
    is-approx g-prime($root), 0.0,  'g-prime(root) ≈ 0';
    is-approx $root, (7/4)**(1/3),  'root ≈ (7/4)^(1/3)';
}

done-testing;
