# 2025-11-15 ====

## TEST WITH 2+ POLYGONS LAYERS ====

library(osmdata)
library(sf)

## get area of interest from osm
aoi = opq_osm_id (
  type = "relation"
  , id = 1152702
) |>
  opq_string () |>
  osmdata_sf () |> 
  getElement("osm_multipolygons") |> 
  st_transform(
    crs = 25832L
  )

## download parcels
cli = ows4R::WFSClient$new(
  "https://geo5.service24.rlp.de/wfs/alkis_rp.fcgi"
  , serviceVersion = "2.0.0"
)

parcels = cli$getFeatures(
  "ave:Flurstueck"
  , bbox = paste(
    st_bbox(aoi)
    , collapse = ","
  )
) |> 
  st_transform(
    crs = 4326L
  )
