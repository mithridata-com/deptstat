\name{mark_outliers}
\alias{mark_outliers}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{mark_outliers (package "statdept")
%%  ~~function to do ... ~~
}
\description{
%%  ~~ A concise (1-5 lines) description of what the function does. ~~
This function is created to mark outliers in any selected column of a dataframe.
The idea is based on Tukey's method (Tukey, 1977) for outlier trimming:

1. The lower quartile (q1) is the 25th percentile, and the upper quartile (q3) is the 75th percentile of the data.
2. The inter-quartile range (IQR) is defined as the interval between q1 and q3.

3. Tukey (1997) defined q1-(1.5*iqr) and q3+(1.5*iqr) as 'inner fences'. So called 'outer fences' are not supported yet.

4.Function return a vector (or a column in a data frame) that contains resulting value of outliers: 0 - ordinary observation, 1 - outlier.

Hence, the function supports alternative options like one-sided trimming ("right", "left") or different quantiles of distribution (default: 0.25 and 0.75)

}
\usage{
mark_outliers(data, var = "", tukey.coef = 1.5,
              trim.type = "two-sided",
              quantiles = c(0.25, 0.75),
              verbose = FALSE, return_df = FALSE)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{data}{
%%     ~~Describe \code{x} here~~
Ordinary R data frame with at least one numeric column
}
  \item{var}{
%%     ~~Describe \code{x} here~~
A particular numeric column of a data frame, that will be examined for outliers
Default:"" (nothing)
}
  \item{tukey.coef}{
%%     ~~Describe \code{x} here~~
A coefficient is defaulted to be 1.5 but can me modified (for example, Tukey used coefficient 1.5 for inner fence and 3 for outer fences)
Default: 1.5
}
  \item{trim.type}{
%%     ~~Describe \code{x} here~~
A type of trimming: "two-sided" - when you search for outliers on both sides of a distribution, "right" - when you search for outlies on the right side of a distibution, "left" - when search for outliers on the left side of a distribution
Default:"two-sided"
}
  \item{quantiles}{
%%     ~~Describe \code{x} here~~
A vector of two values with percentiles that will be used for calculation of IQR and to form fences (quantiles +/- tukey.coef * IQR)
Default: c(0.25, 0.75)
}
  \item{verbose}{
%%     ~~Describe \code{x} here~~
A verbose parameter setted to TRUE will print additional summary output
Default: FALSE
}
  \item{return_df}{
%%     ~~Describe \code{x} here~~
A parameter setted to TRUE will return a data frame (instead of vector) with input column, marked outliers and extra data on IQR, tukey.coef and quantiles.
Default: FALSE
}
}
\details{
%%  ~~ If necessary, more details than the description above ~~
}
\value{
%%  ~Describe the value returned
%%  If it is a LIST, use
%%  \item{comp1 }{Description of 'comp1'}
%%  \item{comp2 }{Description of 'comp2'}
%% ...
}
\references{
%% ~put references to the literature/web site here ~
}
\author{
%%  ~~who you are~~
Dmitrii Diachkov (2021)
}
\note{
%%  ~~further notes~~
}

%% ~Make other sections like Warning with \section{Warning }{....} ~

\seealso{
%% ~~objects to See Also as \code{\link{help}}, ~~~
}
\examples{
# Let's find outliers in mtcars dataset
data("mtcars")
# Let's examine dataset first to find out variable names
summary(mtcars)
# Now we try out luck in outliers with mpg column (Miles/(US) gallon)
# and save a result into a separate dataset
mtcars_with_outliers <- mark_outliers(mtcars, "mpg", return_df = T)
# If you inspect mtcars_with_outliers, you will find out that Toyota Corolla
# is marked as and outlier, because it's mpg is 33.9
# while right fence is 22.8+1.5*7.375=33.8625

# Let's plot data with outliers
plot(mtcars_with_outliers[["mpg"]], main = "Marked outliers",
     col = factor(mtcars_with_outliers$mpg.is_outlier), pch = 19)
legend("bottomright", legend = c("Normal data","Outlier"), col = 1:2, pch = 19, bty = "n")

% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory (show via RShowDoc("KEYWORDS")):
% \keyword{ ~kwd1 }
% \keyword{ ~kwd2 }
% Use only one keyword per line.
% For non-standard keywords, use \concept instead of \keyword:
% \concept{ ~cpt1 }
% \concept{ ~cpt2 }
% Use only one concept per line.
