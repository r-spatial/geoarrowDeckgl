addGeoArrowDeckglPathLayer = function(map, opts) {
  let gaDeckLayers = window["@geoarrow/deck"]["gl-layers"];

  let data_fl = document.getElementById(opts.layerId + '-1-attachment');

  fetch(data_fl.href)
    .then(result => Arrow.tableFromIPC(result))
    .then(arrow_table => {
      let geoArrowPathLayer = new gaDeckLayers.GeoArrowPathLayer({
        id: opts.layerId,
        data: arrow_table,
        getPath: arrow_table.getChild(opts.geom_column_name),

        // render options
        widthUnits: opts.renderOptions.widthUnits,
        widthScale: opts.renderOptions.widthScale,
        widthMinPixels: opts.renderOptions.widthMinPixels,
        widthMaxPixels: opts.renderOptions.widthMaxPixels,
        capRounded: opts.renderOptions.capRounded,
        jointRounded: opts.renderOptions.jointRounded,
        billboard: opts.renderOptions.billboard,
        miterLimit: opts.renderOptions.miterLimit,
        // _pathType: opts.renderOptions._pathType,

        // data accessros
        getColor: ({ index, data }) => {
          if (typeof(opts.dataAccessors.getColor) === "string") {
            const recordBatch = data.data;
            return hexToRGBA(recordBatch.get(index)[opts.dataAccessors.getColor]);
          } else {
            return opts.dataAccessors.getColor;
          }
        },
        getWidth: ({ index, data }) => {
          if (typeof(opts.dataAccessors.getWidth) === "string") {
            const recordBatch = data.data;
            return recordBatch.get(index)[opts.dataAccessors.getWidth];
          } else {
            return opts.dataAccessors.getWidth;
          }
        },

        // interactivity
        pickable: true,
/*
        onHover: (info, event) => {
          //debugger;
          let popups = document.getElementsByClassName("maplibregl-popup");
          for (let i = 0; i < popups.length; i++) {
            popups[i].remove();
          }
          if (info.object.id === undefined) {
            return;
          }
          //console.log(info.coordinate);

          const description = info.object.id.toString();
          let popup = new maplibregl.Popup()
            .setLngLat(info.coordinate)
            .setText(description);

          popup.addTo(map);
        },
*/
        //onHover: updateTooltip
      });

      var decklayer = new deck.MapboxOverlay({
        interleaved: true,
        //views: [new deck.MapView({id: 'maplibregl'})],
        layers: [geoArrowPathLayer],
      });
      map.addControl(decklayer);

      map.on("click", (e) => {
        //debugger;
        let info = e.target.__deck.deckPicker.lastPickedInfo.info;
        if (info === null) {
          return;
        } else {
          let popup = new maplibregl.Popup()
            .setLngLat(e.lngLat)
            .setHTML(info.object["NAME"]);
          popup.addTo(map);
        }
      });


      //return map;
    });
};
