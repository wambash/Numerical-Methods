#!/usr/bin/env raku
#
# Testy pro Numerical::Methods::Gradient
#

use lib 'lib';
use Test;
use Numerical::Methods::Gradient;

plan 4;

# Pomocné funkce
sub f($x) { $x**2 - 2 }
sub df($x) { 2 * $x }

subtest 'gradient-step', {
    plan 2;
    is-approx gradient-step(2.0, &df, 0.1), 2.0 - 0.1 * df(2.0), 'gradient-step(2.0)';
    is-approx gradient-step(1.0, &df, 0.1), 1.0 - 0.1 * df(1.0), 'gradient-step(1.0)';
}

subtest 'gradient-seq - lazy sekvence', {
    plan 3;
    my @values = gradient-seq(2.0, &df, 0.1)[^5];
    is @values.elems, 5, 'returns 5 values';
    is-approx @values[0], 2.0, 'first value is 2.0';
    cmp-ok abs(@values[*-1]), '<', abs(@values[0]), 'values converge towards 0';
}

subtest 'gradient-descent', {
    plan 1;
    my $root = gradient-descent(2.0, &df, 0.1);
    is-approx df($root), 0.0, 1e-10, 'df(root) ≈ 0';
}

subtest 'Různé počáteční odhady', {
    plan 4;
    for 0.5, 1.0, 2.0, 5.0 -> $x0 {
        my $root = gradient-descent($x0, &df, 0.1);
        is-approx df($root), 0.0, 1e-10, "df(root) ≈ 0 for x0=$x0";
    }
}

done-testing;
