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
dat$fillColor = color_values(rnorm(nrow(dat)), alpha = sample.int(255, nrow(dat), replace = TRUE))

options(viewer = NULL)

m = maplibre(style = 'https://basemaps.cartocdn.com/gl/positron-gl-style/style.json') |>
  add_navigation_control(visualize_pitch = TRUE)

m |>
  geoarrowDeckgl:::add_deckgl_scatterplot(
    source = dat
    , layerId = "test"
    , geom_column_name = attr(dat, "sf_column")
    , renderOptions = list(
      radiusUnits = "pixels"
      , radiusScale = 1
      , lineWidthUnits = "pixels"
      , lineWidthScale = 1
      , stroked = FALSE
      , filled = TRUE
      , radiusMinPixels = 3
      , radiusMaxPixels = 15
      , lineWidthMinPixels = 0
      , lineWidthMaxPixels = 1
      , billboard = FALSE
      , antialiasing = FALSE
    )
    , dataAccessors = list(
      getRadius = 4
      , getFillColor = "fillColor"
      , getLineColor = c(0, 255, 255, 255)
      , getLineWidth = 1
    )
  ) |>
  add_layers_control(collapsible = TRUE, layers = c("test"))


### polygons ==================================
dat = st_read("~/Downloads/data.gpkg")
dat$fillColor = color_values(rnorm(nrow(dat)))

options(viewer = NULL)

m = maplibre(style = 'https://basemaps.cartocdn.com/gl/positron-gl-style/style.json') |>
  add_navigation_control(visualize_pitch = TRUE)

m |>
  geoarrowDeckgl:::add_deckgl_polygons(
    source = dat
    , layerId = "test"
    , geom_column_name = attr(dat, "sf_column")
    , renderOptions = list(
      filled = TRUE
      , stroked = TRUE
      , extruded = FALSE
      , wireframe = FALSE
      , elevationScale = 1
      , lineWidthUnits = "meters"
      , lineWidthScale = 1
      , lineWidthMinPixels = 0
      , lineWidthMaxPixels = 2
      , lineJointRounded = FALSE
      , lineMiterLimit = 4
      # , material = TRUE
      # , "_normalize" = FALSE
      # , "_windingOrder" = "CW"
    )
    , dataAccessors = list(
      getFillColor = "fillColor"
      , getLineColor = c(255, 0, 255, 255)
      , getLineWidth = 1
      , getElevation = 100
    )
  ) |>
  add_layers_control(collapsible = TRUE, layers = c("test"))
