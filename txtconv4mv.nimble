# Package

version       = "0.1.0"
author        = "jiro4989"
description   = "A new awesome nimble package"
license       = "MIT"
srcDir        = "src"
bin           = @["txtconv4mv"]
binDir        = "bin"

import strformat

# Dependencies

requires "nim >= 0.20.0"
requires "eastasianwidth >= 1.1.0"
requires "argparse >= 0.7.1"

task ci, "Run CI":
  exec "nimble test -Y"
  exec "nimble build -Y"
  let appName = bin[0]
  exec &"./bin/{appName} -h"
  exec &"./bin/{appName} version"