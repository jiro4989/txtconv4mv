# This is just an example to get you started. A typical binary package
# uses this file as the main entry point of the application.

import argparse
import txtconv4mv/[sentence, project, msgs]
import json, os, logging, rdstdin, tables, terminal
from strutils import toLower, repeat

const
  appName = "txtconv4mv"
  version = "v1.0.0"

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

  let msg = message["ja"]
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
  echo("Hello, World!")
  let ss = readSentenceFile("examples/text1.csv")
  let obj = newMapObject(ss, ["<<", ">>"], 80, true, ["「"," 」"])
  writeFile("Map001.json", obj.pretty)

proc main(params: seq[string]) =
  var p = newParser(appName):
    option("-o", "--output", help="Output to this file")
    flag("-X", "--debug", help="Debug on")
    flag("-v", "--version", help="Print version info")
    arg("subcmd")
    arg("args", nargs = -1)
  
  var opts = p.parse(params)

  if opts.version:
    echo version
    return

  if opts.debug:
    newConsoleLogger(lvlAll, verboseFmtStr).addHandler()
  
  debug opts
  case opts.subcmd
  of "config": cmdConfig(opts)
  of "generate": cmdGenerate(opts)
  else: discard

when isMainModule:
  main(commandLineParams())