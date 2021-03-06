#' mark_outliers (package "deptstat")
#'
#' This function is created to mark outliers in any selected column of a dataframe.
#' The idea is based on Tukey's method (Tukey, 1977) for outlier trimming:

#' The lower quartile (q1) is the 25th percentile, and the upper quartile (q3) is the 75th percentile of the data.
#' The inter-quartile range (IQR) is defined as the interval between q1 and q3.

#' Tukey (1997) defined q1-(1.5*iqr) and q3+(1.5*iqr) as 'inner fences'. So called 'outer fences' are not supported yet.
#' Function return a vector (or a column in a data frame) that contains resulting value of outliers: 0 - ordinary observation, 1 - outlier.
#' Hence, the function supports alternative options like one-sided trimming ("right", "left") or different quantiles of distribution (default: 0.25 and 0.75)
#'
#' @param data Ordinary R data frame with at least one numeric column
#' @param var A particular numeric column of a data frame, that will be examined for outliers. Default:"" (nothing)
#' @param tukey.coef A coefficient is defaulted to be 1.5 but can me modified (for example, Tukey used coefficient 1.5 for inner fence and 3 for outer fences). Default: 1.5
#' @param trim.type A type of trimming: "two-sided" - when you search for outliers on both sides of a distribution, "right" - when you search for outlies on the right side of a distibution, "left" - when search for outliers on the left side of a distribution. Default:"two-sided"
#' @param quantiles A vector of two values with percentiles that will be used for calculation of IQR and to form fences (quantiles +/- tukey.coef * IQR). Default: c(0.25, 0.75)
#' @param verbose A verbose parameter setted to TRUE will print additional summary output. Default: FALSE
#' @param return_df A parameter setted to TRUE will return a data frame (instead of vector) with input column, marked outliers and extra data on IQR, tukey.coef and quantiles. Default: FALSE
#'
#' @return A vector or data frame with outliers marked as 1 and normal observations marked as 0
#'
#' @examples
#' # Let's find outliers in mtcars dataset
#' data("mtcars")
#' # Let's examine dataset first to find out variable names
#' summary(mtcars)
#' # Now we try out luck in outliers with mpg column (Miles/(US) gallon)
#' # and save a result into a separate dataset
#' mtcars_with_outliers <- mark_outliers(mtcars, "mpg", return_df = T)
#' # If you inspect mtcars_with_outliers, you will find out that Toyota Corolla
#' # is marked as and outlier, because it's mpg is 33.9
#' # while right fence is 22.8+1.5*7.375=33.8625

#' # Let's plot data with outliers
#' plot(mtcars_with_outliers[["mpg"]], main = "Marked outliers",
#'      col = factor(mtcars_with_outliers$mpg.is_outlier), pch = 19)
#' legend("bottomright", legend = c("Normal data","Outlier"), col = 1:2, pch = 19, bty = "n")
#'
#' @author Dmitrii Diachkov (2021)
#'

#' @export
mark_outliers <- function(data, var = "", tukey.coef = 1.5,
                          trim.type = "two-sided",
                          quantiles = c(0.25, 0.75),
                          verbose = FALSE, return_df = FALSE)
{
  # CHECK IF VARS ARE TYPED IN
  if(nchar(var)==0)
  {stop(paste0("Variable for processing is not specified"))}

  # CHECK IF VARS ARE TYPED IN
  if(length(var)>1)
  {stop(paste0("Multi-dimensional outlier validation is not supported in mark_outliers. Try mark_outliers_2d"))}

  # CHECK IF VARS ARE TYPED IN
  if(!is.data.frame(data))
  {stop(paste0("Data must be a dataframe"))}

  # CHECK IF VARS ARE TYPED IN
  if(!(var %in% colnames(data)))
  {stop(paste0("Variable ",var," doesn't exist in dataframe"))}

  # CHECK IF trim.type is specified correctly, according to logic
  if(!(length(quantiles) %in% c(1,2)))
  {stop(paste0("Quantlies vector must be of size 1 or 2 (not ",length(quantiles),")"))}

  # CHECK IF trim.type is specified correctly, according to logic
  if(sum(is.na(data[[var]]))>0)
  {stop(paste0("column ",var," has missing values. Handle NA"))}

  # CHECK IF trim.type is specified correctly, according to logic
  if(!trim.type %in% c("two-sided","right","left"))
  {stop("trim.type not supported (must be \"two-sided\",\"right\" or \"left\")")}

  # Ordering quantiles to unpack them to border Q1 and Q3
  quantiles <- quantiles[order(quantiles)]
  Q1 <- quantiles[1]
  Q3 <- quantiles[2]

  X <- data[[var]]
  X.left_boundary <- quantile(X, Q1)
  X.right_boundary <- quantile(X, Q3)
  X.IQR <- X.right_boundary - X.left_boundary
  X.right_outliers <- X > X.right_boundary + tukey.coef * X.IQR
  X.left_outliers <- X < X.left_boundary - tukey.coef * X.IQR

  if(trim.type == "two-sided"){X.is_outlier <- X.right_outliers+X.left_outliers}
  if(trim.type == "right"){X.is_outlier <- X.right_outliers+0}
  if(trim.type == "left"){X.is_outlier <- X.left_outliers+0}

  if(verbose == T)
  {
    print("-- Summary")
    print(paste0("--- Var: ",var))
    print(paste0("--- Tukey.coefficent: ",tukey.coef))
    print(paste0("--- Trim type: ",trim.type))
    print(paste0("---- Lower boundary: ",X.left_boundary))
    print(paste0("---- Upper boundary: ",X.right_boundary))
    print(paste0("---- IQR (or range): ",X.IQR))
    print(paste0("---- Total number of outliers:", sum(X.is_outlier)))
    print("")
  }

  if(return_df == T)
  {
    return_df_cols <- suppressWarnings(data.frame(X, tukey.coef, X.right_boundary, X.left_boundary,
                                                  X.IQR, X.is_outlier))

    colnames(return_df_cols) <- c(paste0(var,".original_data"),
                                  paste0(var,".tukey_coef"),
                                  paste0(var,".right_boundary"),
                                  paste0(var,".left_boundary"),
                                  paste0(var,".range"),
                                  paste0(var,".is_outlier"))
    return_df_cols <- cbind(data, return_df_cols)
    return(return_df_cols)
  }
  else
  {
    return_only_outliers <- suppressWarnings(as.vector(X.is_outlier))

    names(return_only_outliers) <- c(paste0(var,".is_outlier"))
    return(return_only_outliers)
  }

}
