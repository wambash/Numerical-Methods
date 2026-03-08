#!/usr/bin/env raku
#
# Testy pro Numerical::Methods::Newton
#

use lib 'lib';
use Test;
use Numerical::Methods;

plan 4;

# Pomocné funkce
sub f($x) { $x**2 - 2 }
sub df($x) { 2 * $x }

subtest 'newton-step', {
    plan 2;
    is-approx newton-step(2.0, &f, &df), 2.0 - f(2.0) / df(2.0), 'newton-step(2.0)';
    is-approx newton-step(1.0, &f, &df), 1.0 - f(1.0) / df(1.0), 'newton-step(1.0)';
}

subtest 'newton-seq - lazy sekvence', {
    plan 3;
    my @values = newton-seq(2.0, &f, &df)[^5];
    is @values.elems, 5, 'returns 5 values';
    is-approx @values[0], 2.0, 'first value is 2.0';
    is-approx @values[1], 1.5, 'second value is 1.5';
}

subtest 'find-zero', {
    plan 2;
    my $root = find-zero(2.0, &f, &df);
    is-approx f($root), 0.0, 1e-10, 'f(root) ≈ 0';
    is-approx $root, sqrt(2), 'root ≈ sqrt(2)';
}

subtest 'Různé počáteční odhady', {
    plan 4;
    for 0.5, 1.0, 2.0, 5.0 -> $x0 {
        my $root = find-zero($x0, &f, &df);
        is-approx f($root), 0.0, 1e-10, "f(root) ≈ 0 for x0=$x0";
    }
}

done-testing;
