# This is just an example to get you started. A typical binary package
# uses this file as the main entry point of the application.

import argparse
import txtconv4mv/[sentence, project, msgs]
import json, os, logging, rdstdin, tables, terminal
from strutils import toLower, repeat, align

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
  let configFile = opts.configFile
  let config = parseFile(opts.configFile).to(GenerateConfig)
  for f in opts.args:
    let
      # 文章ファイルからデータ取得
      ss = readSentenceFile(f)
      # MapXXX.jsonのデータを生成
      obj = newMapObject(ss, config.actorNameBrackets, config.wrapWidth,
                         config.useJoin, config.textBrackets)
      # MapXXX.jsonのファイルパスを生成
      # 一番大きい数値を取得し、1加算する
      dataDir = config.projectDir / "data"
      index = getBiggestMapIndex(dataDir) + 1
      n = align($index, 3, '0')
      mapFile = dataDir / "Map" & n & ".json"
    writeFile(mapFile, obj.pretty)

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