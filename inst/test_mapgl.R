library(mapgl)
library(geoarrowDeckgl)
library(geoarrow)
library(sf)
library(colourvalues)


### points =========================
n = 5e4
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
dat$lineWidth = sample.int(5, nrow(dat), replace = TRUE)

options(viewer = NULL)

m = maplibre(style = 'https://basemaps.cartocdn.com/gl/positron-gl-style/style.json') |>
  add_navigation_control(visualize_pitch = TRUE) |>
  add_layers_control(collapsible = TRUE, layers = c("test"))

# m = mapboxgl(
#   style = 'https://basemaps.cartocdn.com/gl/positron-gl-style/style.json'
#   , projection = "mercator"
#   ) |>
#   add_navigation_control(visualize_pitch = TRUE) |>
#   add_layers_control(collapsible = TRUE, layers = c("test"))

### TODO: figure out how to add to mapdeck/deckgl map. Seems fundamentally different
### from mapgl, but should be easy enough given it's the same framework
###
### More generally, should we provide methods for all possible rendering framweorks?
### mapgl (maplibregl/mapboxgl), mapdeck, deckgl, leaflet???

# m = mapdeck::mapdeck()
# m = add_basemap(deckgl(), style = use_carto_style())

m |>
  geoarrowDeckgl:::addGeoArrowScatterplotLayer(
    data = dat
    , layerId = "test"
    , geom_column_name = attr(dat, "sf_column")
    , render_options = geoarrowDeckgl:::renderOptions()
    , data_accessors = geoarrowDeckgl:::dataAccessors(
      getRadius = "radius"
      , getFillColor = "fillColor"
      , getLineWidth = "lineWidth"
      , getLineColor = "lineColor"
    )
    , popup = TRUE
    , popup_options = geoarrowDeckgl:::popupOptions(anchor = "bottom-right")
    , tooltip = TRUE
    # , tooltip_options = geoarrowDeckgl:::tooltipOptions(anchor = "top-left")
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
  fit_bounds(unname(st_bbox(dat)), animate = FALSE)

m |>
  geoarrowDeckgl:::addGeoArrowPolygonLayer(
    data = dat
    , layerId = "test"
    , geom_column_name = attr(dat, "sf_column")
    , popup = TRUE
    # , render_options = geoarrowDeckgl:::renderOptions(
    #   extruded = TRUE
    # )
    # , data_accessors = geoarrowDeckgl:::dataAccessors(
    #   getFillColor = "fillColor"
    #   , getLineColor = "lineColor"
    #   , getLineWidth = 1 # "lineWidth"
    #   , getElevation = "elevation"
    # )
  )


### lines ======================================
# dat = st_read("~/Downloads/DLM_4000_GEWAESSER_20211015.gpkg", layer = "GEW_4100_FLIESSEND_L")
dat = st_read("~/Downloads/rivers_africa.fgb")
dat = st_transform(dat, crs = "EPSG:4326")
dat$lineColor = color_values(
  dat$Strahler
  , palette = "inferno"
)
dat$lineWidth = sample.int(1500, nrow(dat), replace = TRUE)


options(viewer = NULL)

m = maplibre(style = 'https://basemaps.cartocdn.com/gl/positron-gl-style/style.json') |>
  add_navigation_control(visualize_pitch = TRUE) |>
  add_layers_control(collapsible = TRUE, layers = c("test"))

m |>
  geoarrowDeckgl:::addGeoArrowPathLayer(
    data = dat
    , layerId = "test"
    , geom_column_name = attr(dat, "sf_column")
    , render_options = geoarrowDeckgl:::renderOptions(
      widthUnits = "meters"
      , widthScale = 100
      , widthMaxPixels = 200
    )
    , data_accessors = geoarrowDeckgl:::dataAccessors(
      getWidth = "Strahler"
      , getColor = "lineColor"
    )
    , popup = TRUE
    , tooltip = FALSE
  )

