import argparse

import txtconv4mv/[sentence, project, msgs]

import json, os, logging, rdstdin, tables, terminal
from strutils import toLower, repeat, align
from sequtils import mapIt, filterIt
from marshal import `$$`

type
  GenerateConfig = ref object
    projectDir: string
    actorNameBrackets: array[2, string]
    wrapWidth: int
    useJoin: bool
    textBrackets: array[2, string]

const
  appName = "txtconv4mv"
  version = "v1.0.0"

template cmdConfigInit(opts: untyped) =
  discard

template cmdConfigUpdate(opts: untyped) =
  discard

template cmdConfig(opts: untyped) =
  debug "Start cmdConfig"
  const promptStr = "? "
  let tw = "-".repeat(terminalWidth())
  proc lineMsg(msg, line: string) =
    echo line
    echo ""
    echo msg
    echo ""
    echo line

  let msg = message[opts.lang]
  lineMsg(msg["start"], tw)

  echo msg["projectDir"]
  let projDir = readLineFromStdin(promptStr)

  echo msg["wrapWithBrackets"]
  let useWrap = readLineFromStdin(promptStr)

  if useWrap.toLower == "y":
    echo "括弧"

  echo msg["wordWrap"]
  let wrapWord = readLineFromStdin(promptStr)

  echo msg["width"]
  let width = readLineFromStdin(promptStr)

  echo ""
  echo msg["confirmConfig"]
  let tw2 = "*".repeat(terminalWidth())
  lineMsg("projDir = " & projDir, tw2)

  echo msg["finalConfirm"]
  let yes = readLineFromStdin(promptStr)
  if yes.toLower == "y":
    discard
  else:
    echo "中断"

template cmdGenerate(opts: untyped) =
  debug "Start cmdGenerate"

  proc createMapFilePath(dir: string): string =
    # MapXXX.jsonのファイルパスを生成
    # 一番大きい数値を取得し、1加算する
    let
      index = getBiggestMapIndex(dir) + 1
      n = align($index, 3, '0')
      mapFile = dir / "Map" & n & ".json"
    return mapFile
  
  proc addMapInfo(self: var MapInfos, mi: MapInfo) =
    # 先頭のは常にnullなので
    if 1 < self.filterIt(it.isNil).len:
      var nilCount: int
      # 途中にnullが存在したらその位置を上書きする
      # idはnullの位置と同じ
      for elem in self:
        if elem.isNil:
          inc(nilCount)
        if 1 < nilCount:
          mi.id = nilCount
          self[mi.id] = mi
          return
    # 途中にnullが存在しないときは末尾に追加
    # idは一番大きいIDの次の値
    let id = self.filterIt(not it.isNil).mapIt(it.id).max + 1
    mi.id = id
    self.add(mi)

  let
    config = parseFile(opts.configFile).to(GenerateConfig)
    dataDir = config.projectDir / "data"
    mapInfosPath = dataDir / "MapInfos.json"
  var
    mapInfos = readMapInfos(mapInfosPath)
  for f in opts.args:
    # MapXXX.jsonを生成する
    let
      # 文章ファイルからデータ取得
      ss = readSentenceFile(f)
      # MapXXX.jsonのデータを生成
      obj = newMapObject(ss, config.actorNameBrackets, config.wrapWidth,
                         config.useJoin, config.textBrackets)
      mapFilePath = createMapFilePath(dataDir)
    writeFile(mapFilePath, obj.pretty)

    # MapInfos.jsonを更新する
    let order = mapInfos.filterIt(not it.isNil).mapIt(it.order).max + 1
    var mi = MapInfo(id: -1, expanded: false, name: "txtconv4mv", order: order,
                     parentId: 0, scrollX: 0.0, scrollY: 0.0)
    mapInfos.addMapInfo(mi)
  writeFile(mapInfosPath, mapInfos.mapIt(it[]).`$$`.parseJson.pretty)

proc main(params: seq[string]) =
  var p = newParser(appName):
    command("config"):
      option("-l", "--lang", default="ja", help="Message language")
      run:
        cmdConfig(opts)
    command("generate"):
      option("-f", "--config-file", default="config.json", help="Config file")
      arg("args", nargs = -1)
      run:
        cmdGenerate(opts)
    option("-o", "--output", help="Output to this file")
    flag("-X", "--debug", help="Debug on")
    flag("-v", "--version", help="Print version info")
  
  var opts = p.parse(params)

  if opts.version:
    echo version
    return

  if opts.debug:
    newConsoleLogger(lvlAll, verboseFmtStr).addHandler()
  
  debug opts
  p.run(params)

when isMainModule:
  main(commandLineParams())