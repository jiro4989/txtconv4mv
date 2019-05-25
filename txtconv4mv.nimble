# Package

version       = "0.1.0"
author        = "jiro4989"
description   = "Command to convert text to RPG Maker MV text data."
license       = "MIT"
srcDir        = "src"
binDir        = "bin"
bin           = @["txtconv4mv"]


# Dependencies

requires "nim >= 0.19.4"

import strformat

task docs, "Generate documents":
  discard
  # exec "nimble doc src/rect.nim -o:docs/rect.html"
  # for m in ["classifiedstring", "crop", "paste", "util"]:
  #   exec &"nimble doc src/rect/{m}.nim -o:docs/{m}.html"

task ci, "Run CI":
  exec "nim -v"
  exec "nimble -v"
  exec "nimble install -Y"
  exec "nimble test -Y"
  exec "nimble docs -Y"
  exec "nimble build -d:release -Y"
  exec "./bin/txtconv4mv -h"
  exec "./bin/txtconv4mv -v"
