========
solcastr
========

An R client library for the Solcast API.

R really isn't my thing, so if anything doesn't follow normal conventions or
work how you would expect, please feel free to fix it and make a Pull Request!

I haven't packaged this up or anything for R, so you will have to install the
`httr` library first and manually source this into your projects.

Usage
=====

Firstly you will need to install `httr`. This is a nice library for performing
HTTP requests. You won't be using it directly though.

`install.packages('httr')`

Then source the R file. Make sure this is pointing to the correct path for
wherever you downloaded the script to!

`source('solcast.R')`

After this, there should be four functions imported into your R environment that
will be of interest to you:

`GetRadiationEstimatedActuals()`
`GetRadiationForecasts()`
`GetPVPowerForecasts()`
`GetPVPowerEstimatedActuals()`

Their names are pretty self explanatory; to find out what arguments are
required, you're probably best off just opening solcast.R and having a look at
their definitions, it's all pretty well documented!

Have fun!