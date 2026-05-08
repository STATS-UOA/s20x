rawData = read.csv(
  file = file.path("data-raw", "nzarrivals-source.csv"),
  header = FALSE,
  skip = 3,
  stringsAsFactors = FALSE,
  check.names = FALSE
)

names(rawData) = c("period", "arrivals.count")
periodRows = grepl("^[0-9]{4}M[0-9]{2}$", rawData$period)
rawData = rawData[periodRows, , drop = FALSE]

year = as.integer(substr(rawData$period, 1, 4))
monthNumber = as.integer(substr(rawData$period, 6, 7))
month = factor(month.abb[monthNumber], levels = month.abb)
arrivals.count = as.integer(rawData$arrivals.count)

nzarrivals.df = data.frame(
  year = year,
  month = month,
  arrivals.count = arrivals.count
)

if (anyNA(nzarrivals.df$year) || anyNA(nzarrivals.df$month)) {
  stop("Could not parse all year/month values in nzarrivals-source.csv", call. = FALSE)
}

if (!dir.exists("data")) {
  dir.create("data")
}

save(nzarrivals.df, file = file.path("data", "nzarrivals.df.rda"), compress = "xz")
