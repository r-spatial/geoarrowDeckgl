addDeckglPolygonLayer = function(map, opts) {
  let gaDeckLayers = window["@geoarrow/deck"]["gl-layers"];

  let data_fl = document.getElementById(opts.layerId + '-1-attachment');

  fetch(data_fl.href)
    .then(result => Arrow.tableFromIPC(result))
    .then(arrow_table => {
      let geoArrowPolygon = new gaDeckLayers.GeoArrowPolygonLayer({
        id: opts.layerId,
        data: arrow_table,
        getPolygon: arrow_table.getChild(opts.geom_column_name),
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
        // getFillColor: opts.dataAccessors.getLineColor,

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
        getElevation: ({ index, data }) => {
          if (typeof(opts.dataAccessors.getElevation) === "string") {
            const recordBatch = data.data;
            return recordBatch.get(index)[opts.dataAccessors.getElevation];
          } else {
            return opts.dataAccessors.getElevation;
          }
        },
      });

      var decklayer = new deck.MapboxOverlay({
        interleaved: true,
        layers: [geoArrowPolygon],
      });
      map.addControl(decklayer);
      return map;
    });
};
