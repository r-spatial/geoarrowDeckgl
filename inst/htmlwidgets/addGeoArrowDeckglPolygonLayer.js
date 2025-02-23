addGeoArrowDeckglPolygonLayer = function(map, opts) {
  let gaDeckLayers = window["@geoarrow/deck"]["gl-layers"];

  let data_fl = document.getElementById(opts.layerId + '-1-attachment');

  fetch(data_fl.href)
    .then(result => Arrow.tableFromIPC(result))
    .then(arrow_table => {
      let geoArrowPolygon = new gaDeckLayers.GeoArrowPolygonLayer({
        id: opts.layerId,
        data: arrow_table,
        getPolygon: arrow_table.getChild(opts.geom_column_name),

        // render options
        filled: opts.renderOptions.filled,
        stroked: opts.renderOptions.stroked,
        extruded: opts.renderOptions.extruded,
        wireframe: opts.renderOptions.wireframe,
        elevationScale: opts.renderOptions.elevationScale,
        lineWidthUnits: opts.renderOptions.lineWidthUnits,
        lineWidthScale: opts.renderOptions.lineWidthScale,
        lineWidthMinPixels: opts.renderOptions.lineWidthMinPixels,
        lineWidthMaxPixels: opts.renderOptions.lineWidthMaxPixels,
        lineJointRounded: opts.renderOptions.lineJointRounded,
        lineMiterLimit: opts.renderOptions.lineMiterLimit,
        /*
        material: opts.renderOptions.material,
        _normalize: opts.renderOptions._normalize,
        _windingOrder: opts.renderOptions._windingOrder,
        //https://deck.gl/docs/developer-guide/performance#supply-attributes-directly
        */

        // data accessros
        getFillColor: ({ index, data }) =>
          colorAccessor(index, data, opts.dataAccessors.getFillColor),
        getLineColor: ({ index, data }) =>
          colorAccessor(index, data, opts.dataAccessors.getLineColor),
        getLineWidth: ({ index, data }) =>
          attributeAccessor(index, data, opts.dataAccessors.getLineWidth),
        getElevation: ({ index, data }) =>
          attributeAccessor(index, data, opts.dataAccessors.getElevation),

// TODO: have functions for hover and click

        // interactivity
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
        layers: [geoArrowPolygon],
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
