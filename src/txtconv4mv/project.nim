import sentence
import strformat

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

proc toPageList*(sentences: Sentences, actorNameBrackets: array[2, string],
                 wrapWidth: int, useJoin: bool, textBrackets: array[2, string],
                 indentBracketsWidth: bool): seq[PageListElem] =
  ## * ``actorNameBrackets`` はアクター名を囲う括弧。
  ## * ``wrapWidth`` が0以下のとき、折り返しを実行しない。
  ## * ``useJoin`` がtrueのとき、文字列を折り返したときに次の行を同じ行に連結す
  ##   る。
  ## * ``textBrackets`` はセリフの前後を囲う括弧。
  ## * ``indentBracketsWidth`` は ``brackets`` の高さにテキストの高さを揃えるか
  ##   否か。
  # events[].pages[].list
  #     code:101 actor name 0 0
  #     code:401 message (1line)
  #     code:401 message (1line)
  #     code:401 message (1line)
  #     code:101 actor name 0 0
  #     code:401 message (1line)
  #     code:401 message (1line)
  #     code:0 (eventの最後)
  for sentence in sentences:
    let actor = &"{actorNameBrackets[0]}{sentence.actorName}{actorNameBrackets[1]}"
