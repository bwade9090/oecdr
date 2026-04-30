test_that("URL builder makes expected query", {
  url <- build_oecd_url("OECD.SDD.STES,DSD_STES@DF_CLI", ".M.LI...AA...H", start_period = "2023-02")
  expect_true(grepl("format=csvfilewithlabels", url))
  expect_true(grepl("dimensionAtObservation=AllDimensions", url))
})

test_that("URL builder includes endPeriod when supplied alone", {
  url <- build_oecd_url("DS", ".", end_period = "2024-01")
  expect_true(grepl("endPeriod=2024-01", url, fixed = TRUE))
  expect_false(grepl("startPeriod", url, fixed = TRUE))
})

test_that("URL builder includes both startPeriod and endPeriod when supplied", {
  url <- build_oecd_url("DS", ".", start_period = "2023", end_period = "2024")
  expect_true(grepl("startPeriod=2023", url, fixed = TRUE))
  expect_true(grepl("endPeriod=2024", url, fixed = TRUE))
})

test_that("URL builder switches format to plain csv when labels = FALSE", {
  url <- build_oecd_url("DS", ".", labels = FALSE)
  expect_false(grepl("csvfilewithlabels", url, fixed = TRUE))
  expect_true(grepl("format=csv", url, fixed = TRUE))
})

test_that("URL builder uses default key '.' when omitted", {
  url <- build_oecd_url("DS")
  expect_true(grepl("/DS/.?", url, fixed = TRUE))
})

test_that("URL builder rejects non-character or wrong-length dataset", {
  expect_error(build_oecd_url(123, "."), "is.character")
  expect_error(build_oecd_url(c("a", "b"), "."), "length")
})

test_that("URL builder rejects non-character or wrong-length key", {
  expect_error(build_oecd_url("DS", 123), "is.character")
  expect_error(build_oecd_url("DS", c("a", "b")), "length")
})
