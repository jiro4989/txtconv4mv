import unittest

include txtconv4mv/project

suite "proc readMapInfos":
  test "Normal":
    echo readMapInfos("examples/MapInfos.json")

suite "proc getBiggestMapIndex":
  test "Normal":
    echo getBiggestMapIndex("examples")

suite "proc newMapObject":
  test "Normal":
    echo newMapObject(Sentences(@[Sentence(actorName: "test", text: "123456")]), ["<<", ">>"], 4, true, ["「"," 」"]).pretty