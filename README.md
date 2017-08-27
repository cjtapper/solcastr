# solcastr
An R client library for the Solcast API. Solcast provides photovolatic power and
solar radiation forecasting. More information can be found at
[solcast.com.au](https://www.solcast.com.au)


# Installaion
The package is available via CRAN. You can install using 
`install.packages("solcast")`.


# Usage
`library("solcast")`

After this, there should be four functions imported into your R environment that
will be of interest to you:

```
GetRadiationEstimatedActuals()
GetRadiationForecasts()
GetPVPowerForecasts()
GetPVPowerEstimatedActuals()
```

Their names are pretty self explanatory; to find out what arguments are
required, you're probably best off just opening solcast.R and having a look at
their definitions, it's all pretty well documented!

It should be noted that I haven't implemented any handling of the rate limiting,
so you might get errors if you try to do more than 120 (at time of me writing
this) requests within 1 minute.

Have fun!
