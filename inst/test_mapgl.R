library(mapgl)
library(geoarrowDeckgl)
library(geoarrow)
library(sf)
library(colourvalues)


### points =========================
n = 5e5
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
  geoarrowDeckgl:::addGeoarrowDeckglScatterplotLayer(
    data = dat
    , layerId = "test"
    , geom_column_name = attr(dat, "sf_column")
    , render_options = list(
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
    , data_accessors = list(
      getRadius = "radius"
      , getFillColor = "fillColor" # "#00ffff45"
      , getLineColor = "lineColor" # c(0, 255, 255, 130)
      , getLineWidth = "lineWidth"
    )
    , popup = FALSE
    # , popup_options = geoarrowDeckgl:::popupOptions(anchor = "bottom-right")
    , tooltip = TRUE
    # , tooltip_options = geoarrowDeckgl:::tooltipOptions(anchor = "bottom-right")
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
  add_layers_control(collapsible = TRUE, layers = c("test")) |>
  fit_bounds(st_bbox(dat), animate = FALSE)

m |>
  geoarrowDeckgl:::addGeoarrowDeckglPolygonLayer(
    data = dat
    , layerId = "test"
    , geom_column_name = attr(dat, "sf_column")
    , renderOptions = list(
      filled = TRUE
      , stroked = TRUE
      , extruded = TRUE
      , wireframe = TRUE
      , elevationScale = 1
      , lineWidthUnits = "pixels"
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
      , getLineColor = "lineColor"
      , getLineWidth = 1 # "lineWidth"
      , getElevation = "elevation"
    )
  )

## geojson
maplibre() |>
  fit_bounds(dat, animate = FALSE) |>
  add_fill_layer(
    id = "test"
    , source = dat
  )

### lines ======================================
dat = st_read("~/Downloads/DLM_4000_GEWAESSER_20211015.gpkg", layer = "GEW_4100_FLIESSEND_L")
dat = st_transform(dat, crs = "EPSG:4326")
dat$lineColor = color_values(
  rnorm(nrow(dat))
  , alpha = sample.int(255, nrow(dat), replace = TRUE)
  , palette = "viridis"
)
dat$lineWidth = sample.int(1500, nrow(dat), replace = TRUE)


options(viewer = NULL)

m = maplibre(style = 'https://basemaps.cartocdn.com/gl/positron-gl-style/style.json') |>
  add_navigation_control(visualize_pitch = TRUE) |>
  add_layers_control(collapsible = TRUE, layers = c("test"))

m |>
  geoarrowDeckgl:::addGeoarrowDeckglPathLayer(
    data = dat
    , layerId = "test"
    , geom_column_name = attr(dat, "sf_column")
    , renderOptions = list(
      widthUnits = "pixels"
      , widthScale = 1
      , widthMinPixels = 1
      , widthMaxPixels = 5
      , capRounded = TRUE
      , jointRounded = FALSE
      , billboard = FALSE
      , miterLimit = 4
      # , material = TRUE
      # , "_normalize" = FALSE
      # , "_windingOrder" = "CW"
    )
    , dataAccessors = list(
      getColor = "lineColor"
      , getWidth = 1 # "lineWidth"
    )
  )

