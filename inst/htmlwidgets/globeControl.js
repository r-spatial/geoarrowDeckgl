addGlobeControl = function(map) {
  if (window.maplibregl === undefined) {
    return;
  }
  let globecontrol = new maplibregl.GlobeControl();
  map.addControl(globecontrol);
}
