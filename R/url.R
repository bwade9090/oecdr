#' Build OECD SDMX REST URL
#'
#' @param dataset character(1). The SDMX dataset identifier, for example
#'   `"OECD.SDD.STES,DSD_STES@DF_CLI"`.
#' @param key character(1). The SDMX key path. Use `"."` to match all values
#'   on every dimension. Example: `".M.LI...AA...H"`.
#' @param start_period Optional `"YYYY"` or `"YYYY-MM"` start of the time
#'   range. `NULL` (default) omits the filter.
#' @param end_period Optional `"YYYY"` or `"YYYY-MM"` end of the time range.
#'   `NULL` (default) omits the filter.
#' @param labels If `TRUE` (default), the URL requests CSV with labels
#'   (`csvfilewithlabels`); if `FALSE`, codes only (`csv`).
#' @return A URL character string.
#' @examples
#' build_oecd_url(
#'   dataset      = "OECD.SDD.STES,DSD_STES@DF_CLI",
#'   key          = ".M.LI...AA...H",
#'   start_period = "2023-02"
#' )
#' @export
build_oecd_url <- function(dataset, key=".", start_period=NULL, end_period=NULL, labels=TRUE) {
  stopifnot(is.character(dataset), length(dataset) == 1)
  stopifnot(is.character(key), length(key) == 1)
  base <- "https://sdmx.oecd.org/public/rest/data"
  fmt  <- if (isTRUE(labels)) "csvfilewithlabels" else "csv"
  path <- paste0(base, "/", dataset, "/", key)

  qs <- list(
    dimensionAtObservation = "AllDimensions",
    format = fmt
  )
  if (!is.null(start_period)) qs$startPeriod <- start_period
  if (!is.null(end_period))   qs$endPeriod   <- end_period

  q <- paste0(names(qs), "=", unlist(qs), collapse="&")
  paste0(path, "?", q)
}
