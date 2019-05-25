const doc = """
txtconv4mv is a command to convert CSV to RPG Maker MV text data.

Usage:
  txtconv4mv [options] config
  txtconv4mv [options] convert <file>
  txtconv4mv (-h | --help)
  txtconv4mv (-v | --version)

Options:
  -h --help                 Show this screen
  -v --version              Show version
  -X --debug                Debug mode ON
  -L --lang <language>      Message language [default: ja]
  -c --config-file <file>   Config file
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

proc execConfig(args: Table[string, Value]) =
  debug "call `execConfig`, args = ", args
  let
    lang = $args["--lang"]
    msg = message[lang]
  debug "msg = ", msg

  var conf: Config
  echo msg["start"]
  echo msg["projectDir"]
  stdout.write "> "
  conf.projectDir = stdin.readLine

  echo msg["wrapWithBrackets"]
  stdout.write "> "
  case stdin.readLine.toLowerAscii
  of "y": conf.wrapWithBrackets = true
  of "n": conf.wrapWithBrackets = false
  else: assert false, "NG TODO"

  if conf.wrapWithBrackets:
    echo msg["whatsBrackets"]
    stdout.write "> "
    # TODO

  echo msg["indents"]
  stdout.write "> "
  case stdin.readLine.toLowerAscii
  of "y": conf.indents = true
  of "n": conf.indents = false
  else: assert false, "NG TODO"

  echo msg["wordWrap"]
  stdout.write "> "
  case stdin.readLine.toLowerAscii
  of "y": conf.wordWrap = true
  of "n": conf.wordWrap = false
  else: assert false, "NG TODO"

  echo msg["charCount"]
  stdout.write "> "
  conf.charCount = stdin.readLine.parseInt

  echo msg["confirmConfig"]
  stdout.write "> "
  echo conf

  echo msg["finalConfirm"]
  stdout.write "> "
  case stdin.readLine.toLowerAscii
  of "y":
    echo "Generate"
  of "n": return
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

  if args["config"]:
    execConfig(args)
    quit 0

  if args["convert"]:
    execConvert(args)
    quit 0
  
  stderr.writeLine doc
  quit 1
  