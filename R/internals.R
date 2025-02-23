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
