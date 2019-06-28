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
  version = "v1.0.0"

template cmdConfigInit(opts: untyped) =
  debug "Start cmdConfigInit"
  const promptStr = "? "
  let tw = "-".repeat(terminalWidth())
  template lineMsg(line: string, body: untyped) =
    echo line
    echo ""
    body
    echo ""
    echo line
  
  proc inputPrompt(msg: string): string =
    echo msg
    discard readLineFromStdin(promptStr, result)
    echo ""

  let msg = message[opts.lang]
  lineMsg tw:
    echo msg["start"]

  var conf = new GenerateConfig
  conf.projectDir = inputPrompt(msg["projectDir"])
  if inputPrompt(msg["wrapWithBrackets"]).toLower == "y":
    echo "括弧 TODO"
  conf.useJoin = inputPrompt(msg["wordWrap"]).toLower == "y"
  conf.wrapWidth = inputPrompt(msg["width"]).parseInt

  echo msg["confirmConfig"]
  let tw2 = "*".repeat(terminalWidth())
  lineMsg tw2:
    echo "Project directory = " & conf.projectDir
    echo "Use join = " & $conf.useJoin
    echo "Wrap width = " & $conf.wrapWidth

  if inputPrompt(msg["finalConfirm"]).toLower == "y":
    echo "Finish"
  else:
    echo "中断"

template cmdConfigUpdate(opts: untyped) =
  debug "Start cmdConfigInit"
  discard

template cmdConfig(opts: untyped) =
  debug "Start cmdConfig"
  if opts.noInteractive:
    let data = GenerateConfig(
      projectDir: """C:\Users\YourName\Documents\Game\Project1""",
      actorNameBrackets: ["【", "】"],
      wrapWidth: 72,
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

    # MapInfos.jsonを更新する
    mapInfos.addMapInfo
  let data = mapInfos.mapIt(if it.isNil: "null"
                            else: $$it[])
                     .join(",\n")
  writeFile(mapInfosPath, "[\n" & data & "\n]")

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