import unittest

include txtconv4mv/project

suite "proc newMapObject":
  test "Normal":
    echo newMapObject(Sentences(@[Sentence(actorName: "test", text: "123456")]), ["<<", ">>"], 4, true, ["「"," 」"]).pretty