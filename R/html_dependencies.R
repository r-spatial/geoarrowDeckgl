## deck.gl js ==================================================================
deckglDependencies = function() {
  list(
    htmltools::htmlDependency(
      "deck.gl",
      '9.1.0',
      src = c(
        href = "https://cdn.jsdelivr.net/npm/deck.gl@9.1.0"
      )
      , script = "dist.min.js"
    )
  )
}

## data src ====================================================================
deckglDataAttachmentSrc = function(fn, layerId) {
  data_dir <- dirname(fn)
  data_file <- basename(fn)
  list(
    htmltools::htmlDependency(
      name = layerId,
      version = '0.0.1',
      src = c(file = data_dir),
      attachment = data_file
    )
  )
}

## arrow js ====================================================================
arrowDependencies = function() {
  list(
    htmltools::htmlDependency(
      "apache-arrow",
      '16.1.0',
      src = c(
        href = "https://cdn.jsdelivr.net/npm/apache-arrow@16.1.0"
      )
      , script = "Arrow.es2015.min.js"
    )
  )
}

## geoarrow deck.gl-layers js ==================================================
geoarrowDeckglLayersDependencies = function() {
  list(
    htmltools::htmlDependency(
      "geoarrow-deckgl-layers",
      '0.3.0-17',
      src = c(
        href = "https://cdn.jsdelivr.net/npm/@geoarrow/deck.gl-layers@0.3.0/dist"
      )
      , script = "dist.umd.min.js"
    )
  )
}

## geoarrow js =================================================================
geoarrowjsDependencies = function() {
  list(
    htmltools::htmlDependency(
      "geoarrow-js",
      '0.3.0',
      src = c(
        href = "https://cdn.jsdelivr.net/npm/@geoarrow/geoarrow-js@0.3.1/dist"
      )
      , script = "geoarrow.umd.min.js"
    )
  )
}

## deck.gl js mapbox ===========================================================
deckglMapboxDependency = function() {
  list(
    htmltools::htmlDependency(
      "deck.gl",
      '9.0.14',
      src = c(
        href = "https://cdn.jsdelivr.net/npm/@deck.gl/mapbox@9.1.0/dist/"
      )
      , script = "resolve-layers.min.js"
    )
  )
}

## helpers js ==================================================================
helpersDependency = function() {
  list(
    htmltools::htmlDependency(
      "geoarrowDeckglHelpers"
      , '0.0.1'
      , src = system.file("htmlwidgets", package = "geoarrowDeckgl")
      , script = "geoArrowDeckglHelpers.js"
    )
  )
}
