writeInterleavedGeoarrow = function(data, layerId, geom_column_name) {
  layer_path = tempfile()
  dir.create(layer_path)
  layer_path = paste0(layer_path, "/", layerId, "_layer.arrow")

  geom_type = geoarrow::infer_geoarrow_schema(data, coord_type = "INTERLEAVED")
  data_schema = nanoarrow::infer_nanoarrow_schema(data)
  data_schema$children[[geom_column_name]] = geom_type

  data_out = nanoarrow::as_nanoarrow_array_stream(
    data
    , schema = data_schema
  )

  nanoarrow::write_nanoarrow(data_out, layer_path)

  return(layer_path)

}


renderOptions = function(...) {

  # infer the function that called renderOptions
  syscall1 = deparse(sys.call(1))[1]
  rgx = gregexpr("^.*?(?=\\()", syscall1, perl = TRUE)[[1]]
  len = attr(rgx, "match.length")
  call = substr(syscall1, 1, len)
  splt = unlist(strsplit(call, ":"))
  fun = splt[length(splt)]
  print(fun)

  # TODO: switch defaults based on fun

  default_lst = list(
    radiusUnits = "pixels"
    , radiusScale = 1
    , lineWidthUnits = "pixels"
    , lineWidthScale = 1
    , stroked = TRUE
    , filled = TRUE
    , radiusMinPixels = 3
    , radiusMaxPixels = 15
    , lineWidthMinPixels = 0
    , lineWidthMaxPixels = 15
    , billboard = FALSE
    , antialiasing = FALSE
    , extruded = FALSE
    , wireframe = TRUE
    , elevationScale = 1
    , lineJointRounded = FALSE
    , lineMiterLimit = 4
    , widthScale = 1
    , widthMinPixels = 1
    , widthMaxPixels = 5
    , capRounded = TRUE
    , jointRounded = FALSE
    , miterLimit = 4
  )

  dot_lst = list(...)

  utils::modifyList(default_lst, dot_lst)
}


popupOptions = function(...) {

  default_lst = list(
    anchor = "bottom"
    , className = ""
    , closeButton = TRUE
    , closeOnClick = TRUE
    , closeOnMove = FALSE
    , focusAfterOpen = TRUE
    , maxWidth = "none"
  )

  dot_lst = list(...)

  utils::modifyList(default_lst, dot_lst)
}


tooltipOptions = function(...) {

  default_lst = list(
    anchor = "top-left"
    , className = "geoarrow-deckgl-tooltip"
    , closeButton = FALSE
    , closeOnClick = FALSE
    , closeOnMove = FALSE
    , focusAfterOpen = TRUE
    , maxWidth = "none"
  )

  dot_lst = list(...)

  utils::modifyList(default_lst, dot_lst)
}
