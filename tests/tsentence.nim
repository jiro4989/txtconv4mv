import unittest

include txtconv4mv/sentence

suite "proc readSentenceFile":
  test "Normal":
    discard

suite "proc wrapEAW1Line":
  test "Empty str":
    var empty: seq[string]
    check "".wrapEAW1Line(6) == empty
  test "Hankaku":
    check "123456".wrapEAW1Line(6) == @["123456"]
    check "1234567".wrapEAW1Line(6) == @["123456", "7"]
  test "Zenkaku":
    check "あいう".wrapEAW1Line(6) == @["あいう"]
    check "あいう7".wrapEAW1Line(6) == @["あいう", "7"]
  test "Combined":
    check "12345あ".wrapEAW1Line(6) == @["12345", "あ"]

suite "proc wrapEAW":
  test "Empty str":
    var empty: seq[string]
    check "".wrapEAW(6, false) == empty
  test "Hankaku 1 line, useJoin=false":
    check "123456".wrapEAW(6, false) == @["123456"]
    check "1234567".wrapEAW(6, false) == @["123456", "7"]
  test "Hankaku 2 line, useJoin=false":
    check "123456\nabcdef".wrapEAW(6, false) == @["123456", "abcdef"]
    check "1234567\nabcdef".wrapEAW(6, false) == @["123456", "7", "abcdef"]
    check "1234567\nabcdefg".wrapEAW(6, false) == @["123456", "7", "abcdef", "g"]
  test "Hankaku 2 line, useJoin=true":
    check "123456\nabcdef".wrapEAW(6, true) == @["123456", "abcdef"]
    check "1234567\nabcdef".wrapEAW(6, true) == @["123456", "7abcde", "f"]
    check "1234567\nabcdefg".wrapEAW(6, true) == @["123456", "7abcde", "fg"]
  test "Zenkaku 1 line, useJoin=false":
    check "あいう".wrapEAW(6, false) == @["あいう"]
    check "あいうえ".wrapEAW(6, false) == @["あいう", "え"]
  test "Zenkaku 2 line, useJoin=false":
    check "あいう\nさしす".wrapEAW(6, false) == @["あいう", "さしす"]
    check "あいうえ\nさしす".wrapEAW(6, false) == @["あいう", "え", "さしす"]
    check "あいうえ\nさしすせ".wrapEAW(6, false) == @["あいう", "え", "さしす", "せ"]
  test "Zenkaku 2 line, useJoin=true":
    check "あいう\nさしす".wrapEAW(6, true) == @["あいう", "さしす"]
    check "あいうえ\nさしす".wrapEAW(6, true) == @["あいう", "えさし", "す"]
    check "あいうえ\nさしすせ".wrapEAW(6, true) == @["あいう", "えさし", "すせ"]

suite "proc format":
  test "Empty str":
    var empty: seq[string]
    check Sentence(actorName: "", text: "")
          .format(["", ""], 6, false, ["", ""]) == empty
  test "Option none":
    check Sentence(actorName: "", text: "123456")
          .format(["", ""], 6, false, ["", ""]) == @["123456"]
  test "Actor":
    check Sentence(actorName: "Test", text: "123456")
          .format(["", ""], 6, false, ["", ""]) == @["Test", "123456"]
  test "Actor, actorBrackets":
    check Sentence(actorName: "Test", text: "123456")
          .format(["[", "]"], 6, false, ["", ""]) == @["[Test]", "123456"]
  test "Actor, actorBrackets, wrap":
    check Sentence(actorName: "Test", text: "1234567")
          .format(["[", "]"], 6, false, ["", ""]) == @["[Test]", "123456", "7"]
  test "Actor, actorBrackets, wrap, useJoin":
    check Sentence(actorName: "Test", text: "1234567")
          .format(["[", "]"], 6, true, ["", ""]) == @["[Test]", "123456", "7"]
    check Sentence(actorName: "Test", text: "1234567\nabcdef")
          .format(["[", "]"], 6, true, ["", ""]) == @["[Test]", "123456", "7abcde", "f"]
  test "Actor, actorBrackets, wrap, useJoin, textBrackets":
    check Sentence(actorName: "Test", text: "1234567\nabcdef")
          .format(["[", "]"], 6, true, ["<", ">"]) == @["[Test]", "<12345", " 67abc", " def>"]
    check Sentence(actorName: "Test", text: "1234567\nabcdef")
          .format(["[", "]"], 6, true, ["「", "」"]) == @["[Test]", "「1234", "  567a", "  bcde", "[Test]", "  f」"]
  test "Actor, actorBrackets, wrap, useJoin, textBrackets, lastWrap":
    check Sentence(actorName: "Test", text: "1234567\nabcde")
          .format(["[", "]"], 6, true, ["「", "」"]) == @["[Test]", "「1234", "  567a", "  bcde", "[Test]", "  」"]
  test "No actor":
    check Sentence(actorName: "", text: "1234567\nabcde")
          .format(["[", "]"], 6, true, ["「", "」"]) == @["「1234", "  567a", "  bcde", "  」"]
    check Sentence(actorName: "", text: "1234567\nabcde\nABCD")
          .format(["[", "]"], 6, true, ["「", "」"]) == @["「1234", "  567a", "  bcde", "  ABCD", "  」"]