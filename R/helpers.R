writeInterleavedGeoarrow = function(data, layerId, geom_column_name) {
  path_layer = tempfile()
  dir.create(path_layer)
  path_layer = paste0(path_layer, "/", layerId, "_layer.arrow")

  geom_type = geoarrow::infer_geoarrow_schema(data, coord_type = "INTERLEAVED")
  data_schema = nanoarrow::infer_nanoarrow_schema(data)
  data_schema$children[[geom_column_name]] = geom_type

  data_out = nanoarrow::as_nanoarrow_array_stream(
    data
    , schema = data_schema
  )

  nanoarrow::write_nanoarrow(data_out, path_layer)

  return(path_layer)

}
