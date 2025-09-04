#' Get a DBI connection from env (Postgres) or fallback to SQLite
#' @param drv "RPostgres" or "RSQLite"
#' @export
oecdr_connect <- function(drv = c("RSQLite","RPostgres")) {
  drv <- match.arg(drv)
  if (drv == "RPostgres") {
    if (!requireNamespace("RPostgres", quietly = TRUE)) stop("Install RPostgres")
    con <- DBI::dbConnect(
      RPostgres::Postgres(),
      host = Sys.getenv("PGHOST","localhost"),
      port = as.integer(Sys.getenv("PGPORT","5432")),
      user = Sys.getenv("PGUSER","postgres"),
      password = Sys.getenv("PGPASSWORD",""),
      dbname = Sys.getenv("PGDATABASE","postgres"),
      sslmode = Sys.getenv("PGSSLMODE","prefer")
    )
  } else {
    if (!requireNamespace("RSQLite", quietly = TRUE)) stop("Install RSQLite")
    con <- DBI::dbConnect(RSQLite::SQLite(), dbname = tempfile(fileext = ".sqlite"))
  }
  con
}

#' Write a data.frame to a DB table
#' @param df data.frame/tibble
#' @param table table name
#' @param con optional DBI connection. If NULL, creates a SQLite temp DB.
#' @param overwrite overwrite table if exists
#' @param append append rows when table exists and overwrite=FALSE
#' @export
write_db <- function(df, table, con = NULL, overwrite = FALSE, append = TRUE) {
  stopifnot(is.data.frame(df), is.character(table), length(table) == 1)
  local_con <- is.null(con)
  if (local_con) con <- oecdr_connect("RSQLite")
  on.exit(if (local_con) DBI::dbDisconnect(con), add = TRUE)

  if (overwrite && DBI::dbExistsTable(con, table)) DBI::dbRemoveTable(con, table)
  DBI::dbWriteTable(con, table, df, append = append, overwrite = overwrite)
  invisible(TRUE)
}
