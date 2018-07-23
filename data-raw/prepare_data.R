devtools::use_data_raw()
# Import GSS codebook for relig, denom, and other -------------------------

c_relig <- read.csv("data-raw/relig.csv")
c_denom <- read.csv("data-raw/denom.csv")
c_other <- read.csv("data-raw/other.csv")

rdo_cdbk <- list(relig = c_relig[-1],
                 denom = c_denom[-1],
                 other = c_other[-1]
                 )


# Import GSS data ---------------------------------------------------------

# First with foreign, as factors without use of missing values
# supress more than 50 warnings, undeclared levels
suppressWarnings(
  gss14_f <- foreign::read.spss("data-raw/.GSS2014.sav",
                                to.data.frame = TRUE,
                                trim.factor.names = TRUE,
                                trim_values = TRUE,
                                use.missings = FALSE
  )
)

# Then with haven and read_sav, with use of missing values
gss14_n <- haven::read_sav("data-raw/.GSS2014.sav")

# select four variables for examples
gss14_n <- gss14_n[, c("bible", "relig", "denom", "other")]
gss14_f <- gss14_f[, c("bible", "relig", "denom", "other")]

devtools::use_data(rdo_cdbk, gss14_n, gss14_f, overwrite = TRUE)
devtools::use_data(rdo_cdbk, gss14_n, gss14_f, internal = TRUE, overwrite = TRUE)
