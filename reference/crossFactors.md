# Crossed Factors

Computes a factor that has a level for each combination of the factors
'fac1' and 'fac2'.

## Usage

``` r
crossFactors(x, fac2 = NULL, ...)

# Default S3 method
crossFactors(x, fac2 = NULL, ...)

# S3 method for class 'formula'
crossFactors(formula, fac2 = NULL, data = NULL, ...)
```

## Arguments

- x:

  the name of the first factor or a formula in the form `~ fac1 * fac2`

- fac2:

  the name of the second factor - ignored if `x` is a formula.

- ...:

  Optional arguments

- formula:

  a formula in the form `~ fac1 * fac2`

- data:

  an optional data frame in which to evaluate the formula

## Value

Returns a vector containing the factor which represents the interaction
of the given factors.

## Methods (by class)

- `crossFactors(default)`: Crossed Factors

- `crossFactors(formula)`: Crossed Factors

## Note

This function actually returns a `factor` now instead of a character
string, so coercion into a `factor` is no longer necessary.

Deprecated in s20x 3.3.6. Use
[`interaction()`](https://rdrr.io/r/base/interaction.html) instead.

## See also

[`factor`](https://rdrr.io/r/base/factor.html).

## Examples

``` r

## arousal data:
data(arousal.df)
gender.picture = crossFactors(arousal.df$gender, arousal.df$picture)
#> Warning: crossFactors() is deprecated; use interaction() instead.
gender.picture
#>   [1] male.nude.m      male.nude.m      male.nude.m      male.nude.m     
#>   [5] male.nude.m      male.nude.m      male.nude.m      male.nude.m     
#>   [9] male.nude.m      male.nude.m      male.nude.m      male.nude.m     
#>  [13] male.nude.m      male.nude.m      male.nude.m      male.nude.m     
#>  [17] male.nude.m      male.nude.m      male.nude.m      male.nude.m     
#>  [21] male.nude.f      male.nude.f      male.nude.f      male.nude.f     
#>  [25] male.nude.f      male.nude.f      male.nude.f      male.nude.f     
#>  [29] male.nude.f      male.nude.f      male.nude.f      male.nude.f     
#>  [33] male.nude.f      male.nude.f      male.nude.f      male.nude.f     
#>  [37] male.nude.f      male.nude.f      male.nude.f      male.nude.f     
#>  [41] male.infant      male.infant      male.infant      male.infant     
#>  [45] male.infant      male.infant      male.infant      male.infant     
#>  [49] male.infant      male.infant      male.infant      male.infant     
#>  [53] male.infant      male.infant      male.infant      male.infant     
#>  [57] male.infant      male.infant      male.infant      male.infant     
#>  [61] male.landscape   male.landscape   male.landscape   male.landscape  
#>  [65] male.landscape   male.landscape   male.landscape   male.landscape  
#>  [69] male.landscape   male.landscape   male.landscape   male.landscape  
#>  [73] male.landscape   male.landscape   male.landscape   male.landscape  
#>  [77] male.landscape   male.landscape   male.landscape   male.landscape  
#>  [81] female.nude.m    female.nude.m    female.nude.m    female.nude.m   
#>  [85] female.nude.m    female.nude.m    female.nude.m    female.nude.m   
#>  [89] female.nude.m    female.nude.m    female.nude.m    female.nude.m   
#>  [93] female.nude.m    female.nude.m    female.nude.m    female.nude.m   
#>  [97] female.nude.m    female.nude.m    female.nude.m    female.nude.m   
#> [101] female.nude.f    female.nude.f    female.nude.f    female.nude.f   
#> [105] female.nude.f    female.nude.f    female.nude.f    female.nude.f   
#> [109] female.nude.f    female.nude.f    female.nude.f    female.nude.f   
#> [113] female.nude.f    female.nude.f    female.nude.f    female.nude.f   
#> [117] female.nude.f    female.nude.f    female.nude.f    female.nude.f   
#> [121] female.infant    female.infant    female.infant    female.infant   
#> [125] female.infant    female.infant    female.infant    female.infant   
#> [129] female.infant    female.infant    female.infant    female.infant   
#> [133] female.infant    female.infant    female.infant    female.infant   
#> [137] female.infant    female.infant    female.infant    female.infant   
#> [141] female.landscape female.landscape female.landscape female.landscape
#> [145] female.landscape female.landscape female.landscape female.landscape
#> [149] female.landscape female.landscape female.landscape female.landscape
#> [153] female.landscape female.landscape female.landscape female.landscape
#> [157] female.landscape female.landscape female.landscape female.landscape
#> 8 Levels: female.infant female.landscape female.nude.f ... male.nude.m

## arousal data:
data(arousal.df)
gender.picture = crossFactors(~ gender * picture, data = arousal.df)
#> Warning: crossFactors() is deprecated; use interaction() instead.
gender.picture
#>   [1] male.nude.m      male.nude.m      male.nude.m      male.nude.m     
#>   [5] male.nude.m      male.nude.m      male.nude.m      male.nude.m     
#>   [9] male.nude.m      male.nude.m      male.nude.m      male.nude.m     
#>  [13] male.nude.m      male.nude.m      male.nude.m      male.nude.m     
#>  [17] male.nude.m      male.nude.m      male.nude.m      male.nude.m     
#>  [21] male.nude.f      male.nude.f      male.nude.f      male.nude.f     
#>  [25] male.nude.f      male.nude.f      male.nude.f      male.nude.f     
#>  [29] male.nude.f      male.nude.f      male.nude.f      male.nude.f     
#>  [33] male.nude.f      male.nude.f      male.nude.f      male.nude.f     
#>  [37] male.nude.f      male.nude.f      male.nude.f      male.nude.f     
#>  [41] male.infant      male.infant      male.infant      male.infant     
#>  [45] male.infant      male.infant      male.infant      male.infant     
#>  [49] male.infant      male.infant      male.infant      male.infant     
#>  [53] male.infant      male.infant      male.infant      male.infant     
#>  [57] male.infant      male.infant      male.infant      male.infant     
#>  [61] male.landscape   male.landscape   male.landscape   male.landscape  
#>  [65] male.landscape   male.landscape   male.landscape   male.landscape  
#>  [69] male.landscape   male.landscape   male.landscape   male.landscape  
#>  [73] male.landscape   male.landscape   male.landscape   male.landscape  
#>  [77] male.landscape   male.landscape   male.landscape   male.landscape  
#>  [81] female.nude.m    female.nude.m    female.nude.m    female.nude.m   
#>  [85] female.nude.m    female.nude.m    female.nude.m    female.nude.m   
#>  [89] female.nude.m    female.nude.m    female.nude.m    female.nude.m   
#>  [93] female.nude.m    female.nude.m    female.nude.m    female.nude.m   
#>  [97] female.nude.m    female.nude.m    female.nude.m    female.nude.m   
#> [101] female.nude.f    female.nude.f    female.nude.f    female.nude.f   
#> [105] female.nude.f    female.nude.f    female.nude.f    female.nude.f   
#> [109] female.nude.f    female.nude.f    female.nude.f    female.nude.f   
#> [113] female.nude.f    female.nude.f    female.nude.f    female.nude.f   
#> [117] female.nude.f    female.nude.f    female.nude.f    female.nude.f   
#> [121] female.infant    female.infant    female.infant    female.infant   
#> [125] female.infant    female.infant    female.infant    female.infant   
#> [129] female.infant    female.infant    female.infant    female.infant   
#> [133] female.infant    female.infant    female.infant    female.infant   
#> [137] female.infant    female.infant    female.infant    female.infant   
#> [141] female.landscape female.landscape female.landscape female.landscape
#> [145] female.landscape female.landscape female.landscape female.landscape
#> [149] female.landscape female.landscape female.landscape female.landscape
#> [153] female.landscape female.landscape female.landscape female.landscape
#> [157] female.landscape female.landscape female.landscape female.landscape
#> 8 Levels: female.infant female.landscape female.nude.f ... male.nude.m

```
