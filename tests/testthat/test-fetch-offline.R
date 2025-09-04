test_that("sample CSV loads offline", {
  f <- system.file("extdata", "cli_sample.csv", package = "oecdr")
  skip_if_not(file.exists(f), "no sample CSV")
  df <- readr::read_csv(f, show_col_types = FALSE)
  expect_s3_class(df, "tbl_df")
  expect_gt(nrow(df), 0)
})
