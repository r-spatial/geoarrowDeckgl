add_deckgl_polygons = function(
    map
    , source
    , layerId
    , geom_column_name = attr(source, "sf_column")
    , renderOptions = list()
    , dataAccessors = list()
) {

  path_layer = writeInterleavedGeoarrow(source, layerId, geom_column_name)

  map$dependencies = c(
    map$dependencies
    , list(
      htmltools::htmlDependency(
        name = "globeControl"
        , version = "0.0.1"
        , src = system.file("htmlwidgets", package = "geoarrowDeckgl")
        , script = "globeControl.js"
      )
    )
    , list(
      htmltools::htmlDependency(
        name = "deckglPolygons"
        , version = "0.0.1"
        , src = system.file("htmlwidgets", package = "geoarrowDeckgl")
        , script = "addDeckglPolygons.js"
      )
    )
    , arrowDependencies()
    , geoarrowjsDependencies()
    , deckglDependencies()
    , geoarrowDeckglLayersDependencies()
    , deckglDataAttachmentSrc(path_layer, layerId)
    , deckglMapboxDependency()
  )

  map = htmlwidgets::onRender(
    map
    , htmlwidgets::JS(
      "function(el, x, data) {
        debugger;
        map = this.getMap();
        addDeckGlPolygons(map, data);
        addGlobeControl(map);
      }"
    )
    , data = list(
      geom_column_name = geom_column_name
      , layerId = layerId
      , renderOptions = renderOptions
      , dataAccessors = dataAccessors
    )
  )

  return(map)

}
