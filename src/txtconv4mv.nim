# This is just an example to get you started. A typical binary package
# uses this file as the main entry point of the application.

import txtconv4mv/[sentence, project]
import json

when isMainModule:
  echo("Hello, World!")
  let ss = readSentenceFile("examples/text1.csv")
  let obj = newMapObject(ss, ["<<", ">>"], 80, true, ["「"," 」"])
  writeFile("Map001.json", obj.pretty)
