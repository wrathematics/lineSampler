#' Read Sample of CSV
#' 
#' The function will read (as csv) approximately p*nlines lines. So 
#' if \code{p=.1}, then we will get roughly (probably not exactly) 10% of the
#' data.  This is the analogue of the base R function \code{read.csv()}.
#' 
#' @details
#' This function scans over the test of the input file and at each step,
#' randomly chooses whether or not to include the current line into a
#' downsampled file. Each selected line is placed in a temporary file, before
#' being read into R via \code{read.csv()}.  Additional arguments to this
#' function (those other than \code{file}, \code{p}, and \code{verbose}) are
#' passed to \code{read.csv()}, and so if their behavior is unclear, you should
#' examine the \code{read.csv()} help file.
#' 
#' If \code{verbose=TRUE}, then something like:
#' 
#' \code{Read 12207 lines (0.001\%) of 12174948 line file.}
#' 
#' will be printed to the terminal. This counts the header (if there is one) as
#' one of the lines read and as one of the lines possible.
#' 
#' @param file
#' Location of the file (as a string) to be subsampled.
#' @param param
#' The downsampling parameter. For the "proportional" method, this is the
#' proportion to retain and should be a numeric value between 0 and 1. For the
#' exact method, this is the total number of lines to read in.
#' @param method
#' A string indicating the type of read method to use. Options are
#' "proportional" and "exact".
#' @param reader
#' A function specifying the reader to use. The default is 
#' \code{utils::read.csv}. Other options include \code{data.table::fread()} and
#' \code{readr::read_csv()}.  Note the first argument of the reader should be
#' the file to read in and the second should be the the
#' \code{header}/\code{col_names} argument.  This would require writing a small
#' wrapper for \code{fread()}.
#' @param header
#' Is a header (line of column names) on the first line of the csv file?
#' @param nskip
#' Number of lines to skip. If \code{header=TRUE}, then this only applies to
#' lines after the header.
#' @param nmax
#' Max number of lines to read. If nmax==0, then there is no read cap. Ignored
#' if \code{method="exact"}.
#' @param verbose
#' Should linecounts of the input file and the number of lines sampled be
#' printed?
#' @param ...
#' Additional arguments passed to the csv reader.
#' 
#' @return
#' A dataframe, as with \code{read.csv()}.
#' 
#' @examples
#' library(filesampler)
#' file = system.file("rawdata/small.csv", package="filesampler")
#' 
#' # Read in a 5% random subsample of the rows.
#' data = sample_csv(file, param=.05)
#' 
#' # Read in 10 randomly sampled rows.
#' data = sample_csv(file, param=10, method="exact")
#'
#' @export
sample_csv = function(file, param, method="proportional", reader=utils::read.csv, header=TRUE, nskip=0, nmax=0, verbose=FALSE, ...)
{
  check.is.function(reader)
  method = match.arg(tolower(method), c("proportional", "exact"))
  
  outfile = tempfile()
  
  if (method == "proportional")
  {
    p = param
    file_sample_prop(p=p, infile=file, outfile=outfile, header=header, nskip=nskip, nmax=nmax, verbose=verbose)
  }
  else if (method == "exact")
  {
    nlines = param
    file_sample_exact(nlines=nlines, infile=file, outfile=outfile, header=header, nskip=nskip, verbose=verbose)
  }
  
  
  reader_nm = deparse(substitute(reader))
  if (grepl(reader_nm, pattern="read_csv"))
    data = reader(outfile, col_names=header, ...)
  else
    data = reader(outfile, header=header, ...)
  
  unlink(outfile)
  return(data)
}
