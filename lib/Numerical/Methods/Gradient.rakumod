unit module Numerical::Methods::Gradient;

# Gradientní metoda

our &gradient-step is export = sub ($x, &grad-f, $α) {
    $x - $α * grad-f($x)
}

our &gradient-seq is export = sub ($x0, &grad-f, $α) {
    my $x = $x0;
    lazy gather {
        loop {
            take $x;
            $x = gradient-step($x, &grad-f, $α);
        }
    }
}

our &gradient-descent is export = sub ($x0, &grad-f, $α, :$tol=1e-10) {
    first(-> $x { abs(grad-f($x)) < $tol }, gradient-seq($x0, &grad-f, $α))
}
