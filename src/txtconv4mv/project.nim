import sentence
import json, os

type
  MapInfos* = seq[MapInfo]
  MapInfo* = ref object
    id*: int64
    expanded*: bool
    name*: string
    order*: int64
    parentId*: int64
    scrollX*: float64
    scrollY*: float64

proc newMapObj: JsonNode =
  result = %* {
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

proc readMapInfos*(f: string): MapInfos =
  parseFile(f).to(MapInfos)

proc getBiggestMapIndex*(dir: string): int =
  for f in walkFiles(dir / "Map*.json"):
    if f.lastPathPart != "MapInfos.json":
      inc(result)

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
  var list = newJArray()
  for sentence in sentences:
    let texts = sentence.format(actorNameBrackets, wrapWidth, useJoin, textBrackets)
    for i, line in texts:
      if i mod 4 == 0:
        list.add(newSentenceEventMetaPrefix())
      list.add(newSentenceEventBody(line))
    list.add(newSentenceEventMetaSuffix())
  result = newMapObj()
  result["events"][1]["pages"][0]["list"] = list

proc `$`*(self: MapInfo): string = $self[]