const doc = """
txtconv4mv is a command to convert CSV to RPG Maker MV text data.

Usage:
  txtconv4mv [options] init
  txtconv4mv [options] convert <file>
  txtconv4mv (-h | --help)
  txtconv4mv (-v | --version)

Options:
  -h --help               Show this screen
  -v --version            Show version
"""

const
  version = "v1.0.0"

import docopt

when isMainModule:
  let args = docopt(doc, version = version)

when false:
  if args["crop"]:
    execCrop(args)
    quit 0

  if args["paste"]:
    execPaste(args)
    quit 0
  
  logErr "illegal options"
  stderr.writeLine doc
  quit 1