import unittest
import json, tables

import txtconv4mv/rpgmakertype

proc toUgly*(result: var string, node: JsonNode) =
  ## Converts `node` to its JSON Representation, without
  ## regard for human readability. Meant to improve ``$`` string
  ## conversion performance.
  ##
  ## JSON representation is stored in the passed `result`
  ##
  ## This provides higher efficiency than the ``pretty`` procedure as it
  ## does **not** attempt to format the resulting JSON to make it human readable.
  var comma = false
  case node.kind:
  of JArray:
    result.add "["
    for child in node.elems:
      if comma: result.add ","
      else:     comma = true
      result.toUgly child
    result.add "]"
  of JObject:
    result.add "{"
    for key, value in pairs(node.fields):
      if comma: result.add ","
      else:     comma = true
      key.escapeJson(result)
      result.add ":"
      result.toUgly value
    result.add "}"
  of JString:
    node.str.escapeJson(result)
  of JInt:
    when defined(js): result.add($node.num)
    else: result.add(node.num)
  of JFloat:
    when defined(js): result.add($node.fnum)
    else: result.add(node.fnum)
  of JBool:
    result.add(if node.bval: "true" else: "false")
  of JNull:
    result.add "null"

proc json2struct*(result: var string, node: JsonNode, pad = "  ") =
  ## Converts `node` to its JSON Representation, without
  ## regard for human readability. Meant to improve ``$`` string
  ## conversion performance.
  ##
  ## JSON representation is stored in the passed `result`
  ##
  ## This provides higher efficiency than the ``pretty`` procedure as it
  ## does **not** attempt to format the resulting JSON to make it human readable.
  var comma = false
  case node.kind:
  of JArray:
    result.add("seq[")
    result.add case node.elems[0].kind
    of JArray: "array"
    of JObject: "object"
    of JString: "string"
    of JFloat: "float"
    of JInt: "int"
    of JBool: "bool"
    of JNull: "Null"
    
    when false:
      for key, value in pairs(node.fields):
        result.add case value.kind
                  of JArray:
                    result.json2struct(value, pad)
                    result
                  of JObject: "object"
                  of JString: "string"
                  of JFloat: "float"
                  of JInt: "int"
                  of JBool: "bool"
                  of JNull: "Null"
        break
    result.add("]")
    result.add "\n"
  of JObject:
    result.add "type obj = object\n"
    for key, value in pairs(node.fields):
      result.add pad
      result.add key
      result.add ": "
      result.json2struct(value, pad & "  ")
  of JString:
    result.add("string")
    result.add "\n"
  of JInt:
    result.add("int")
    result.add "\n"
  of JFloat:
    result.add("float")
    result.add "\n"
  of JBool:
    result.add "bool"
    result.add "\n"
  of JNull:
    result.add "Any"
    result.add "\n"

suite "JSON":
  test "Nest 1":
    var s: string
    s.json2struct(parseJson("""{"data":"data", "int":1, "float":1.2, "bool":true, "array":[1, 2, 3], "null":null}"""))
    echo s
  test "Nest 2":
    var s: string
    s.json2struct(parseJson("""{"number":1, "object":{"s":"string", "i":1, "b":true}, "array":[{"str":"s", "int":1}]}"""))
    echo s

suite "ReadJson":
  test "sample":
    var data = parseFile("examples/Map001.json").to(MapData)
    echo data