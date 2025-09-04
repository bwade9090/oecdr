#' Build OECD SDMX REST URL
#'
#' @param dataset 문자열. 예: "OECD.SDD.STES,DSD_STES@DF_CLI"
#' @param key SDMX 키 경로. 모든 키는 "." 사용. 예: ".M.LI...AA...H"
#' @param start_period "YYYY" 또는 "YYYY-MM" (옵션)
#' @param end_period   "YYYY" 또는 "YYYY-MM" (옵션)
#' @param labels TRUE면 라벨 포함 CSV, FALSE면 코드만 CSV
#' @return URL 문자열
#' @examples
#' build_oecd_url("OECD.SDD.STES,DSD_STES@DF_CLI", ".M.LI...AA...H", start_period="2023-02")
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
