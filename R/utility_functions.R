#' Pulls punches and labels for religious identification variables.
#'
#' @description Function that returns vector with punches and
#' labels for religious identification family of variables.
#' Since, many punches are skipped, especially in \code{other},
#' it has a lot of \code{NA}, while punches for different
#' missing values are described, e.g. \code{'IAP'} or
#' \code{'NA'}. It's uused in \code{\link{fct_rec_relig}}
#'
#'
#' @param vrbl Character string either 'relig', 'denom', or 'other'.
#'
#' @return Character vector with religion from either \code{relig},
#' \code{denom}, or \code{other} family of variables, where
#' index coresponds to punch code and value to label. Different
#' missing values are described in coresponding values.
#' @examples
#' relig_punches <- rdo_punches("relig")
#' @export
rdo_punches <- function(vrbl)  {
  if (!any(vrbl %in% c("relig", "denom", "other")))
    stop("vrbl must be either 'relig', 'denom', or 'other'")
  # Create vectors with position corespondign to the punch
  # of label in DF codebook for 3 variables
  # For some reason this is not working:
  # data("data/rdo_cdbk.rda") #, i.e. it is not pulling
  # the values from /data,
  cdbk <- rdo_cdbk[[vrbl]] #workaround, put them to systadata.rda
  c_pl <- c()
  for (i in cdbk$punch)  {
    c_pl[i] <- as.character(cdbk[cdbk$punch == i, "label"])
  }
  miss <- cdbk[is.na(cdbk$label), "punch"]
  c_pl[miss] <- "NA"
  return(c_pl)
}



transform_rdo <- function(vrb, type)  {
  # import codebook with appropriate punches
  # make num and character versions for checking
  cdbk <- rdo_punches(type)
  cdbk_num <- which(!is.na(cdbk))
  cdbk_num <- c(cdbk_num, 0) # IAP has punch 0, can't be index
  cdbk_chr <- cdbk[!is.na(cdbk)]
  cdbk_chr <- c(cdbk_chr, "IAP") # IAP has punch 0, can't be index
  # transform variable to characters and select unique values
  vrb <- as.character(vrb)
  vrb_lvls <- unique(vrb)
  # start checking

  # is vrb numeric?
  if (TRUE %in% (vrb_lvls %in% cdbk_num))  {
    # vrb is numeric
    # which values are not according to codebook
    miss_punch <- !(vrb_lvls %in% c(cdbk_num, NA))
    if (TRUE %in% miss_punch)  {
      # there are values which are not in codebook or NA
      return(list(error = TRUE, name = type, type = vrb_lvls[miss_punch][1]))
    } else {
      # all values are good, transform them
      cdbk[1000] <- "IAP" # IAP has punch 0, which cannot be index
      vrb[vrb == "0"] <- "1000"
      vrb <- cdbk[as.numeric(vrb)]
      # are any NA, which have to be changed?
      if (NA %in% vrb)  {
        vrb[is.na(vrb)] <- "NA"
        message("* `", type, "` recoded from punches to labels;",
                " and 'NA' introduced.")
        } else {
        message("* `", type, "` recoded from punches to labels.")
        }
      vrb <- as.factor(vrb)
    }
  } else {
    # vrb is not numeric
    if (TRUE %in% (vrb_lvls %in% cdbk_chr))  {
      # variable is character (or factor)
      # which values are not according to codebook or NA
      miss_lbl <- !(vrb_lvls %in% c(cdbk_chr, NA))
      if (TRUE %in% miss_lbl)  {
        # there are values which are not in codebook
        return(list(error = TRUE, name = type, type = vrb_lvls[miss_lbl][1]))
      } else {
        # all values good
        # are any NA, which have to be changed?
        if (NA %in% vrb)  {
          vrb[is.na(vrb)] <- "NA"
          message("* For `", type, "` 'NA' introduced.")
        }
        vrb <- as.factor(vrb)
      }
    } else  {
      # something else is wrong
      if (length(vrb) == 1) {
        return(list(error = TRUE, name = type, type = vrb[1]))
      } else {
        return(list(error = TRUE, name = type, type = "unknown error"))
      }

    }
  }
  return(vrb)
}





print_frequencies <- function(v)  {
  # Prints table with frequencies, proportitions,
  # and cumulative percents for vector
  cat("Distribution of religious identification, in your data of",
      length(v), "is:\n")
  v <- stats::reorder(v, v, function(v) -length(v))
  print(cbind(Freq = table(v, useNA = "ifany"),
              Relative = round(100 * prop.table(table(v, useNA = "ifany")),
                               2),
              Cumul = round(100 * cumsum(prop.table(table(v,
                                                          useNA = "ifany"
              ))),
              2)
  )
  )
}


add_error <- function(eror, cmnt_1, cmnt_2, cmnt_3)  {
  # Adds error comment to error list:
  #  [[1]]: logical, if there is error
  #  [[2]]: list of first part of description
  #  [[3]]: list of second part of description
  #  [[4]]: list of foruth part of description (optional)
  # Allows multiple errors of same type to be reported,
  # instead of one by one
  eror$error <- TRUE
  eror[[2]] <- c(eror[[2]], cmnt_1)
  eror[[3]] <- c(eror[[3]], cmnt_2)
  if (length(eror) > 3) eror[[4]] <- c(eror[[4]], cmnt_3)
  return(eror)
}


print_key <- function(DF)  {
  # Very wierd function that probably hacks quite a lot of
  # Rs data frames, in order to print some sort of codebook
  # for all the variables that were recoded
  DF <- unique(DF)
  DF <- DF[with(DF, order(religion, relig, denom, other)), ]
  DF <- t(DF)
  DF <- rbind(DF, DF[3,])
  DF <- rbind(DF, c("----------"))
  DF[3, ] <- DF[1, ]
  DF[1, ] <- DF[4, ]
  DF[4, ] <- DF[2, ]
  DF[2,] <- c("^^^ ")
  rownames(DF)[1] <- "religion| "
  rownames(DF)[2] <- "   ^    + "
  rownames(DF)[3] <- " relig  | "
  rownames(DF)[4] <- " denom  | "
  rownames(DF)[5] <- " other  | "
  rownames(DF)[6] <- "--------+-"
  DF <- as.data.frame(DF)
  colnames(DF) <- NULL
  cat("*** Key for recoding variables ***\n",
      "In this case, number of combinations was:", length(DF), ".\n")
  print(DF)
  cat("===================================\n")
  cat("This is probably not the best way to present or inspect them.\n",
      "There will be a better way soon, or use unique() on your data.")
}
