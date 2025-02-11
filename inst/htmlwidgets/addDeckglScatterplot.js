addDeckGlScatterplot = function(map, opts) {
  let gaDeckLayers = window["@geoarrow/deck"]["gl-layers"];

  let data_fl = document.getElementById(opts.layerId + '-1-attachment');

  fetch(data_fl.href)
    .then(result => Arrow.tableFromIPC(result))
    .then(arrow_table => {
      let geoArrowScatterplot = new gaDeckLayers.GeoArrowScatterplotLayer({
        id: opts.layerId,
        data: arrow_table,
        getPosition: arrow_table.getChild(opts.geom_column_name),
        radiusUnits: opts.renderOptions.radiusUnits,
        radiusScale: opts.renderOptions.radiusScale,
        lineWidthUnits: opts.renderOptions.lineWidthUnits,
        lineWidthScale: opts.renderOptions.lineWidthScale,
        stroked: opts.renderOptions.stroked,
        filled: opts.renderOptions.filled,
        radiusMinPixels: opts.renderOptions.radiusMinPixels,
        radiusMaxPixels: opts.renderOptions.radiusMaxPixels,
        lineWidthMinPixels: opts.renderOptions.lineWidthMinPixels,
        lineWidthMaxPixels: opts.renderOptions.lineWidthMaxPixels,
        billboard: opts.renderOptions.billboard,
        antialiasing: opts.renderOptions.antialiasing,
        getRadius: ({ index, data }) => {
          if (typeof(opts.dataAccessors.getRadius) === "string") {
            const recordBatch = data.data;
            return recordBatch.get(index)[opts.dataAccessors.getRadius];
          } else {
            return opts.dataAccessors.getRadius;
          }
        },
        getFillColor: ({ index, data }) => {
          if (typeof(opts.dataAccessors.getFillColor) === "string") {
            const recordBatch = data.data;
            return hexToRGBA(recordBatch.get(index)[opts.dataAccessors.getFillColor]);
          } else {
            return opts.dataAccessors.getFillColor;
          }
        },
        // TODO: all accessors should behave as fillColor!
        getLineColor: ({ index, data }) => {
          if (typeof(opts.dataAccessors.getLineColor) === "string") {
            const recordBatch = data.data;
            return hexToRGBA(recordBatch.get(index)[opts.dataAccessors.getLineColor]);
          } else {
            return opts.dataAccessors.getLineColor;
          }
        },
        getLineWidth: ({ index, data }) => {
          if (typeof(opts.dataAccessors.getLineWidth) === "string") {
            const recordBatch = data.data;
            return recordBatch.get(index)[opts.dataAccessors.getLineWidth];
          } else {
            return opts.dataAccessors.getLineWidth;
          }
        },
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
        layers: [geoArrowScatterplot],
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
            .setHTML(info.object["fillColor"]);
          popup.addTo(map);
        }
      });


      //return map;
    });
};


function hexToRGBA(hex) {
    // remove invalid characters
    hex = hex.replace(/[^0-9a-fA-F]/g, '');

    if (hex.length < 5) {
        // 3, 4 characters double-up
        hex = hex.split('').map(s => s + s).join('');
    }

    // parse pairs of two
    let rgba = hex.match(/.{1,2}/g).map(s => parseInt(s, 16));

    // alpha code between 0 & 1 / default 1
    //rgba[3] = rgba.length > 3 ? parseFloat(rgba[3] / 255).toFixed(2): 1;

    return rgba; //'rgba(' + rgba.join(', ') + ')';
}

