test_that("URL builder makes expected query", {
  url <- build_oecd_url("OECD.SDD.STES,DSD_STES@DF_CLI", ".M.LI...AA...H", start_period="2023-02")
  expect_true(grepl("format=csvfilewithlabels", url))
  expect_true(grepl("dimensionAtObservation=AllDimensions", url))
})
