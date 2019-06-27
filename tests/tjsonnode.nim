import unittest
import json

suite "複数の型が混在する配列を扱うテスト":
  test "Read":
    let obj = parseFile("tests/1.json")
    echo obj
  test "Write":
    var obj = parseFile("tests/1.json")
    echo obj["b"]
    echo obj["b"]["b"]
    # 配列内に異なる型が存在する場合
    echo obj["b"]["b"].elems
    for elem in obj["b"]["b"].elems:
      echo elem
    echo "-----------------"
    # 配列内の特定の要素だけ書き換える
    obj["b"]["b"].elems[0] = newJBool(false)
    for elem in obj["b"]["b"].elems:
      echo elem