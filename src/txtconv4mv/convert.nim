import rpgmakertype
import json

proc toEventsListData*(texts: openArray[string]): seq[EventsListData] =
  ## code: 101
  ## code: 401
  ## code: 401
  ## code: 401
  ## code: 101
  ## code: 401
  ## code: 401
  ## code: 401
  ## ...
  var params: seq[JsonNode]
  # 文章イベントであることを明示するメタデータを追加
  for i, text in texts:
    # 文章データの追加
    var node = new JsonNode
    node.kind = JString
    node.str = text
    params.add node

when false:
  var texts = """[ Bob ]
  hello
  world
  goodby"""

  var msgs = readCSV("data.csv") # [{actor, 0, 0, [helo, world]}]
  msgs.text = msgs.format(indent = true, wrapWord = -1)

  var mapData = newMapData()
  mapData.add msgs

  var project = readProject("$HOME/document/game/Project1")
  project.add mapData
  project.save
