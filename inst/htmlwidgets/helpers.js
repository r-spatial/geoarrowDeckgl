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
