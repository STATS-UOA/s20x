# Quarterly Alcohol Available for Consumption in New Zealand

Quarterly alcohol available for consumption in New Zealand from 1935 to
2021. The data give volumes of alcoholic beverages available for
consumption, grouped into broad beverage categories.

## Format

A data frame with quarterly observations on 4 variables.

- year:

  Integer Year.

- month:

  Ordered factor giving the month at the end of the quarter.

- volume:

  Numeric volume available for consumption, in million litres.

- category:

  Factor beverage category: \`Total beer\`, \`Total wine\`, or \`Total
  spirits\`.

## Source

Stats NZ, Alcohol available for consumption: Year ended December 2021.

## Details

The \`month\` variable gives the month ending the quarter. It should be
treated in calendar order for plotting and summaries. For this quarterly
data set the intended order is March, June, September, and December.

The \`category\` variable has three levels:

- \`Total beer\`:

  Total beer available for consumption.

- \`Total wine\`:

  Total wine available for consumption.

- \`Total spirits\`:

  Total spirits and spirit-based drinks available for consumption.
