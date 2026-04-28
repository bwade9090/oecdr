# oecdr 0.1.1

* `fetch_oecd_csv()` now uses `httr2` for HTTP transport. HTTP 4xx and
  5xx responses raise classed `httr2` errors instead of silently
  parsing an HTML error page as CSV.
* Added a `timeout` argument to `fetch_oecd_csv()` (default 30s) so a
  hung connection cannot stall the caller.
* Added a `required_cols` argument to `fetch_oecd_csv()` (default
  `NULL`) so callers can validate dataset-specific schemas. `oecdr`
  itself does not hard-code any column set, since OECD datasets vary.
* `fetch_oecd_csv()` now raises informative errors when the response
  body is empty or when parsing yields zero rows or columns.
* Switched the CSV parser from `utils::read.csv()` to
  `readr::read_csv()`, dropping `utils` from `Imports`.

# oecdr 0.1.0

* Added tools for building OECD SDMX REST API URLs.
* Added CSV fetching into tibbles and DBI-based database persistence.
* Added SQLite support by default and optional PostgreSQL support.
* Added testthat tests that run under R CMD check.
* Added GitHub metadata and package build hygiene improvements.
