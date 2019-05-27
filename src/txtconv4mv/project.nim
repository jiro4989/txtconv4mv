import gamemap

type
  RPGMakerMVProjectObj = object
  RPGMakerMVProject = ref RPGMakerMVProjectObj

proc readProject*(filename: string): RPGMakerMVProject =
  discard

proc add*(self: var RPGMakerMVProject, mapData: MapData) =
  discard
