### NADPark study
library('inferno')

## Set random-generator seed to reproduce results if repeated
seed <- 16

## How many parallel CPUs to use for the computation?
parallel <- 4

## Name of directory where to save what has been "learned"
## a timestamp may be appended to this string
savedir <- 'output_prior_tsf5'

## Call the main function for "learning"
## it will save everything in the directory outputdir
outputdir <- learn(
    data = 'partialdata_704.csv',
    ## subsampledata = 100,
    ## nsamples = 360,
    ## nchains = 2,
    ## maxhours = 0,
    ## cleanup = FALSE,
    prior = TRUE,
    metadata = 'meta_AD_MCI.csv',
    outputdir = savedir,
    appendtimestamp = FALSE,
    appendinfo = FALSE,
    output = 'directory',
    cleanup = FALSE,
    parallel = parallel,
    hyperparams = list(
        ncomponents = 64,
        minalpha = -4,
        maxalpha = 4,
        byalpha = 1,
        Rshapelo = 0.5,
        Rshapehi = 0.5,
        Rvarm1 = 3^2,
        Cshapelo = 0.5,
        Cshapehi = 0.5,
        Cvarm1 = 3^2,
        Dshapelo = 0.5,
        Dshapehi = 0.5,
        Dvarm1 = 3^2,
        Lshapelo = 0.5,
        Lshapehi = 0.5,
        Lvarm1 = 3^2,
        Bshapelo = 1,
        Bshapehi = 1,
        Dthreshold = 1,
        tscalefactor = 5
    ),
    seed = seed
)
