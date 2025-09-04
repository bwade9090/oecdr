test_that("write_db works with SQLite", {
  df <- tibble::tibble(x = 1:3, y = letters[1:3])
  con <- oecdr_connect("RSQLite")
  on.exit(DBI::dbDisconnect(con), add = TRUE)
  res <- write_db(df, "oecd_data", con = con, overwrite = TRUE, append = FALSE)
  expect_true(isTRUE(res))
  expect_true("oecd_data" %in% DBI::dbListTables(con))
  expect_equal(DBI::dbGetQuery(con, "SELECT COUNT(*) n FROM oecd_data")$n, 3L)
})
