# RUNME.R — 초기 세팅 스크립트
# 패키지 루트에서 실행하세요.

if (!requireNamespace("devtools", quietly = TRUE)) install.packages("devtools")
if (!requireNamespace("testthat", quietly = TRUE)) install.packages("testthat")
if (!requireNamespace("tibble", quietly = TRUE)) install.packages("tibble")
if (!requireNamespace("DBI", quietly = TRUE)) install.packages("DBI")
if (!requireNamespace("RSQLite", quietly = TRUE)) install.packages("RSQLite")
if (!requireNamespace("RPostgres", quietly = TRUE)) install.packages("RPostgres")
if (!requireNamespace("readr", quietly = TRUE)) install.packages("readr")
if (!requireNamespace("lintr", quietly = TRUE)) install.packages("lintr")
if (!requireNamespace("pkgdown", quietly = TRUE)) install.packages("pkgdown")

devtools::document()  # NAMESPACE, Rd 생성
devtools::check()
devtools::install()

message("Done. See README.Rmd for usage examples.")
