#' File Sampler
#' 
#' A simple package for reading subsamples of flat text files by line in a
#' reasonably efficient manner.  We do so by sampling as the input file is
#' scanned and randomly choosing whether or not to dump the current line to an
#' external temporary file.  This temporary file is then read back into R.  For
#' (aggressive) downsampling, this is a very effective strategy; for resampling,
#' you are much better off reading the full dataset into memory.
#' 
#' The basic function performs the sampling/reading in a single pass. There is
#' an alternative version which allows for an exact amout to be subsampled via
#' reservoir sampling, but this version requires 2 passes through the data.  The
#' heavy lifting is done entirely in C.
#'
#' This package, including the underlying C library, is licensed under the
#' permissive 2-clause BSD license.
#' 
#' @author Drew Schmidt \email{wrathematics@@gmail.com}
#' @references Project URL: \url{https://github.com/wrathematics/filesampler}
#'
#' @importFrom utils read.csv
#' 
#' @name filesampler
#' @docType package
#' @title File Sampler
#' @keywords package
NULL
