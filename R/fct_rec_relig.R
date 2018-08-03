#' Basic religion recoding.
#'
#' @description With correct parameters, it effectievly recodes
#' the religion variables. \code{\link{recode_religion}} wraps it,
#' and conducts series of checks to confirm that variables for
#' recoding are good and that it will produce a correct religious
#' identification. In addition, \code{\link{recode_religion}} allows
#' for more flexibility in terms of output. However, this function
#' is the essence of the package, and contains details about logic
#' of the recoding schema, and can also be inspected at
#' \href{https://github.com/mdjeric/resurrectionr/R/recode_religion_only-factors.R}{github.com/mdjeric/resurrectionr}
#'
#' @param religion,denomination,other Factors.
#'
#' @return Character vector with recoded religion.
#'
fct_rec_relig <- function(religion, denomination, other)  {
  ######## Recoding religion and religion at 16 ##################
  # Sherkat and Lehman (2017)
  # To work properly, folder 'religion_punches' with .csvs
  # of label names has to be in wokring directory.
  #
  # Function: # rec_relig_12(religion, denomination, other)
  #	relig or relig16 variable; denom or denom 16; other or oth16
  # function prints frequencies and returns factor vector with
  # religion recoded.
  #
  # It works with GSS dataset imported through 'read.spss',
  # from foreign package, in following way:
  # to.data.frame = TRUE, trim.factor.names = TRUE,
  # trim_values = TRUE, use.missings = FALSE


  ## SETTING UP ==================================================

  # Import three varaibles into new dataset used for recoding ----
  DF <- data.frame(relig = religion,
                   denom = denomination,
                   other = other
                   )

  # Create vectors with position corespondign to the punch
  # of label in DF codebook for 3 variables
  c_r <- rdo_punches("relig")
  c_d <- rdo_punches("denom")
  c_o <- rdo_punches("other")


  ## RECODING =====================================================

  # Liberal Protestants --------------------------------------------
  lp_d_num <- c(40:49)
  lp_o_num <- c(29, 30, 40, 54, 70, 72 , 81, 82, 95, 98, 119,
                142, 160, 188)
  lp_denom <- c_d[lp_d_num]
  lp_other <- c_o[lp_o_num]
  DF$lp_true <- (DF$denom %in% lp_denom) | (DF$other %in% lp_other)
  DF$rv[DF$lp_true] <- "Liberal Protestant"

  # Episcopalians --------------------------------------------------
  ep_d_num <- c(50)
  ep_denom <- c_d[ep_d_num]
  DF$ep_true <- DF$denom %in% ep_denom
  DF$rv[DF$ep_true] <- "Episcopalian"

  # Moderate Protestants ------------------------------------------
  mp_d_num <- c(10:13, 20:23, 28)
  mp_o_num <- c(1, 8, 15, 19, 25, 32, 42:44, 46, 49:51, 71, 73, 94,
                99, 146, 148, 150, 186)
  mp_denom <- c_d[mp_d_num]
  mp_other <- c_o[mp_o_num]
  DF$mp_true <- (DF$denom %in% mp_denom) | (DF$other %in% mp_other)
  DF$rv[DF$mp_true] <- "Moderate Protestant"

  # Lutherans -----------------------------------------------------
  lt_d_num <- c(30:38)
  lt_o_num <- c(105)
  lt_denom <- c_d[lt_d_num]
  lt_other <- c_o[lt_o_num]
  DF$lt_true <- (DF$denom %in% lt_denom) | (DF$other %in% lt_other)
  DF$rv[DF$lt_true] <- "Lutheran"

  # Baptists ------------------------------------------------------
  bp_d_num <- c(14:18)
  bp_o_num <- c(93, 133, 197)
  bp_denom <- c_d[bp_d_num]
  bp_other <- c_o[bp_o_num]
  DF$bp_true <- (DF$denom %in% bp_denom) | (DF$other %in% bp_other)
  DF$rv[DF$bp_true] <- "Baptist"

  # Sectarian Protestants -----------------------------------------
  # these initial variables pull out sectarians codes
  # relig == 11 (christian) or relig == 5 (other),
  # but also have valid denom codes.
  DF$sp_pent <- (DF$relig == c_r[11]) & (DF$other == c_o[68])
  DF$sp_centchrist <- (DF$relig == c_r[5]) & (DF$other == c_o[31])
  DF$sp_fsg <- (DF$relig == c_r[5]) & (DF$other == c_o[53])
  DF$sp_jw <- (DF$relig == c_r[5]) & (DF$other == c_o[58])
  DF$sp_sda <- (DF$relig == c_r[5]) & (DF$other == c_o[77])
  DF$sp_ofund <- (DF$relig == c_r[5]) & (DF$other == c_o[97])

  sp_o_num <- c(2, 3, 5:7, 9, 10, 12:14, 16:18, 20:24, 26, 27, 31,
                33:39, 41, 45, 47, 48, 52, 53, 55:58, 63, 65:69,
                76:79, 83:92, 96, 97, 100:104, 106:113, 115:118,
                120:122, 124, 125, 127:132, 134, 135, 137:141, 144,
                145, 151:156, 158, 159, 166:182, 184, 185, 187,
                189:191, 193, 195, 196, 198, 201, 204)
  sp_other <- c_o[sp_o_num]

  DF$sp_true <- ((DF$other %in% sp_other) |
                  DF$sp_pent |
                  DF$sp_centchrist |
                  DF$sp_fsg |
                  DF$sp_jw |
                  DF$sp_sda |
                  DF$sp_ofund
                 )
  DF$rv[DF$sp_true] <- "Sectarian Protestant"

  # Christian, no group identified --------------------------------
  DF$cn_christ <- (DF$relig == c_r[11]) & !DF$sp_pent
  cn_r_num <- c(13)
  cn_d_num <- c(70, 98, 99)
  cn_o_num <- c(998, 999)
  cn_relig <- c_r[cn_r_num]
  cn_denom <- c_d[cn_d_num]
  cn_other <- c_o[cn_o_num]
  DF$cn_true <- ((DF$relig %in% cn_relig) |
                 (DF$denom %in% cn_denom) |
                 (DF$other %in% cn_other) |
                  DF$cn_christ
                 )
  DF$rv[DF$cn_true] <- "Christian, no group given"

  # Mormons -------------------------------------------------------
  mr_o_num <- c(59:62, 64, 157, 162)
  mr_other <- c_o[mr_o_num]
  DF$mr_true <- DF$other %in% mr_other
  DF$rv[DF$mr_true] <- "Mormon"

  # Catholics or Orthodox Christians ------------------------------
  co_r_num <- c(2, 10)
  co_o_num <- c(28, 123, 126, 143, 149, 183, 194)
  co_relig <- c_r[co_r_num]
  co_other <- c_o[co_o_num]
  DF$co_true <- (DF$relig %in% co_relig) | (DF$other %in% co_other)
  DF$rv[DF$co_true] <- "Catholic and Orthodox"

  # Jews ----------------------------------------------------------
  jw_r_num <- c(3)
  jw_relig <- c_r[jw_r_num]
  DF$jw_true <- DF$relig %in% jw_relig
  DF$rv[DF$jw_true] <- "Jew"

  # Other religions -----------------------------------------------
  DF$or_nonsp <- (DF$relig == c_r[5]) & !(DF$sp_pent |
                                          DF$sp_centchrist |
                                          DF$sp_fsg |
                                          DF$sp_jw |
                                          DF$sp_sda |
                                          DF$sp_ofund
                                          )
  or_r_num <- c(6:9, 12)
  or_o_num <- c(11, 74, 75, 80, 114, 136, 161, 163, 164, 192)
  or_relig <- c_r[or_r_num]
  or_other <- c_o[or_o_num]
  DF$or_true <- ((DF$relig %in% or_relig) |
                 (DF$other %in% or_other) |
                  DF$or_nonsp
                 )
  DF$rv[DF$or_true] <- "Other religions"

  # No religious identification -----------------------------------
  nr_r_num <- c(4)
  nr_relig <- c_r[nr_r_num]
  DF$nr_true <- DF$relig %in% nr_relig
  DF$rv[DF$nr_true] <- "No identification"

  # Missing values ------------------------------------------------
  # No Answer
  DF$na_relig <- DF$relig == c_r[99]
  DF$na_denom <- DF$denom == c_d[99]
  DF$na_rd <- DF$na_relig & DF$na_denom
  DF$rv[DF$na_rd] <- "No answer"

  # Don't know
  DF$dk_relig <- DF$relig == c_r[98]
  DF$rv[DF$dk_relig] <- "Don't know"


  ## FINISHING IT =================================================

  # Return the character vector with recoded religion
  return(DF$rv)
}





