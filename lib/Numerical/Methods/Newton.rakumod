unit module Numerical::Methods::Newton;

# Newtonova metoda - hledání nulového bodu

our &newton-step  is export = sub ($x, &f, &df) {
    $x - f($x) / df($x)
}

our &newton-seq   is export = sub ($x0, &f, &df) {
    my $x = $x0;
    lazy gather {
        loop {
            take $x;
            $x = newton-step($x, &f, &df);
        }
    }
}

our &find-zero    is export = sub ($x0, &f, &df, :$tol=1e-10) {
    first(-> $x { abs(f($x)) < $tol }, newton-seq($x0, &f, &df))
}
