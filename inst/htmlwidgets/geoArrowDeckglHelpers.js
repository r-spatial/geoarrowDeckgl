function objectToTable(obj, className, columns, geom_column_name) {

  if (columns === undefined) {
    return;
  }

  let cols = Object.keys(obj);
  let vals = Object.values(obj);
  let tab = "";

  let idx = [];
  if (typeof(columns) === "object") {
    columns.forEach(name => {idx.push(cols.indexOf(name))});
  }
  if (typeof(columns) === "string") {
    idx.push(cols.indexOf(columns));
  }

  if (idx[0] === -1) { // popup string not a table column name?
    // return "<a class=" + className + ">" + columns + "</a>";
    return columns;
  }

  let cls = [];
  idx.forEach(id => { cls.push(cols.at(id)) });
  let vls = [];
  idx.forEach(id => { vls.push(vals.at(id)) });

  for (let i = 0; i < cls.length; i++) {
    if (cls[i] === geom_column_name) {
        continue;
    }
    tab += "<tr><th align='left'>" + cls[i] + "&emsp;</th>" +
    "<td align='right'>" + vls[i] + "&emsp;</td></tr>";
  }
  return "<table class=" + className + ">" + tab + "</table>";
}


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

function isHexColor(string) {
  let reg = /^#([0-9A-F]{3}){1,2}[0-9a-f]{0,2}$/i;
  return reg.test(string);
}

function colorAccessor(index, data, color)  {
  if (isHexColor(color)) {
    return hexToRGBA(color);
  }
  if (typeof(color) === "string") {
    const recordBatch = data.data;
    return hexToRGBA(recordBatch.get(index)[color]);
  }
  return color;
}

function attributeAccessor(index, data, property) {
  if (typeof(property) === "string") {
    const recordBatch = data.data;
    return recordBatch.get(index)[property];
  } else {
    return property;
  }
}

