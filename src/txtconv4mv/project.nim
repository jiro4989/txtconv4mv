type
  DataMap = ref object
    autoplayBgm: bool
    autoplayBgs: bool
    battleback1Name: string
    battleback2Name: string
    bgm: Bgm
    bgs: Bgs
    disableDashing: bool
    displayName: string
    encounterList: seq[int64] ## 空配列でよい
    encounterStep: int64
    height: int64
    note: string
    parallaxLoopX: bool
    parallaxLoopY: bool
    parallaxName: string
    parallaxShow: bool
    parallaxSx: int64
    parallaxSy: int64
    scrollType: int64
    specifyBattleback: bool
    tilesetId: int64
    width: int64
    data: seq[int64]
    events: seq[Event]
  Bgm = ref object
    name: string
    pan: int64
    pitch: int64
    volume: int64
  Bgs = ref object
    name: string
    pan: int64
    pitch: int64
    volume: int64
  Event = ref object
    id: int64
    name: string
    note: string
    pages: seq[Page]
    x: int64
    y: int64
  Page = ref object
    conditions: Conditions
    directionFix: bool
    image: Image
    list: seq[PageListElem]
    moveFrequency: int64
    moveRoute: MoveRoute
    moveSpeed: int64
    moveType: int64
    priorityType: int64
    stepAnime: bool
    through: bool
    trigger: int64
    walkAnime: bool
  Conditions = ref object
    actorId: int64
    actorValid: bool
    itemId: int64
    itemValid: bool
    selfSwitchCh: string
    selfSwitchValid: bool
    switch1Id: int64
    switch1Valid: bool
    switch2Id: int64
    switch2Valid: bool
    variableId: int64
    variableValid: bool
    variableValue: int64
  Image = ref object
    characterIndex: int64
    characterName: string
    direction: int64
    pattern: int64
    tileId: int64
  PageListElem = ref object
    code: int64
    indent: int64
    parameters: seq[string]
  MoveRoute = ref object
    list: seq[MoveRouteListElem]
    repeat: bool
    skippable: bool
    wait: bool
  MoveRouteListElem = ref object
    code: int64
    parameters: seq[int64] ## 空配列で良い

type
  MapInfos = seq[MapInfo]
  MapInfo = ref object
    id: int64
    expanded: bool
    name: string
    order: int64
    parentId: int64
    scrollX: float64
    scrollY: float64
