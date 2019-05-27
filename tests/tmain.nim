import unittest
import txtconv4mv/textevent

suite "main":
  test "normal":
    var textevents = readTextEventFile("examples/text1.csv")
    for ev in textevents:
      echo ev[]
