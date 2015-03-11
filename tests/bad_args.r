library(lineSampler)

set.seed(1234)

file <- tools::file_path_as_absolute(system.file("rawdata/small.csv", package="lineSampler"))


### p
badp <- "<simpleError in file_sampler(verbose = verbose, header = header, nskip = nskip,     p = p, infile = file): Argument 'p' must be between 0 and 1>"
badval <- tryCatch(sampled <- read_csv_sampled(file, p=-1), error=capture.output)
all.equal(badp, badval)
badval <- tryCatch(sampled <- read_csv_sampled(file, p=1.1), error=capture.output)
all.equal(badp, badval)

all.equal(sampled, sampled_actual)
