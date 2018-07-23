#' Codebook for relig, denom, and other variables.
#'
#' A list containing data frames that have individual punches and
#' labels for \code{relig}, \code{denom}, and \code{other} variables, which are also
#' applicable for whole family of variables such as religious
#' identification at the age of 16, spouses, parents, etc. in General
#' Social Survey from 1972 until 2014. Some of these non-primariy
#' variables are often coded only with punches, and not with labels.
#' It's used in \code{\link{rdo_punches}}.
#'
#' @format A list containing three data frames:
#' \describe{
#'   \item{relig}{data frame with 16 observations and 2 variables:
#'   \code{punch}, numeric; \code{label} factor.}
#'   \item{denom}{data frame with 30 observations and 2 variables:
#'   \code{punch}, numeric; \code{label} factor.}
#'   \item{other}{data frame with 201 observation and 2 variables:
#'   \code{punch}, numeric; \code{label} factor.}
#' }
#' @source \href{http://www.gss.norc.org/Get-Documentation}{General Social Survey}
"rdo_cdbk"

#' GSS 2014 select variables as factors.
#'
#' Four varaibles from US Genearl Social Survey from 2014, three describe
#' respondent's religious identification(\code{relig}, \code{denom}, \code{other}),
#' and fourth \code{bible} is for biblical litteracy, or answers on the question
#' if the bible is "the word of god", "inspired word", "book of fables", or "other".
#' Data is used in vignettes, to demonstrate the use of
#' \code{\link{recode_religion}}, and to provide some comparison between
#' the use of packages \code{foreign} and \code{haven} in importing SPSS data
#' and their different recoding of categorical variables from GSS. \code{gss14_f}
#' was imported through \code{foreign}, with use of following options:
#' \code{to.data.frame = TRUE, trim.factor.names = TRUE, trim_values = TRUE,
#' use.missings = FALSE}, accordingly varaibles are factors without missing
#' values.
#'
#' @seealso \code{\link[foreign]{read.spss}} \code{\link[haven]{read_sav}}
#'
#' @format
#' \describe{A data frame with 2538 rows and 4 variables:
#'   \item{bible}{Factor, feelings about the bible.}
#'   \item{relig}{Factor, respondents religious preference.}
#'   \item{denom}{Factor, specific denomination.}
#'   \item{other}{Factor, other Protestant denominations.}
#' }
#'
#' @source \href{http://www.gss.norc.org/get-the-data/spss}{GSS 2014}
"gss14_f"

#' GSS 2014 select variables as numerical.
#'
#' Four varaibles from US Genearl Social Survey from 2014, three describe
#' respondent's religious identification(\code{relig}, \code{denom}, \code{other}),
#' and fourth \code{bible} is for biblical litteracy, or answers on the question
#' if the bible is "the word of god", "inspired word", "book of fables", or "other".
#' Data is used in vignettes, to demonstrate the use of
#' \code{\link{recode_religion}}, and to provide some comparison between
#' the use of packages \code{foreign} and \code{haven} in importing SPSS data
#' and their different recoding of categorical variables from GSS. \code{gss14_n}
#' was imported through \code{haven}, and thus variables are specific numeric
#' \code{labelled} variables, with attributes "label" for description,
#' "format.spss" for SPSS format, and "labels" which are names for levels.
#'
#' @seealso \code{\link[haven]{read_sav}} \code{\link[foreign]{read.spss}}
#'
#' @format
#' \describe{A data frame with 2538 rows and 4 variables:
#'   \item{bible}{Labelled num, feelings about the bible.}
#'   \item{relig}{Labelled num, respondents religious preference.}
#'   \item{denom}{Labelled num, specific denomination.}
#'   \item{other}{Labelled num, other Protestant denominations.}
#' }
#'
#' @source \href{http://www.gss.norc.org/get-the-data/spss}{GSS 2014}
"gss14_n"
