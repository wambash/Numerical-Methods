unit module Numerical::Methods::Gradient;

# Gradientní metoda - hledání minima

sub gradient-step ($x, &grad-f, $α) is export {
    $x - $α * grad-f($x)
}

sub gradient-seq ($x0, &grad-f, $α) is export {
    my &iter = &gradient-step.assuming(*, &grad-f, $α);
    $x0, &iter ... *
}

sub gradient-descent ($x0, &grad-f, $α, :$tol=1e-10) is export {
    my $*TOLERANCE = $tol;

    gradient-seq($x0, &grad-f, $α)
    andthen .first: { abs(grad-f($_)) ≅ 0 }
}
