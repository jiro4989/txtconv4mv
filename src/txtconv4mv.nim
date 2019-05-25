const doc = """
txtconv4mv is a command to convert CSV to RPG Maker MV text data.

Usage:
  txtconv4mv [options] init
  txtconv4mv [options] config
  txtconv4mv [options] convert <file>
  txtconv4mv (-h | --help)
  txtconv4mv (-v | --version)

Commands:
  init       Setup application
  config     Generate converting config
  convert    Convert text to RPG Maker MV text data

Options:
  -h --help                  Show this screen
  -v --version               Show version
  -X --debug                 Debug mode ON
  -L --lang <language>       Message language [default: ja]
  -c --config-file <file>    Config file
"""

import docopt
import txtconv4mv/[message]
import logging
from strutils import toLowerAscii, parseInt

type
  Config* = object
    projectDir*: string
    wrapWithBrackets*: bool
    whatsBrackets*: array[2, string]
    indents*: bool
    wordWrap*: bool
    charCount*: int

const
  version = "v1.0.0"

proc execInit(args: Table[string, Value]) =
  const brackets = @[
    ["[", "]"],
    ["(", ")"],
  ]
  echo brackets

template printInputPrompt(msg: string, body: untyped) =
  echo msg
  stdout.write "> "
  body
  echo ""

proc setFromYNInput(b: var bool) =
  case stdin.readLine.toLowerAscii
  of "y": b = true
  of "n": b = false
  else: assert false, "NG TODO"

proc execConfig(args: Table[string, Value]) =
  debug "call `execConfig`, args = ", args
  let
    lang = $args["--lang"]
    msg = message[lang]
  debug "msg = ", msg

  var conf: Config
  printInputPrompt msg["start"]:
    discard

  printInputPrompt msg["projectDir"]:
    conf.projectDir = stdin.readLine

  printInputPrompt msg["wrapWithBrackets"]:
    setFromYNInput conf.wrapWithBrackets

  if conf.wrapWithBrackets:
    printInputPrompt msg["whatsBrackets"]:
      echo ""
      # TODO

  printInputPrompt msg["indents"]:
    setFromYNInput conf.indents

  printInputPrompt msg["wordWrap"]:
    setFromYNInput conf.wordWrap

  printInputPrompt msg["charCount"]:
    conf.charCount = stdin.readLine.parseInt

  printInputPrompt msg["confirmConfig"]:
    echo conf

  printInputPrompt msg["finalConfirm"]:
    case stdin.readLine.toLowerAscii
    of "y":
      echo "Generate"
    of "n":
      echo "Not generate"
    else: assert false, "NG TODO"

proc execConvert(args: Table[string, Value]) =
  debug "call `execConvert`, args = ", args
  discard

when isMainModule:
  let args = docopt(doc, version = version)
  if args["--debug"]:
    var logger = newConsoleLogger(lvlAll, verboseFmtStr)
    addHandler(logger)
  
  debug "args = ", args

  if args["init"]:
    execInit(args)
    quit 0

  if args["config"]:
    execConfig(args)
    quit 0

  if args["convert"]:
    execConvert(args)
    quit 0
  
  stderr.writeLine doc
  quit 1
  