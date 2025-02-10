addGlobeControl = function(map) {
  let globecontrol = new maplibregl.GlobeControl();
  map.addControl(globecontrol);
  return map;
}