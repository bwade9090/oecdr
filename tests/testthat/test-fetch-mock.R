mock_response <- function(status = 200L, body = "") {
  list(httr2::response(status_code = status, body = charToRaw(body)))
}

test_that("fetch_oecd_csv returns a tibble on a successful response", {
  csv <- "TIME_PERIOD,MEASURE,OBS_VALUE\n2023-02,CLI,100.2\n2023-03,CLI,100.1\n"
  httr2::local_mocked_responses(mock_response(body = csv))

  df <- fetch_oecd_csv("OECD.X,DSD@DF_X", ".M.X")
  expect_s3_class(df, "tbl_df")
  expect_equal(nrow(df), 2L)
  expect_named(df, c("TIME_PERIOD", "MEASURE", "OBS_VALUE"))
})

test_that("fetch_oecd_csv surfaces HTTP 404 as a classed httr2 error", {
  httr2::local_mocked_responses(mock_response(status = 404L, body = "Not Found"))
  expect_error(
    fetch_oecd_csv("OECD.X,DSD@DF_X", ".M.X"),
    class = "httr2_http_404"
  )
})

test_that("fetch_oecd_csv surfaces HTTP 500 as a classed httr2 error", {
  httr2::local_mocked_responses(mock_response(status = 500L, body = "Server Error"))
  expect_error(
    fetch_oecd_csv("OECD.X,DSD@DF_X", ".M.X"),
    class = "httr2_http_500"
  )
})

test_that("fetch_oecd_csv errors when the response body is empty", {
  httr2::local_mocked_responses(mock_response(body = ""))
  expect_error(
    fetch_oecd_csv("OECD.X,DSD@DF_X", ".M.X"),
    "response body is empty"
  )
})

test_that("fetch_oecd_csv errors when parsing yields zero rows", {
  csv <- "TIME_PERIOD,MEASURE,OBS_VALUE\n"
  httr2::local_mocked_responses(mock_response(body = csv))
  expect_error(
    fetch_oecd_csv("OECD.X,DSD@DF_X", ".M.X"),
    "0 rows or 0 columns"
  )
})

test_that("fetch_oecd_csv enforces required_cols when callers supply them", {
  csv <- "A,B\n1,2\n3,4\n"
  httr2::local_mocked_responses(mock_response(body = csv))
  expect_error(
    fetch_oecd_csv("OECD.X,DSD@DF_X", ".M.X",
                   required_cols = c("A", "B", "C")),
    "Missing required column"
  )
})

test_that("fetch_oecd_csv passes when required_cols are all present", {
  csv <- "A,B\n1,2\n3,4\n"
  httr2::local_mocked_responses(mock_response(body = csv))
  df <- fetch_oecd_csv("OECD.X,DSD@DF_X", ".M.X",
                       required_cols = c("A", "B"))
  expect_named(df, c("A", "B"))
  expect_equal(nrow(df), 2L)
})
