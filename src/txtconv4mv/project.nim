import sentence
import json, os
from sequtils import filterIt, mapIt

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
  ## Map.jsonの雛形データを返す。
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
  ## MapInfos.jsonを読み取ってオブジェクトとして返す。
  parseFile(f).to(MapInfos)

template newEventTmpl(code: int, indent: int, paramsBody: untyped): untyped =
  ## Map.jsonのListの部分のデータを構造を一部作って返す。
  ## parametersの部分だけはparamsBodyで構築する。
  result = newJObject()
  result.add("code", newJInt(code))
  result.add("indent", newJInt(indent))
  paramsBody
  result.add("parameters", parameters)

proc newSentenceEventMetaPrefix(): JsonNode =
  ## 文章の開始を示すメタデータを生成する。
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
  ## 文章のデータを生成する。
  ## 文章は１行の文字列でないといけない。
  # {
  #   "code": 401,
  #   "indent": 0,
  #   "parameters": ["1"]
  # }
  newEventTmpl 401, 0:
    var parameters = newJArray()
    parameters.add(newJString(line))

proc newSentenceEventMetaSuffix(): JsonNode =
  ## イベントの最後を示すメタデータを返す。
  # {
  #   "code": 0,
  #   "indent": 0,
  #   "parameters": []
  # }
  newEventTmpl 0, 0:
    var parameters = newJArray()

proc newMapObject*(sentences: Sentences, actorNameBrackets: array[2, string],
                     wrapWidth: int, useJoin: bool, textBrackets: array[2, string]): JsonNode =
  ## MapXXX.jsonのデータを生成する。
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

proc getAddableId*(self: MapInfos): int =
  ## MapInfosのうち、次にデータを追加する位置IDを返す。
  if 1 < self.filterIt(it.isNil).len:
    for i, elem in self:
      if elem.isNil and 0 < i:
        return i
  return self.len

proc addMapInfo*(self: var MapInfos) =
  ## ``self`` にMapInfoを追加する。
  ## MapInfoが実際にdataディレクトリに存在しなくても追加してしまう。
  let order = self.filterIt(not it.isNil).mapIt(it.order).max + 1
  let id = getAddableId(self)
  var mi = MapInfo(id: id, expanded: false, name: "txtconv4mv", order: order,
                   parentId: 0, scrollX: 0.0, scrollY: 0.0)
  # 先頭のは常にnullなので
  if 1 < self.filterIt(it.isNil).len:
    # 途中にnullが存在したらその位置を上書きする
    self[id] = mi
  else:
    # 途中にnullが存在しないときは末尾に追加
    self.add(mi)

proc `$`*(self: MapInfo): string = $self[]
  