library(mapdeck)
library(sf)

mapdeck() |>
  add_scatterplot(
    data = capitals
    , lat = "lat"
    , lon = "lon"
    , radius = 100000
    , radius_max_pixels = 7
    , fill_colour = "country"
    , layer_id = "scatter_layer"
    , tooltip = "capital"
  )


caps = st_as_sf(capitals, coords = c("lon", "lat"), crs = "EPSG:4326")

path_layer = geoarrowDeckgl:::writeInterleavedGeoarrow(
  caps
  , "test"
  , "geometry"
)

map = mapdeck()

map$dependencies = c(
  map$dependencies
  , geoarrowDeckgl:::arrowDependencies()
  , geoarrowDeckgl:::deckglDataAttachmentSrc(path_layer, "test")
  , geoarrowDeckgl:::geoarrowDeckglLayersDependencies()
  , geoarrowDeckgl:::geoarrowjsDependencies()
  , geoarrowDeckgl:::helpersDependency()
)

options(viewer = NULL)

m = htmlwidgets::onRender(
  map
  , htmlwidgets::JS(
    "function(el, x, data) {
        debugger;
        map = el.id;
        let gaDeckLayers = window['@geoarrow/deck']['gl-layers'];

        let data_fl = document.getElementById(data.layerId + '-1-attachment');

        fetch(data_fl.href)
          .then(result => Arrow.tableFromIPC(result))
          .then(arrow_table => {
          //debugger;
            let geoArrowScatterplot = new gaDeckLayers.GeoArrowScatterplotLayer({
              //map_id: map,
              id: data.layerId,
              data: arrow_table,
              getPosition: arrow_table.getChild(data.geom_column_name),

              filled: true,
              stroked: true,
              radiusUnits: 'pixels',

              getRadius: 7,
            })
            debugger;
            md_update_layer(map, data.layerId, geoArrowScatterplot);
          })

          //debugger;
      }"
  )
  , data = list(
    layerId = "test"
    , geom_column_name = "geometry"
  )
)

m
