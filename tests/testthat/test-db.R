test_that("write_db works with SQLite", {
  df <- tibble::tibble(x = 1:3, y = letters[1:3])
  con <- oecdr_connect("RSQLite")
  on.exit(DBI::dbDisconnect(con), add = TRUE)
  res <- write_db(df, "oecd_data", con = con, overwrite = TRUE, append = FALSE)
  expect_true(isTRUE(res))
  expect_true("oecd_data" %in% DBI::dbListTables(con))
  expect_equal(DBI::dbGetQuery(con, "SELECT COUNT(*) n FROM oecd_data")$n, 3L)
})

test_that("write_db appends rows when overwrite = FALSE and append = TRUE", {
  df1 <- tibble::tibble(x = 1:2, y = letters[1:2])
  df2 <- tibble::tibble(x = 3:4, y = letters[3:4])
  con <- oecdr_connect("RSQLite")
  on.exit(DBI::dbDisconnect(con), add = TRUE)
  write_db(df1, "tbl", con = con, overwrite = TRUE, append = FALSE)
  write_db(df2, "tbl", con = con, overwrite = FALSE, append = TRUE)
  expect_equal(DBI::dbGetQuery(con, "SELECT COUNT(*) n FROM tbl")$n, 4L)
})

test_that("write_db replaces rows when overwrite = TRUE on an existing table", {
  df1 <- tibble::tibble(x = 1:5)
  df2 <- tibble::tibble(x = 1:3)
  con <- oecdr_connect("RSQLite")
  on.exit(DBI::dbDisconnect(con), add = TRUE)
  write_db(df1, "tbl", con = con, overwrite = TRUE, append = FALSE)
  write_db(df2, "tbl", con = con, overwrite = TRUE, append = FALSE)
  expect_equal(DBI::dbGetQuery(con, "SELECT COUNT(*) n FROM tbl")$n, 3L)
})

test_that("write_db opens its own SQLite connection when con = NULL", {
  df <- tibble::tibble(x = 1:2)
  res <- write_db(df, "tbl", overwrite = TRUE, append = FALSE)
  expect_true(isTRUE(res))
})

test_that("write_db rejects non-data.frame input", {
  expect_error(write_db(list(a = 1), "tbl"), "is.data.frame")
})

test_that("write_db rejects a non-character table name", {
  expect_error(write_db(tibble::tibble(x = 1), 123), "is.character")
})

test_that("write_db rejects a multi-element table name", {
  expect_error(write_db(tibble::tibble(x = 1), c("a", "b")), "length")
})

test_that("oecdr_connect rejects an unknown driver name via match.arg", {
  expect_error(oecdr_connect("unknown"), "should be one of")
})
