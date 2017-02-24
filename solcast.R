library(httr)

SolcastGET <- function(end.point, api.key, ...) {
  # Base GET request to the Solcast API. This should never be used directly
  # unless you know what you are doing!
  #
  # Args:
  #   end.point: URL suffix of the end point to query
  #   api.key:   Solcast API key
  #   ...:       Queries to be appended to the request URL
  #
  # Returns:
  #   httr response object

  base.url <- "https://api.solcast.com.au"

  response <- GET(base.url, path=end.point, query=list(...,api_key=api.key))

  # Spit out an error if there were any problems with the HTTP request (i.e.,
  # returns with status_code other than 200
  stop_for_status(response)

  return(response)
}


GetPVPowerForecasts <- function(api.key, capacity, latitude, longitude, tilt=NULL, 
                                azimuth=NULL, install.date=NULL, loss.factor=NULL) {
  # Get PV power forecasts from Solcast.
  #
  # Args:
  #   api.key:      Solcast API key
  #   capacity:     Capacity of the PV system (Watts)
  #   latitude:     Latitude (north) of the system
  #   longitude:    Longitude (east) of the system
  #   tilt:         Tilt from horizontal of system
  #   azimuth:      Azimuth (N=0, E=-90, W=90) of the system
  #   install.date: Date that the system was installed
  #   loss.factor:  Loss factor of the system
  #
  # Returns:
  #   Dataframe containing the requested forecast data

  end.point <- "pv_power/forecasts"

  response <- SolcastGET(end.point, api.key, capacity=capacity, latitude=latitude, 
                         longitude=longitude, tilt=tilt, azimuth=azimuth, 
                         install_date=install.date, loss_factor=loss.factor)

  df <- ReformatDataFrame(response, "forecasts")

  return(df)

}


GetPVPowerEstimatedActuals <- function(api.key, capacity, latitude, longitude, 
                                       latest=FALSE, tilt=NULL, azimuth=NULL, 
                                       install.date=NULL, loss.factor=NULL) {
  # Get PV power estimated-actual data from Solcast.
  #
  # Args:
  #   api.key:      Solcast API key
  #   capacity:     Capacity of the PV system (Watts)
  #   latitude:     Latitude (north) of the system
  #   longitude:    Longitude (east) of the system
  #   latest:       Include latest estimated actuals
  #   tilt:         Tilt from horizontal of system
  #   azimuth:      Azimuth (N=0, E=-90, W=90) of the system
  #   install.date: Date that the system was installed
  #   loss.factor:  Loss factor of the system
  #
  # Returns:
  #   Dataframe containing the requested estimated-actuals data

  end.point <- "pv_power/estimated_actuals"

  if (latest) {
    end.point <- paste(end.point, "latest", sep="/")
  }

  response <- SolcastGET(end.point, api.key, capacity=capacity, latitude=latitude, 
                         longitude=longitude, tilt=tilt, azimuth=azimuth, 
                         install_date=install.date, loss_factor=loss.factor)

  df <- ReformatDataFrame(response, "estimated_actuals")

  return(df)

}


GetRadiationForecasts <- function(api.key, latitude, longitude) {
  # Get radiation forecast data from Solcast.
  #
  # Args:
  #   api.key:      Solcast API key
  #   latitude:     Latitude (north) of the system
  #   longitude:    Longitude (east) of the system
  #
  # Returns:
  #   Dataframe containing the requested forecast data

  end.point <- "radiation/forecasts"

  response <- SolcastGET(end.point, api.key, latitude=latitude, longitude=longitude)

  df <- ReformatDataFrame(response, "forecasts")

  return(df)

}


GetRadiationEstimatedActuals <- function(api.key, latitude, longitude, latest=FALSE) {
  # Get radiation estimated actuals data from Solcast.
  #
  # Args:
  #   api.key:      Solcast API key
  #   latitude:     Latitude (north) of the system
  #   longitude:    Longitude (east) of the system
  #
  # Returns:
  #   Dataframe containing the requested estimated actuals data

  end.point <- "radiation/estimated_actuals"

  if (latest) {
    end.point <- paste(end.point, "latest", sep="/")
  }

  response <- SolcastGET(end.point, api.key, latitude=latitude, longitude=longitude)

  df <- ReformatDataFrame(response, "estimated_actuals")

  return(df)

}


ReformatDataFrame <- function(response, data.field.name) {

  # Parse the JSON response into a dataframe
  df <- content(response, as='parsed', simplifyVector=TRUE)[[data.field.name]]

  # Convert the period_end column from ISO8601 string and put in new column
  # 'gtms'
  df$gtms <- as.POSIXct(df$period_end, tz="UTC", format="%Y-%m-%dT%H:%M:%OS")

  # Move timestamp (gtms) column from last to first. Not 100% necessary, but still nice
  df <- df[,c(ncol(df),1:(ncol(df)-1))]

  # Remove unformatted timestamp
  df$period_end <- NULL

  # Convert ISO8601 period to the R difftime class
  df$period <- as.difftime(df$period, format="PT%MM")

  return(df)
}
