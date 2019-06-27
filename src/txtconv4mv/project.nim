import sentence
import json

var mapTemplate = %* {
    "autoplayBgm": false,
    "autoplayBgs": false,
    "battleback1Name": "",
    "battleback2Name": "",
    "bgm": {
        "name": "",
        "pan": 0,
        "pitch": 100,
        "volume": 90
    },
    "bgs": {
        "name": "",
        "pan": 0,
        "pitch": 100,
        "volume": 90
    },
    "disableDashing": false,
    "displayName": "",
    "encounterList": [],
    "encounterStep": 30,
    "height": 1,
    "note": "",
    "parallaxLoopX": false,
    "parallaxLoopY": false,
    "parallaxName": "",
    "parallaxShow": true,
    "parallaxSx": 0,
    "parallaxSy": 0,
    "scrollType": 0,
    "specifyBattleback": false,
    "tilesetId": 1,
    "width": 1,
    "data": [0, 0, 0, 0, 0, 0],
    "events": [
        nil,
        {
            "id": 1,
            "name": "EV001",
            "note": "",
            "pages": [{
                "conditions": {
                    "actorId": 1,
                    "actorValid": false,
                    "itemId": 1,
                    "itemValid": false,
                    "selfSwitchCh": "A",
                    "selfSwitchValid": false,
                    "switch1Id": 1,
                    "switch1Valid": false,
                    "switch2Id": 1,
                    "switch2Valid": false,
                    "variableId": 1,
                    "variableValid": false,
                    "variableValue": 0
                },
                "directionFix": false,
                "image": {
                    "characterIndex": 0,
                    "characterName": "",
                    "direction": 2,
                    "pattern": 0,
                    "tileId": 0
                },
                "list": [{
                    "code": 101,
                    "indent": 0,
                    "parameters": ["", 0, 0, 2]
                }, {
                    "code": 401,
                    "indent": 0,
                    "parameters": ["1"]
                }, {
                    "code": 401,
                    "indent": 0,
                    "parameters": ["2"]
                }, {
                    "code": 401,
                    "indent": 0,
                    "parameters": ["3"]
                }, {
                    "code": 401,
                    "indent": 0,
                    "parameters": ["4"]
                }, {
                    "code": 101,
                    "indent": 0,
                    "parameters": ["", 0, 0, 2]
                }, {
                    "code": 401,
                    "indent": 0,
                    "parameters": ["a"]
                }, {
                    "code": 401,
                    "indent": 0,
                    "parameters": ["b"]
                }, {
                    "code": 401,
                    "indent": 0,
                    "parameters": ["c"]
                }, {
                    "code": 401,
                    "indent": 0,
                    "parameters": ["d"]
                }, {
                    "code": 0,
                    "indent": 0,
                    "parameters": []
                }],
                "moveFrequency": 3,
                "moveRoute": {
                    "list": [{
                        "code": 0,
                        "parameters": []
                    }],
                    "repeat": true,
                    "skippable": false,
                    "wait": false
                },
                "moveSpeed": 3,
                "moveType": 0,
                "priorityType": 0,
                "stepAnime": false,
                "through": false,
                "trigger": 0,
                "walkAnime": true
            }],
            "x": 0,
            "y": 0
        }
    ]
}

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

template newEventTmpl(code: int, indent: int, paramsBody: untyped): untyped =
  result = newJObject()
  result.add("code", newJInt(code))
  result.add("indent", newJInt(indent))
  paramsBody
  result.add("parameters", parameters)

proc newSentenceEventMetaPrefix(): JsonNode =
  # {
  #   "code": 101,
  #   "indent": 0,
  #   "parameters": ["", 0, 0, 2]
  # }
  newEventTmpl 101, 0:
    var parameters = newJArray()
    parameters.add(newJString(""))
    parameters.add(newJInt(0)) # TODO
    parameters.add(newJInt(0)) # TODO
    parameters.add(newJInt(2)) # TODO

proc newSentenceEventBody(line: string): JsonNode =
  # {
  #   "code": 401,
  #   "indent": 0,
  #   "parameters": ["1"]
  # }
  newEventTmpl 401, 0:
    var parameters = newJArray()
    parameters.add(newJString(line))

proc newSentenceEventMetaSuffix(): JsonNode =
  # {
  #   "code": 0,
  #   "indent": 0,
  #   "parameters": []
  # }
  newEventTmpl 0, 0:
    var parameters = newJArray()

proc newMapObject*(sentences: Sentences, actorNameBrackets: array[2, string],
                     wrapWidth: int, useJoin: bool, textBrackets: array[2, string]): JsonNode =
  for sentence in sentences:
    let texts = sentence.format(actorNameBrackets, wrapWidth, useJoin, textBrackets)
    var list = newJArray()
    for i, line in texts:
      if i mod 4 == 0:
        list.add(newSentenceEventMetaPrefix())
      list.add(newSentenceEventBody(line))
    list.add(newSentenceEventMetaSuffix())
    mapTemplate["events"][1]["pages"][1]["list"] = list
    echo mapTemplate