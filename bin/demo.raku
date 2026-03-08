#!/usr/bin/env raku
#
# Porovnání numerických metod pro hledání minima
# Ekvivalent k Julia bin/demo.jl
#

use lib 'lib';
use Numerical::Methods;

# Funkce, jejíž minimum hledáme: g(x) = x⁴-7x
# Minimum je kde g'(x) = 0, tj. 4x³-7 = 0 → x = (7/4)^(1/3)
sub g($x) { $x**4 - 7*$x }
sub g-prime($x) { 4*$x**3 - 7 }
sub g-double-prime($x) { 12*$x**2 }

# Všechny metody nyní pracují se stejnou funkcí g(x)
# Newton a gradient používají g-prime, Fibonacci a zlatý řez minimalizují přímo g(x)

say "Porovnání numerických metod pro g(x) = x⁴-7x";
say "=" x 60;
say "Hledáme minimum: g'(x) = 0 na intervalu [1, 2]";
say "Očekávaný výsledek: x = (7/4)^(1/3) = {(7/4)**(1/3)}";
say "";

# Newtonova metoda - hledá kořen g'(x) = 0
say "1. Newtonova metoda:";
my @newton = newton-seq(1.5, &g-prime, &g-double-prime)[^5];
for @newton.kv -> $i, $x {
    printf "   %2d: x = %10.6f, g'(x) = %10.6f\n", $i + 1, $x, g-prime($x);
}
my $root-newton = find-zero(1.5, &g-prime, &g-double-prime);
say "   → x = $root-newton\n";

# Fibonacciho metoda - minimalizuje přímo g(x)
say "2. Fibonacciho metoda (n=15):";
my @fib-intervals = fibonacci-intervals(1.0, 2.0, &g, 15).eager;
for @fib-intervals.kv -> $i, $state {
    printf "   %2d: [%10.6f, %10.6f], délka = %.6f\n", $i + 1, $state.a, $state.b, $state.b - $state.a;
}
my $root-fib = fibonacci-min(1.0, 2.0, &g, 15);
say "   → x = $root-fib\n";

# Metoda zlatého řezu - minimalizuje přímo g(x)
say "3. Metoda zlatého řezu:";
my @golden-intervals = golden-section-intervals(1.0, 2.0, &g)[^15].eager;
for @golden-intervals.kv -> $i, $state {
    printf "   %2d: [%10.6f, %10.6f], délka = %.6f\n", $i + 1, $state.a, $state.b, $state.b - $state.a;
}
my $root-golden = golden-section-min(1.0, 2.0, &g);
say "   → x = $root-golden\n";

# Gradientní metoda - minimalizuje g(x) pomocí g'(x)
say "4. Gradientní metoda (α=0.01):";
my @grad = gradient-seq(1.5, &g-prime, 0.01)[^15];
for @grad.kv -> $i, $x {
    printf "   %2d: x = %10.6f, g'(x) = %10.6f\n", $i + 1, $x, g-prime($x);
}
my $root-grad = gradient-descent(1.5, &g-prime, 0.01);
say "   → x = $root-grad\n";

say "=" x 60;
my $expected = (7/4)**(1/3);
say "Výsledky:";
printf "   Newton:           %10.6f (chyba: %.2e)\n", $root-newton, abs($root-newton - $expected);
printf "   Fibonacci:        %10.6f (chyba: %.2e)\n", $root-fib, abs($root-fib - $expected);
printf "   Zlatý řez:        %10.6f (chyba: %.2e)\n", $root-golden, abs($root-golden - $expected);
printf "   Gradient:         %10.6f (chyba: %.2e)\n", $root-grad, abs($root-grad - $expected);
