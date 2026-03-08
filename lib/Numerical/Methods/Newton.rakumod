unit module Numerical::Methods::Newton;

# Newtonova metoda - hledání nulového bodu

sub newton-step ($x, &f, &df) is export {
    $x - f($x) / df($x)
}

sub newton-seq ($x0, &f, &df) is export {
    my &iter = &newton-step.assuming(*, &f, &df);
    $x0, &iter ... *
}

sub find-zero ($x0, &f, &df, :$tol=1e-10) is export {
    my $*TOLERANCE = $tol;

    newton-seq($x0, &f, &df)
    andthen .first: { f($_) ≅ 0 }
}
