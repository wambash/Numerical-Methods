# Numerical methods for optimization
# All methods implemented as lazy iterators
#
# Submodules:
# - Numerical::Methods::Newton      - Newton's method for finding roots
# - Numerical::Methods::Interval    - Fibonacci & Golden Section methods
# - Numerical::Methods::Gradient    - Gradient descent

use Numerical::Methods::Newton;
use Numerical::Methods::Interval;
use Numerical::Methods::Gradient;

sub EXPORT {
    %(
        '&newton-step'          => &newton-step,
        '&newton-seq'           => &newton-seq,
        '&find-zero'            => &find-zero,

        # Fibonacci method
        '@fibs'                 => @fibs,
        '&fibonacci-min'        => &fibonacci-min,

        # Golden Section method
        '&GOLDEN_RATIO'         => &GOLDEN_RATIO,
        '&GOLDEN_SECTION'       => &GOLDEN_SECTION,
        '&golden-section-min'   => &golden-section-min,

        # Gradient descent
        '&gradient-step'        => &gradient-step,
        '&gradient-seq'         => &gradient-seq,
        '&gradient-descent'     => &gradient-descent,
    )
}
