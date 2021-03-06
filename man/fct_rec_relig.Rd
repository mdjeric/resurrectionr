% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/fct_rec_relig.R
\name{fct_rec_relig}
\alias{fct_rec_relig}
\title{Basic religion recoding.}
\usage{
fct_rec_relig(religion, denomination, other)
}
\arguments{
\item{religion, denomination, other}{Factors.}
}
\value{
Character vector with recoded religion.
}
\description{
With correct parameters, it effectievly recodes
the religion variables. \code{\link{recode_religion}} wraps it,
and conducts series of checks to confirm that variables for
recoding are good and that it will produce a correct religious
identification. In addition, \code{\link{recode_religion}} allows
for more flexibility in terms of output. However, this function
is the essence of the package, and contains details about logic
of the recoding schema, and can also be inspected at
\href{https://github.com/mdjeric/resurrectionr/R/recode_religion_only-factors.R}{github.com/mdjeric/resurrectionr}
}
