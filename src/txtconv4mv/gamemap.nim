import textevent
import json

type
  BGM* = ref object
    name*: string
    pan*: int
    pitch*: int
    volume*: int
  BGS* = ref object
    name*: string
    pan*: int
    pitch*: int
    volume*: int
  Conditions* = ref object
    actorId*: int
    actorValid*: bool
    itemId*: int
    itemValid*: bool
    selfSwitchCh*: string
    selfSwitchValid*: bool
    switch1Id*: int
    switch1Valid*: bool
    switch2Id*: int
    switch2Valid*: bool
    variableId*: int
    variableValid*: bool
    variableValue*: int
  Image* = ref object
    characterIndex*: int
    characterName*: string
    direction*: int
    pattern*: int
    tileId*: int
  EventsListData* = ref object
    code*: int
    indent*: int
    parameters*: seq[JsonNode]
  MoveRouteListData* = ref object
    code*: int
    parameters*: seq[JsonNode]
  MoveRoute* = ref object
    list*: seq[MoveRouteListData]
    repeat*: bool
    skippable*: bool
    wait*: bool
  Page* = ref object
    conditions*: Conditions
    directionFix*: bool
    image*: Image
    list*: seq[EventsListData]
    moveFrequency*: int
    moveRoute*: MoveRoute
    moveSpeed*: int
    moveType*: int
    priorityType*: int
    stepAnime*: bool
    through*: bool
    trigger*: int
    walkAnime*: bool
  Event* = ref object
    id*: int
    name*: string
    note*: string
    pages*: seq[Page]
    x*: int
    y*: int
  MapData* = object
    autoplayBgm*: bool
    autoplayBgs*: bool
    battleback1Name*: string
    battleback2Name*: string
    bgm*: BGM
    bgs*: BGS
    disableDashing*: bool
    displayName*: string
    encounterList*: seq[JsonNode]
    encounterStep*: int
    height*: int
    note*: string
    parallaxLoopX*: bool
    parallaxLoopY*: bool
    parallaxName*: string
    parallaxShow*: bool
    parallaxSx*: int
    parallaxSy*: int
    scrollType*: int
    specifyBattleback*: bool
    tilesetId*: int
    width*: int
    data*: seq[int]
    events*: seq[Event]

const
  texeEventMetaCode* = 101
  texeEventCode* = 401

proc newMapData*(): MapData =
  discard

proc toBackgroundCode(s: string): int =
  ## TODO
  0

proc toPositionCode(s: string): int =
  ## TODO
  0

proc newEventsListDatas*(textEvent: TextEvent): seq[EventsListData] =
  var metaEv = new EventsListData
  metaEv.code = texeEventMetaCode
  metaEv.indent = 0

  var image = new JsonNode
  image.kind = JString
  image.str = textEvent.image
  metaEv.parameters.add image

  var background = new JsonNode
  image.kind = JInt
  image.num = textEvent.background.toBackgroundCode
  metaEv.parameters.add background

  var position = new JsonNode
  image.kind = JInt
  image.num = textEvent.position.toPositionCode
  metaEv.parameters.add position

  result.add metaEv

  for line in textEvent.text:
    var param = new JsonNode
    param.kind = JString
    param.str = line

    var ev = new EventsListData
    ev.code = texeEventCode
    ev.indent = 0
    ev.parameters.add param
    result.add ev

proc add*(self: var MapData, textEvent: TextEvent) =
  self.events[1].pages[0].list.add newEventsListDatas(textEvent)
