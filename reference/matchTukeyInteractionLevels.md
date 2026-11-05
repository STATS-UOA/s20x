# Match Tukey interaction comparisons to factor levels

Finds the levels of each factor in the two groups compared by each row
of an interaction \`TukeyHSD()\` table. Row names are matched against
the known levels, because splitting them on \`-\` and \`:\` fails when a
level contains either character.

## Usage

``` r
matchTukeyInteractionLevels(rowNames, levels1, levels2)
```

## Arguments

- rowNames:

  row names of the interaction Tukey table.

- levels1:

  levels of the first factor in the interaction.

- levels2:

  levels of the second factor in the interaction.

## Value

A list with \`group1Var1\`, \`group1Var2\`, \`group2Var1\`, and
\`group2Var2\`.
