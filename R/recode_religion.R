#' Recode Religion from GSS.
#'
#' Function recodes religious identification from Genearl Social Survey,
#' based on three variables: \code{relig}, \code{denom}, and \code{other}.
#' It can successfully recode either respondent's, or any other religious
#' identification which is determened by coresponding three variables.
#'
#' \code{recode_religion} uses schema developed by Darren E. Sherkat and
#' Derek Lehman in \href{https://iranianredneck.wordpress.com/2016/11/29/why-reltrad-sucks-contesting-the-measure-of-american-religion/}{"After
#' The Resurrection: The Field of the Sociology of Religion in the United
#' States"}, and is effectievly translation of that SPSS syntax (the bare
#' bone function for recoding is \link{fct_rec_relig}), with
#' additional functionality.
#'
#' Namley, it can handle both punches and labels
#' at the same time (but in different variables), which is important since
#' punches are not consequtive as indexes. In addition, function checks that
#' variables are adequate (i.e. that all values are in codebook) and of same
#' length, and also handles missing values: (1) if supplied through values,
#' provides detail recoding; (2) if \code{NA}, lumps them together in final
#' variable but uses them correctly in the recoding. Through passed
#' arguments, one can:
#' \enumerate{
#'   \item Add identifications from schema that are not present in
#'   sample as empty levels.
#'   \item Suppress printing of the frequencies of newly recoded variable.
#'   \item Print unique key of the values that were recoded.
#'   \item Return values as numerical factor, in which case the codebook
#'   for new variable will be printed.
#' }
#' If \code{frequencies} is passed as \code{FALSE}, and numerical vector
#' is not requested as return value, all other information, such as
#' treatment of missing values, are provided as messages that can be
#' suppressed.
#'
#' Future behavior will provide recoding to 7 levels. More details can be
#' found on \href{https://github.mdjeric}{github.mdjeric}.
#'
#' @param relig,denom,other Numerical, character, or factor, all of same
#' length and with coresponding punches or labels in codebook.
#' @param n_groups Number 12, i.e. number of new religious identifications.
#' @param add_missing_levels Logical, to include as empty levels religious
#' identifications that may not be present in specific sample, but are
#' part of recoding schema.
#' @param frequencies Logical, to print frequency and percent table of
#' recoded religius identification (default is \code{TRUE}).
#' @param print_key Logical, to print the all unique tetrads of recoded
#' variables, i.e. a recoding key.
#' @param return_num Logical, to return numerical factor and print codebook.
#'
#' @return Vector with recoded religion from \code{relig}, \code{denom},
#' and \code{other}. Function does not return \code{NA}, but as
#' factor levels "Not answered" and "Don't know", or combined
#' "Not answered/Don't know" when missing values are not
#' declared as punches or labels in initial variables but passed on as
#' \code{NA} (function gives message and where \code{NAs} are lcoated).
#' Default is to have factor with 12 descriptive levels, but function can
#' also return numerical vector. Default behavior returns only present
#' values, but can be made to add additional empty levels if \code{TRUE}
#' is passed to \code{add_missing_levels}. Function also \strong{prints}
#' frequency table of newly recoded religious identification, which can be
#' suppressed with \code{frequencies}. If required, it can also return
#' numerical vector and print the coding for it (not recommended).
#'
#' @examples
#' library(resurrectionr)
#'
#' # When all variables are factor
#' gss14_f$religion <- recode_religion(gss14_f$relig, gss14_f$denom,
#'                                     gss14_f$other, frequencies = FALSE)
#'
#' # When all variables are numeric
#' gss14_n$religion <- recode_religion(gss14_n$relig, gss14_n$denom,
#'                                     gss14_n$other,
#'                                     add_missing_levels = TRUE)
#'
#' # But also, combining them works
#' religion <- recode_religion(gss14_f$relig, gss14_n$denom,
#'                             as.character(gss14_f$other))
#' @export
recode_religion <- function(relig, denom, other, n_groups = 12,
                            add_missing_levels = FALSE, frequencies = TRUE,
                            print_key = FALSE, return_num = FALSE)  {

# Check that all arguments are of appropriate type ------------------------

  arg_err <- list(error = FALSE, name = c(), type = c())

  if (!(is.numeric(relig) | is.factor(relig) | is.character(relig)))
    arg_err <- add_error(arg_err, "relig",
                         "vector (numeric or character) or factor")

  if (!(is.numeric(denom) | is.factor(denom) | is.character(denom)))
    arg_err <- add_error(arg_err, "denom",
                         "vector (numeric or character) or factor")

  if (!(is.numeric(other) | is.factor(other) | is.character(other)))
    arg_err <- add_error(arg_err, "other",
                         "vector (numeric or character) or factor")

  if (as.character(n_groups) != "12")
    arg_err <- add_error(arg_err, "n_groups", "12")

  if (!is.logical(add_missing_levels))
    arg_err <- add_error(arg_err, "add_missing_levels", "logical")

  if (!is.logical(frequencies))
    arg_err <- add_error(arg_err, "frequencies", "logical")

  if (!is.logical(print_key))
    arg_err <- add_error(arg_err, "print_key", "logical")

  if (!is.logical(return_num))
    arg_err <- add_error(arg_err, "return_num", "logical")

  # stop if one or more arguments are mismatched
  if (arg_err$error) stop("Arguments are not of appropriate type:\n",
                           sprintf(" * `%s` must be %s.\n",
                                   arg_err$name, arg_err$type),
                           call. = FALSE
                          )

# Check vector lengths ----------------------------------------------------

  if ((length(relig) != length(denom)) |
      (length(relig) != length(other)) |
      (length(denom) != length(other)) )
    stop("Vectors must be of the same lenght, currently they are:\n",
         "* Length of `relig`: ", length(relig), ".\n",
         "* Length of `denom`: ", length(denom), ".\n",
         "* Length of `other`: ", length(other), ".\n",
         call. = FALSE
         )

# Check for NA and transform them -----------------------------------------

  merge_na_dk <- FALSE
  if (any(is.na(relig)) & any(is.na(denom)) & any(is.na(other)))  {
    message("Some of the variables contain NA: `Don't know` and `NA`",
            "will be merged. Please see documentation for more details.")
    merge_na_dk <- TRUE
  }

  relig <- transform_rdo(relig, "relig")
  denom <- transform_rdo(denom, "denom")
  other <- transform_rdo(other, "other")


# Check that there are no unallowed values --------------------------------

  error_values <- list(error = FALSE, name = c(), type = c())
  if (is.logical(relig[[1]])) error_values <- add_error(error_values,
                                                        relig[[2]],
                                                        relig[[3]])
  if (is.logical(denom[[1]])) error_values <- add_error(error_values,
                                                        denom[[2]],
                                                        denom[[3]])
  if (is.logical(other[[1]])) error_values <- add_error(error_values,
                                                        other[[2]],
                                                        other[[3]])

  if (error_values$error) {
    stop("Variables with values that are not in codebook:\n",
         sprintf(" * `%s` has, for example: %s.\n",
                 error_values$name, error_values$type),
         call. = FALSE)
  }



# Create recoded religion -------------------------------------------------

  religion <- fct_rec_relig(relig, denom, other)

  if (merge_na_dk)  {
    religion[religion == "Don't know"] <- "Don't know/No answer"
    religion[religion == "No answer"] <- "Don't know/No answer"
  }

  religion <- as.factor(religion)

# Add missing levels ------------------------------------------------------

  all_levels <- c("Baptist", "Catholic or Orthodox", "Liberal Protestant",
                  "Christian, no group given", "Don't know", "No answer",
                  "Jewish",  "Episcopalian", "Mormon", "Lutheran", "None",
                  "Moderate Protestant")

  if (add_missing_levels)  {
    missing_levels <- !(all_levels %in% levels(religion))
    if (TRUE %in% missing_levels)
      levels(religion) <- c(levels(religion), all_levels[missing_levels])
  }

# Reduce groups if needed -------------------------------------------------

  if (n_groups == 7)  {
    # find code how to merge it
    # aslo, confirm that it can be changed in arguments
  }


# Print frequencies -------------------------------------------------------

  if (frequencies) print_frequencies(religion)


# Print recoding key ------------------------------------------------------

  if (print_key)  {
    DF <- data.frame('relig' = relig,
                     'denom' = denom,
                     'other' = other,
                     'religion' = religion
                     )
    print_key(DF)
  }


# Change to numeric -------------------------------------------------------

  if (return_num)  {
    indeksi <- 1:length(levels(religion))
    message("ATTENTION: Returned is numeric vector without attributes, ",
            "and with follwoing coressponding values: ",
            sprintf("[%i] %s * ", indeksi, levels(religion)))
    religion <- as.numeric(religion)
  }


# Return vector -----------------------------------------------------------

  return(religion)

}
