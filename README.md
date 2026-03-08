# Numerical::Methods

Numerical methods for optimization in Raku.

## Description

This module provides lazy iterators for common numerical optimization methods:

- **Newton's method** - finding roots (zeros) of functions
- **Fibonacci method** - finding minimum on an interval  
- **Golden Section method** - finding minimum on an interval
- **Gradient descent** - finding minimum using gradient

## Installation

```bash
zef install .
```

## Usage

```raku
use Numerical::Methods;

# Newton's method
my $root = find-zero(2.0, -> $x { $x**2 - 2 }, -> $x { 2*$x });

# Fibonacci sequence
say fibonacci(10);  # 55

# Golden section minimum
my $min = golden-section-min(1.0, 3.0, -> $x { (3*$x**2 - 7)**2 });

# Gradient descent
my $min = gradient-descent(2.0, -> $x { 2*$x }, 0.1);
```

## Testing

```bash
prove -ve "raku -Ilib" t/
```

## Author

Jan Krňávek <krnavek@utb.cz>

## License

Artistic License 2.0
