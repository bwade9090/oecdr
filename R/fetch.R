#' Fetch OECD data (CSV → tibble)
#' @inheritParams build_oecd_url
#' @return tibble::tibble()
#' @export
fetch_oecd_csv <- function(dataset, key=".", start_period=NULL, end_period=NULL, labels=TRUE) {
  url <- build_oecd_url(dataset, key, start_period, end_period, labels)
  df  <- utils::read.csv(url, check.names = FALSE)
  tibble::as_tibble(df)
}
