import argparse

import txtconv4mv/[sentence, project, msgs]

import json, os, logging, rdstdin, tables, terminal
from strutils import toLower, repeat, align, join
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
  version = "v0.1.0"
  defaultWrapWidth = 55

template cmdConfigInit(opts: untyped) =
  debug "Start cmdConfigInit"

  template lineMsg(ch: string, body: untyped) =
    block:
      let line = ch.repeat(terminalWidth())
      echo line
      echo ""
      body
      echo ""
      echo line
  
  proc inputPrompt(msg: string): string =
    echo msg
    discard readLineFromStdin("? ", result)
    echo ""

  let msg = message[opts.lang]
  lineMsg "-":
    echo msg["start"]

  var conf = new GenerateConfig
  # プロジェクトのディレクトリパス
  conf.projectDir = inputPrompt(msg["projectDir"])
  # アクター名の括弧
  if inputPrompt(msg["wrapActorWithBrackets"]).toLower == "y":
    conf.actorNameBrackets[0] = inputPrompt(msg["startBracket"])
    conf.actorNameBrackets[1] = inputPrompt(msg["endBracket"])
  # テキストの括弧
  if inputPrompt(msg["wrapTextWithBrackets"]).toLower == "y":
    conf.textBrackets[0] = inputPrompt(msg["startBracket"])
    conf.textBrackets[1] = inputPrompt(msg["endBracket"])
  # 折り返すか
  conf.wrapWidth =
    if inputPrompt(msg["wrapWord"]).toLower == "y":
      # TODO デフォルト値
      inputPrompt(msg["width"]).parseInt
    else:
      0
  # 次の行と結合するか
  conf.useJoin = inputPrompt(msg["useJoin"]).toLower == "y"

  echo msg["confirmConfig"]
  echo ""
  const pad = "    "
  echo pad & "Project directory = " & conf.projectDir
  echo pad & "Actor brackets = " & $conf.actorNameBrackets
  echo pad & "Text brackets = " & $conf.textBrackets
  echo pad & "Wrap width = " & $conf.wrapWidth
  echo pad & "Use join = " & $conf.useJoin
  echo ""

  if inputPrompt(msg["finalConfirm"]).toLower == "y":
    writeFile(opts.outFile, conf[].`$$`.parseJson.pretty)
    echo pad & "Generated => " & opts.outFile
    echo ""
    lineMsg "-":
      echo msg["complete"]
  else:
    lineMsg "-":
      echo msg["interruption"]

template cmdConfigUpdate(opts: untyped) =
  debug "Start cmdConfigInit"
  echo "未実装"

template cmdConfig(opts: untyped) =
  debug "Start cmdConfig"
  if opts.noInteractive:
    let data = GenerateConfig(
      projectDir: """C:\Users\YourName\Documents\Game\Project1""",
      actorNameBrackets: ["【", "】"],
      wrapWidth: defaultWrapWidth,
      useJoin: true,
      textBrackets: ["「", "」"])
    writeFile("config.json", data[].`$$`.parseJson.pretty)
    return

  case opts.cmd
  of "init": cmdConfigInit(opts)
  of "update": cmdConfigUpdate(opts)

template cmdGenerate(opts: untyped) =
  debug "Start cmdGenerate"

  proc createMapFilePath(dir: string, index: int): string =
    # MapXXX.jsonのファイルパスを生成
    # 一番大きい数値を取得し、1加算する
    let
      n = align($index, 3, '0')
      mapFile = dir / "Map" & n & ".json"
    return mapFile

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
      mapFilePath = createMapFilePath(dataDir, mapInfos.getAddableId)
    writeFile(mapFilePath, obj.pretty)
    debug "Generated: " & mapFilePath

    # MapInfos.jsonを更新する
    mapInfos.addMapInfo
  let data = mapInfos.mapIt(if it.isNil: "null"
                            else: $$it[])
                     .join(",\n")
  writeFile(mapInfosPath, "[\n" & data & "\n]")
  debug "Update: " & mapInfosPath

proc setLogger(use: bool) =
  if use:
    newConsoleLogger(lvlAll, verboseFmtStr).addHandler()

proc main(params: seq[string]) =
  var p = newParser(appName):
    command("config"):
      help("Generate config file")
      flag("-X", "--debug", help="Debug on")
      option("-l", "--lang", default="ja", help="Message language")
      flag("-I", "--no-interactive", help="No interactive mode")
      arg("cmd", help="init or update")
      option("-o", "--out-file", default="config.json", help="Output file path")
      run:
        setLogger(opts.debug)
        cmdConfig(opts)
    command("generate"):
      help("Generate MapXXX.json and MapInfos.json from sentence CSV file")
      flag("-X", "--debug", help="Debug on")
      option("-f", "--config-file", default="config.json", help="Config file")
      arg("args", nargs = -1)
      run:
        setLogger(opts.debug)
        cmdGenerate(opts)
    command("version"):
      help("Print version")
      run:
        echo version
  p.run(params)

when isMainModule:
  main(commandLineParams())