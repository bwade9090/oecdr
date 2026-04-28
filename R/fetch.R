#' Fetch OECD data via the SDMX REST API
#'
#' Builds the SDMX REST URL for the given `dataset` and `key`, performs an
#' HTTP GET with [httr2::req_perform()], parses the CSV body with
#' [readr::read_csv()], and returns a [tibble::tibble()]. Raises informative
#' errors if the response body is empty, parses to zero rows or columns, or
#' omits any columns named in `required_cols`. HTTP 4xx and 5xx responses
#' surface as classed `httr2` errors.
#'
#' @inheritParams build_oecd_url
#' @param timeout HTTP request timeout in seconds. Forwarded to
#'   [httr2::req_timeout()]. Default 30.
#' @param required_cols Optional character vector of column names that must
#'   be present in the parsed response. If `NULL` (default) the column-name
#'   check is skipped. Supplied so callers can validate dataset-specific
#'   schemas without `oecdr` hard-coding any column set.
#' @return A [tibble::tibble()] of the OECD response.
#' @examples
#' \dontrun{
#' fetch_oecd_csv(
#'   dataset       = "OECD.SDD.STES,DSD_STES@DF_CLI",
#'   key           = ".M.LI...AA...H",
#'   start_period  = "2023-02",
#'   required_cols = c("TIME_PERIOD", "OBS_VALUE")
#' )
#' }
#' @export
fetch_oecd_csv <- function(dataset, key = ".",
                           start_period = NULL, end_period = NULL,
                           labels = TRUE,
                           timeout = 30, required_cols = NULL) {
  url <- build_oecd_url(dataset, key, start_period, end_period, labels)

  resp <- httr2::req_perform(httr2::req_timeout(httr2::request(url), timeout))

  if (!httr2::resp_has_body(resp)) {
    stop("OECD SDMX response body is empty (URL: ", url, ").", call. = FALSE)
  }
  body <- httr2::resp_body_string(resp)

  df <- readr::read_csv(I(body), show_col_types = FALSE, progress = FALSE)

  if (nrow(df) == 0L || ncol(df) == 0L) {
    stop("Parsed OECD response has 0 rows or 0 columns (URL: ", url, ").",
         call. = FALSE)
  }

  if (!is.null(required_cols)) {
    missing_cols <- setdiff(required_cols, names(df))
    if (length(missing_cols) > 0L) {
      stop("Missing required column(s): ",
           paste(missing_cols, collapse = ", "),
           " (have: ", paste(names(df), collapse = ", "), ").",
           call. = FALSE)
    }
  }

  tibble::as_tibble(df)
}
