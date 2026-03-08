#!/usr/bin/env raku
#
# Porovnání numerických metod pro hledání extrému
# Ekvivalent k Julia bin/demo.jl
#

use lib 'lib';
use Numerical::Methods;

# Funkce, jejíž extrém hledáme: g(x) = x³-7x
sub g($x) { $x**3 - 7*$x }
sub g-prime($x) { 3*$x**2 - 7 }
sub g-double-prime($x) { 6*$x }

# Pro Fibonacci a zlatý řez minimalizujeme (g'(x))²
sub g-prime-sq($x) { g-prime($x)**2 }
sub g-prime-sq-der($x) { 2 * g-prime($x) * g-double-prime($x) }

say "Porovnání numerických metod pro g(x) = x³-7x";
say "=" x 60;
say "Hledáme minimum: g'(x) = 0 na intervalu [1, 3]";
say "Očekávaný výsledek: √(7/3) = {sqrt(7/3)}";
say "";

# Newtonova metoda
say "1. Newtonova metoda:";
my @newton = newton-seq(2.0, &g-prime, &g-double-prime)[^5];
for @newton.kv -> $i, $x {
    printf "   %2d: x = %10.6f, g'(x) = %10.6f\n", $i + 1, $x, g-prime($x);
}
my $root-newton = find-zero(2.0, &g-prime, &g-double-prime);
say "   → x = $root-newton\n";

# Fibonacciho metoda (minimalizuje (g'(x))²)
say "2. Fibonacciho metoda (n=10):";
my @fib-intervals = fibonacci-intervals(1.0, 3.0, &g-prime-sq, 10).eager;
for @fib-intervals.kv -> $i, $state {
    printf "   %2d: [%10.6f, %10.6f], délka = %.6f\n", $i + 1, $state.a, $state.b, $state.b - $state.a;
}
my $root-fib = fibonacci-min(1.0, 3.0, &g-prime-sq, 10);
say "   → x = $root-fib\n";

# Metoda zlatého řezu (minimalizuje (g'(x))²)
say "3. Metoda zlatého řezu:";
my @golden-intervals = golden-section-intervals(1.0, 3.0, &g-prime-sq)[^10].eager;
for @golden-intervals.kv -> $i, $state {
    printf "   %2d: [%10.6f, %10.6f], délka = %.6f\n", $i + 1, $state.a, $state.b, $state.b - $state.a;
}
my $root-golden = golden-section-min(1.0, 3.0, &g-prime-sq);
say "   → x = $root-golden\n";

# Gradientní metoda na (g'(x))² - potřebuje malý krok
say "4. Gradientní metoda (α=0.001):";
my @grad = gradient-seq(2.0, &g-prime-sq-der, 0.001)[^15];
for @grad.kv -> $i, $x {
    printf "   %2d: x = %10.6f, g'(x) = %10.6f\n", $i + 1, $x, g-prime($x);
}
my $root-grad = gradient-descent(2.0, &g-prime-sq-der, 0.001);
say "   → x = $root-grad\n";

say "=" x 60;
say "Výsledky:";
printf "   Newton:           %10.6f (chyba: %.2e)\n", $root-newton, abs($root-newton - sqrt(7/3));
printf "   Fibonacci:        %10.6f (chyba: %.2e)\n", $root-fib, abs($root-fib - sqrt(7/3));
printf "   Zlatý řez:        %10.6f (chyba: %.2e)\n", $root-golden, abs($root-golden - sqrt(7/3));
printf "   Gradient:         %10.6f (chyba: %.2e)\n", $root-grad, abs($root-grad - sqrt(7/3));
