library(mapgl)
library(geoarrowDeckgl)
library(geoarrow)
library(sf)
library(colourvalues)


### points =========================
n = 1e6
dat = data.frame(
  id = 1:n
  , x = runif(n, -180, 180)
  , y = runif(n, -60, 60)
)
dat = st_as_sf(
  dat
  , coords = c("x", "y")
  , crs = 4326
)
dat$fillColor = color_values(
  rnorm(nrow(dat))
  , alpha = sample.int(255, nrow(dat), replace = TRUE)
)
dat$lineColor = color_values(
  rnorm(nrow(dat))
  , alpha = sample.int(255, nrow(dat), replace = TRUE)
  , palette = "inferno"
)
dat$radius = sample.int(15, nrow(dat), replace = TRUE)
dat$lineWidth = sample.int(1500, nrow(dat), replace = TRUE)

options(viewer = NULL)

m = maplibre(style = 'https://basemaps.cartocdn.com/gl/positron-gl-style/style.json') |>
  add_navigation_control(visualize_pitch = TRUE) |>
  add_layers_control(collapsible = TRUE, layers = c("test"))

m |>
  geoarrowDeckgl:::add_deckgl_scatterplot(
    source = dat
    , layerId = "test"
    , geom_column_name = attr(dat, "sf_column")
    , renderOptions = list(
      radiusUnits = "pixels"
      , radiusScale = 1
      , lineWidthUnits = "meters"
      , lineWidthScale = 1
      , stroked = TRUE
      , filled = TRUE
      , radiusMinPixels = 3
      , radiusMaxPixels = 15
      , lineWidthMinPixels = 0
      , lineWidthMaxPixels = 15
      , billboard = FALSE
      , antialiasing = FALSE
    )
    , dataAccessors = list(
      getRadius = "radius"
      , getFillColor = "fillColor"
      , getLineColor = "lineColor" #c(0, 255, 255, 255)
      , getLineWidth = "lineWidth"
    )
  )


### polygons ==================================
dat = st_read("~/Downloads/data.gpkg")
dat$fillColor = color_values(
  rnorm(nrow(dat))
  , alpha = sample.int(255, nrow(dat), replace = TRUE)
)
dat$lineColor = color_values(
  rnorm(nrow(dat))
  , alpha = sample.int(255, nrow(dat), replace = TRUE)
  , palette = "inferno"
)
dat$elevation = sample.int(200, nrow(dat), replace = TRUE)
dat$lineWidth = sample.int(1500, nrow(dat), replace = TRUE)


options(viewer = NULL)

m = maplibre(style = 'https://basemaps.cartocdn.com/gl/positron-gl-style/style.json') |>
  add_navigation_control(visualize_pitch = TRUE) |>
  add_layers_control(collapsible = TRUE, layers = c("test"))

m |>
  geoarrowDeckgl:::add_deckgl_polygons(
    source = dat
    , layerId = "test"
    , geom_column_name = attr(dat, "sf_column")
    , renderOptions = list(
      filled = TRUE
      , stroked = TRUE
      , extruded = TRUE
      , wireframe = TRUE
      , elevationScale = 1
      , lineWidthUnits = "meters"
      , lineWidthScale = 1
      , lineWidthMinPixels = 1
      , lineWidthMaxPixels = 15
      , lineJointRounded = FALSE
      , lineMiterLimit = 4
      # , material = TRUE
      # , "_normalize" = FALSE
      # , "_windingOrder" = "CW"
    )
    , dataAccessors = list(
      getFillColor = "fillColor"
      , getLineColor = c(0, 0, 0) #"lineColor"
      , getLineWidth = "lineWidth"
      , getElevation = "elevation"
    )
  )
