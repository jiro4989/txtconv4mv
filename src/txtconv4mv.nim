const doc = """
txtconv4mv is a command to convert CSV to RPG Maker MV text data.

Usage:
  txtconv4mv [options] config
  txtconv4mv [options] convert <file>
  txtconv4mv (-h | --help)
  txtconv4mv (-v | --version)

Options:
  -h --help              Show this screen
  -v --version           Show version
  -X --debug             Debug mode ON
  -L --lang <language>   Message language [default: ja]
"""

import docopt
import txtconv4mv/[message]
import logging

const
  version = "v1.0.0"

proc execConfig(args: Table[string, Value]) =
  debug "call `execConfig`, args = ", args
  let
    lang = $args["--lang"]
    msg = message[lang]
  debug "msg = ", msg
  echo msg["start"]

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
  