# data-raw/make_sample.R
# 개발자용 스크립트: 샘플 CSV를 갱신하고 싶을 때 사용하세요.
# 패키지 루트에서 실행:
#   devtools::load_all("."); source("data-raw/make_sample.R")
if (!requireNamespace("devtools", quietly = TRUE)) install.packages("devtools")
devtools::load_all(".")
dir.create("inst/extdata", recursive = TRUE, showWarnings = FALSE)
sample_url <- build_oecd_url(
  dataset = "OECD.SDD.STES,DSD_STES@DF_CLI",
  key = ".M.LI...AA...H",
  start_period = "2023-02",
  labels = TRUE
)
message("Downloading: ", sample_url)
download.file(sample_url, destfile = "inst/extdata/cli_sample.csv", mode = "wb")
message("Saved to inst/extdata/cli_sample.csv")
