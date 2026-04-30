
<!-- README.md is generated from README.Rmd. Please edit that file -->

# oecdr

<!-- badges: start -->

[![R-CMD-check](https://github.com/bwade9090/oecdr/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/bwade9090/oecdr/actions/workflows/R-CMD-check.yaml)
[![Codecov test
coverage](https://codecov.io/gh/bwade9090/oecdr/branch/main/graph/badge.svg)](https://app.codecov.io/gh/bwade9090/oecdr?branch=main)
[![lint](https://github.com/bwade9090/oecdr/actions/workflows/lint.yaml/badge.svg)](https://github.com/bwade9090/oecdr/actions/workflows/lint.yaml)
[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
<!-- badges: end -->

## Overview

`oecdr` provides utilities for working with the [OECD SDMX REST
API](https://sdmx.oecd.org/): build query URLs, fetch CSV responses into
tibbles, and persist them to a relational database via the
[DBI](https://dbi.r-dbi.org/) interface. SQLite is supported by default,
with optional PostgreSQL.

The package targets reproducible OECD-data workflows in R: fetch once,
store locally or in a shared database, analyse downstream.

## Installation

You can install the development version of `oecdr` from GitHub:

``` r
# install.packages("pak")
pak::pak("bwade9090/oecdr")

# or with remotes
# remotes::install_github("bwade9090/oecdr")
```

## Example

Build a SDMX REST URL, fetch a dataset, and write it to a local SQLite
table:

``` r
library(oecdr)

df <- fetch_oecd_csv(
  dataset      = "OECD.SDD.STES,DSD_STES@DF_CLI",
  key          = ".M.LI...AA...H",
  start_period = "2023-02"
)

write_db(df, "oecd_cli")
```

`fetch_oecd_csv()` returns a tibble; `write_db()` opens a temporary
SQLite connection by default and writes the table.

## Database backends

`oecdr_connect()` returns a `DBI` connection. The default driver is
`RSQLite`, which writes to a temporary file. PostgreSQL is supported as
an optional backend; install the `RPostgres` package and provide
credentials via the standard `PG*` environment variables (`PGHOST`,
`PGPORT`, `PGUSER`, `PGPASSWORD`, `PGDATABASE`, `PGSSLMODE`):

``` r
con <- oecdr_connect("RPostgres")
write_db(df, "oecd_cli", con = con, overwrite = TRUE, append = FALSE)
DBI::dbDisconnect(con)
```

## Quality signals

- Tests are written with [testthat](https://testthat.r-lib.org/) (3rd
  edition) and run under `R CMD check`.
- Continuous integration via GitHub Actions ([R-CMD-check
  workflow](https://github.com/bwade9090/oecdr/actions/workflows/R-CMD-check.yaml)).
- Changelog tracked in [`NEWS.md`](NEWS.md).

## License

MIT (c) Hyungbae Cho. See [LICENSE](LICENSE) for details.
