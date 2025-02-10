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
        getRadius: opts.dataAccessors.getRadius,
        getFillColor: ({ index, data }) => {
          if (typeof(opts.dataAccessors.getFillColor) === "string") {
            const recordBatch = data.data;
            return hexToRGBA(recordBatch.get(index)[opts.dataAccessors.getFillColor]);
          } else {
            return opts.dataAccessors.getFillColor;
          }
        },
        // TODO: all accessors should behave as fillColor!
        getLineColor: opts.dataAccessors.getLineColor,
        getLineWidth: opts.dataAccessors.getLineWidth,
      });
      
      var decklayer = new deck.MapboxOverlay({
        interleaved: true,
        layers: [geoArrowScatterplot],
      });
      map.addControl(decklayer);
      return map;
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

