<!-- README.md is generated from README.Rmd. Please edit that file -->
resurrectionr <img src="man/figures/logo.png" align="right" />
==============================================================

[![Travis-CI Build
Status](https://travis-ci.org/mdjeric/resurrectionr.svg?branch=master)](https://travis-ci.org/mdjeric/resurrectionr)

The purpose of resurrectionr is `recode_religion()` which recodes a set
of religious identification variables from the US General Social Survey,
in a way that is analytically useful and easy to implement in data
processing.

Bigger sociological and political problems in recoding of religious
identification are elaborated and resolved with a recoding schema in the
paper by Darren E. Sherkat and Derek Lehman,[1] based on
classification[2] from 2001. This package provides solutions for main
technical issues with recoding of religious identification from GSS in
R, using said schema.

1.  Variables contain large number of codes: 16 (`relig`), 30 (`denom`),
    and 201 (`other`).  
2.  Same pattern of variables describes religious identification for a
    large number of items (e.g. spouses’, father’s, mother’s, etc.), and
    all of them have, naturally, different variable names.  
3.  Punch codes are not consequtive indexes, but are often skipping
    certain numbers, and, for certain items they tend to have only
    punches, not labels.

This package provides universal function `recode_religion()` that can
recode all these varaibles and adds additional benefits in terms of
cheking values, providing a recoding key, etc.

Installation
------------

``` r
# Install development version from GitHub
# install.packages("devtools") # If you don't have it
devtools::install_github("mdjeric/resurrectionr")
```

Example
-------

This is a basic use of function:

``` r
library(resurrectionr)
gss <- gss14_f


gss$religion <- recode_religion(gss$relig, gss$denom, gss$other)
#> Distribution of religious identification, in your data of 2538 is:
#>                           Freq Relative  Cumul
#> Catholic or Orthodox       615    24.23  24.23
#> None                       522    20.57  44.80
#> Baptist                    324    12.77  57.57
#> Christian, no group given  307    12.10  69.66
#> Moderate Protestant        206     8.12  77.78
#> Sectarian Protestant       178     7.01  84.79
#> Lutheran                    92     3.62  88.42
#> Other religion              88     3.47  91.88
#> Liberal Protestant          77     3.03  94.92
#> Jewish                      40     1.58  96.49
#> Episcopalian                39     1.54  98.03
#> Mormon                      32     1.26  99.29
#> No answer                   15     0.59  99.88
#> Don't know                   3     0.12 100.00


summary(gss$religion)
#>                   Baptist      Catholic or Orthodox 
#>                       324                       615 
#> Christian, no group given                Don't know 
#>                       307                         3 
#>              Episcopalian                    Jewish 
#>                        39                        40 
#>        Liberal Protestant                  Lutheran 
#>                        77                        92 
#>       Moderate Protestant                    Mormon 
#>                       206                        32 
#>                 No answer                      None 
#>                        15                       522 
#>            Other religion      Sectarian Protestant 
#>                        88                       178
```

Description
-----------

`recode_religion()` is a wrapper for basic function that does all the
recoding. It confirms the variables are with proper codes, same length,
transforms the type, and provides additional information, warning
messages, errors, etc.

`fct_rec_relig()`, the simple function, uses data frames in the list
[`rdo_cdbk`](reference/rdo_cdbk.html) from which three vectors are
formed where index corresponds to punch number, and label is value (of
`relig`, `denom`, and `other`).

For each *new* religious identification, separate vectors (for `relig`,
`denom`, and/or `other` identification) are created that contain
corresponding punch codes and labels, per paper and SPSS syntax. In
addition, logical vectors are created for Sectarian Protestants with
valid denomination codes for sorting between ‘Sectarian Protestants’,
‘Christian - no group given’, and ‘other religions’.

Next, twelve logical vectors, for respondent’s belonging to each group,
are created by checking against appropriate vectors containing labels.
Names are assigned, function prints frequency table, and returns vector
that contains new variable.

Additional behavior of the function
-----------------------------------

Function checks that the (1) vectors are of same length, and (2) that
their values are valid answers, throwing errors like this:

``` r
religion <- recode_religion("PROTESTANT", c(12, 13), "IAP")
#> Error: Vectors must be of the same lenght, currently they are:
#> Length of `relig`: 1.
#> Length of `denom`: 2.
#> Length of `other`: 1.
```

It is also possible to combine punches with labels, and get same
results, or print the coding key that was used on specific data.

``` r
set.seed(999) # for reproducability
short <- sample(1:2358, 50, replace = FALSE) # chose random 50 cases
gshrt <- gss[short, ]


gshrt$religion <- recode_religion(gshrt$relig, gshrt$denom, gshrt$other,
                                  add_missing_levels = TRUE, print_key = TRUE)
#> Distribution of religious identification, in your data of 50 is:
#>                           Freq Relative Cumul
#> Christian, no group given   13       26    26
#> Catholic or Orthodox        12       24    50
#> None                         7       14    64
#> Moderate Protestant          6       12    76
#> Baptist                      3        6    82
#> Liberal Protestant           2        4    86
#> Lutheran                     2        4    90
#> Other religion               2        4    94
#> Sectarian Protestant         2        4    98
#> Jewish                       1        2   100
#> Don't know                   0        0   100
#> No answer                    0        0   100
#> Episcopalian                 0        0   100
#> Mormon                       0        0   100
#> *** Key for recoding variables ***
#>  In this case, number of combinations was: 19 .
#>                                                                  
#> religion|           Baptist          Baptist Catholic or Orthodox
#>    ^    +              ^^^              ^^^                  ^^^ 
#>  relig  |        PROTESTANT       PROTESTANT             CATHOLIC
#>  denom  |  BAPTIST-DK WHICH SOUTHERN BAPTIST                  IAP
#>  other  |               IAP              IAP                  IAP
#> --------+-       ----------       ----------           ----------
#>                                                                          
#> religion|  Christian, no group given Christian, no group given     Jewish
#>    ^    +                       ^^^                       ^^^        ^^^ 
#>  relig  |                  CHRISTIAN                PROTESTANT     JEWISH
#>  denom  |            NO DENOMINATION           NO DENOMINATION        IAP
#>  other  |                        IAP                       IAP        IAP
#> --------+-                ----------                ---------- ----------
#>                                                                    
#> religion|  Liberal Protestant   Liberal Protestant         Lutheran
#>    ^    +                ^^^                  ^^^              ^^^ 
#>  relig  |          PROTESTANT           PROTESTANT       PROTESTANT
#>  denom  |  PRESBYTERIAN-DK WH PRESBYTERIAN, MERGED EVANGELICAL LUTH
#>  other  |                 IAP                  IAP              IAP
#> --------+-         ----------           ----------       ----------
#>                                                                  
#> religion|        Lutheran Moderate Protestant Moderate Protestant
#>    ^    +            ^^^                 ^^^                 ^^^ 
#>  relig  |      PROTESTANT          PROTESTANT          PROTESTANT
#>  denom  |  OTHER LUTHERAN   AM BAPT CH IN USA   NAT BAPT CONV USA
#>  other  |             IAP                 IAP                 IAP
#> --------+-     ----------          ----------          ----------
#>                                                                       
#> religion|  Moderate Protestant Moderate Protestant Moderate Protestant
#>    ^    +                 ^^^                 ^^^                 ^^^ 
#>  relig  |           PROTESTANT          PROTESTANT          PROTESTANT
#>  denom  |                OTHER               OTHER    UNITED METHODIST
#>  other  |     Christian Reform Disciples of Christ                 IAP
#> --------+-          ----------          ----------          ----------
#>                                                             
#> religion|        None Other religion          Other religion
#>    ^    +        ^^^            ^^^                     ^^^ 
#>  relig  |        NONE       HINDUISM              PROTESTANT
#>  denom  |         IAP            IAP                   OTHER
#>  other  |         IAP            IAP Unitarian, Universalist
#> --------+- ----------     ----------              ----------
#>                                        
#> religion|          Sectarian Protestant
#>    ^    +                          ^^^ 
#>  relig  |                    PROTESTANT
#>  denom  |                         OTHER
#>  other  |  Christian; Central Christian
#> --------+-                   ----------
#> ===================================
#> This is probably not the best way to present or inspect them.
#>  There will be a better way soon, or use unique() on your data.
```

It also works well when some (or all) variables contain punches, either
as characters or numbers.

``` r
gshrt$d_num <- gss14_n$denom[short]
gshrt$o_num_char <- as.character(gss14_n$other[short])


gshrt$religion2 <- recode_religion(gshrt$relig, gshrt$d_num, gshrt$o_num_char,
                                  add_missing_levels = TRUE, frequencies = FALSE)
#> * `denom` recoded from punches to labels; and 'NA' introduced.
#> * `other` recoded from punches to labels; and 'NA' introduced.

# We can see that there is no difference
FALSE %in% (gshrt$religion2 == gshrt$religion)
#> [1] FALSE
```

Bugs
----

There are minor differences, however, when all missing values are
imported from SPSS. For example, if all missing values are treated
equaliy, certain groups might appear `NA`, as seen in this example:

``` r
gss$religion2 <- recode_religion(gss14_n$relig, gss14_n$denom, gss14_n$other, frequencies = FALSE)
#> Some of the variables contain NA: `Don't know` and `NA`will be merged. Please see documentation for more details.
#> * `relig` recoded from punches to labels; and 'NA' introduced.
#> * `denom` recoded from punches to labels; and 'NA' introduced.
#> * `other` recoded from punches to labels; and 'NA' introduced.
unique(gss[,c("religion2", "religion")])
#>                     religion2                  religion
#> 1        Catholic or Orthodox      Catholic or Orthodox
#> 3                    Lutheran                  Lutheran
#> 6                Episcopalian              Episcopalian
#> 13  Christian, no group given Christian, no group given
#> 18                       None                      None
#> 19        Moderate Protestant       Moderate Protestant
#> 21         Liberal Protestant        Liberal Protestant
#> 34             Other religion            Other religion
#> 43       Sectarian Protestant      Sectarian Protestant
#> 46                    Baptist                   Baptist
#> 54                     Jewish                    Jewish
#> 119                      <NA>                 No answer
#> 220                      <NA>                Don't know
#> 260                    Mormon                    Mormon
#> 309                      <NA> Christian, no group given

# total number of cases in 2014 GSS:
gss[is.na(gss$religion2) & gss$religion == "Christian, no group given",]
#>               bible      relig denom other                  religion
#> 309   INSPIRED WORD PROTESTANT OTHER    NA Christian, no group given
#> 419     WORD OF GOD PROTESTANT    DK   IAP Christian, no group given
#> 677   INSPIRED WORD PROTESTANT OTHER    DK Christian, no group given
#> 1138 BOOK OF FABLES PROTESTANT    DK   IAP Christian, no group given
#> 2487    WORD OF GOD PROTESTANT    DK   IAP Christian, no group given
#>      religion2
#> 309       <NA>
#> 419       <NA>
#> 677       <NA>
#> 1138      <NA>
#> 2487      <NA>
# These are with different types of missing values on denom and other
# should be corrected soon.
```

Further work
------------

Three more things are planned to be included in this package:

1.  Recode to often more useful group of 7 religious identifications.
2.  Function that just prints the results.
3.  Function that returns key with all recoding tetrades, and all
    recoding tetrades in particular set, as data frame (it might be
    useful for someone).

Code of conduct
---------------

Please note that this project is released with a [Contributor Code of
Conduct](CONDUCT.md). By participating in this project you agree to
abide by its terms.

[1] <a href="https://iranianredneck.wordpress.com/2016/11/29/why-reltrad-sucks-contesting-the-measure-of-american-religion/" target="_blank">“After The Resurrection: The Field of the Sociology of Religion in the United States”</a>

[2] Sherkat, Darren E. 2001. “Tracking the restructuring of American
religion: Religious affiliation and patterns of religious mobility,
1973–1998.” *Social Forces* 79(4), 1459-1493.
[doi:10.1353/sof.2001.0052](https://doi.org/10.1353/sof.2001.0052)
