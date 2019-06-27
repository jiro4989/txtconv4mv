# Package

version       = "0.1.0"
author        = "jiro4989"
description   = "A new awesome nimble package"
license       = "MIT"
srcDir        = "src"
bin           = @["txtconv4mv"]
binDir        = "bin"



# Dependencies

requires "nim >= 0.20.0"

task ci, "Run CI":
  exec "nimble test"
  exec "nimble build"