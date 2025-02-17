addDeckglScatterplotLayer = function(map, opts) {
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

        onHover: (info, event) => {
          if (opts.tooltip === null) {
            return;
          }
          if (map.getLayoutProperty(opts.layerId, 'visibility') === 'none') {
            return;
          }
          if (opts.tooltipOptions.length !== 0) {
            //debugger;
            let tooltips = document.getElementsByClassName('geoarrow-deckgl-tooltip');
            for (let i = 0; i < tooltips.length; i++) {
              tooltips[i].remove();
            }
            if (info.picked === false) {
              return;
            }

            let tooltip = new maplibregl.Popup(
              opts.tooltipOptions
            )
            .setLngLat(info.coordinate)
            .setHTML(
              objectToTable(
                info.object,
                className = "",
                opts.tooltip,
                opts.geom_column_name
              )
            );
            tooltip.addTo(map);
          }
        },

      });

      var decklayer = new deck.MapboxOverlay({
        interleaved: true,
        layers: [geoArrowScatterplot],
      });
      map.addControl(decklayer);

      if (opts.popup !== null) {
        map.on("click", (e) => {
          //debugger;
          if (map.getLayoutProperty(opts.layerId, 'visibility') === 'none') {
            return;
          }
          let info = e.target.__deck.deckPicker.lastPickedInfo.info;
          if (info === null) {
            return;
          } else {
            let popup = new maplibregl.Popup(
              opts.popupOptions
            )
            .setLngLat(e.lngLat)
            .setHTML(
              objectToTable(
                info.object,
                className = "",
                opts.popup,
                opts.geom_column_name
              )
            );
            popup.addTo(map);
          }
        });
      }

    });
};



