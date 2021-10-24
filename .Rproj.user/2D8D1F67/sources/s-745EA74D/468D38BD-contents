#' read_and_bind_xlsx (package "deptstat")
#'
#' This function is created to bind similar files into one data frame.
#'
#' @param path A path to XLSX files
#' @param filename_pattern A substring for subsetting files (part of file name)
#' @param return_filenames A parameter, that can be set to TRUE if the output must contain source filenames. Default: FALSE
#'
#' @return A data frame of all XLSX files, with a given substring in each filename, joined
#'
#' @examples
#' # This will return a dataframe, based on binded XLSX files, which name contained 'data' as a substring
#' read_and_bind_xlsx(getwd(), "data")
#'
#' @author Dmitrii Diachkov (2021)
#'

#' @export
read_and_bind_xlsx <- function(path, filename_pattern = "", return_filenames = F)
{

InPath <- paste0(file.path(path),"/")
search_files <- str_detect(list.files(InPath), filename_pattern)

d <- data.frame()
for (xls_file in list.files(InPath)[search_files])
{
  print(xls_file)
  file <- read_excel(paste0(InPath,xls_file), sheet = 1)
  if(return_filenames == T)
  {
    file$FILENAME <- xls_file
  }
  d <- rbind(d, file)
}
return(d)
}
