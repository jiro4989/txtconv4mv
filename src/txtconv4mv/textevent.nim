import parsecsv
from strutils import split

type
  TextEventObj* = object
    image*, actor*, background*, position*: string
    text*: seq[string]
  TextEvent* = ref TextEventObj

proc validate*(self: TextEvent) =
  discard

proc readTextEventFile*(filename: string): seq[TextEvent] =
  var parser: CsvParser
  parser.open(filename)

  parser.readHeaderRow
  while parser.readRow:
    var textEvent = new TextEvent
    textEvent.image      = parser.row[0]
    textEvent.actor      = parser.row[1]
    textEvent.text       = parser.row[2].split("\n")
    textEvent.background = parser.row[3]
    textEvent.position   = parser.row[4]
    result.add textEvent

proc format*(self: TextEvent, brackets = ["", ""],
                            indents = "",
                            wrapWordWidth = -1): seq[string] =
  discard
