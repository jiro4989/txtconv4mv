import parsecsv

type
  Sentence* = ref SentenceObj
  SentenceObj* = object
    image*, actorName*, text*, background*, position*: string
  Sentences* = seq[Sentence]

proc readSentenceFile*(fn: string): Sentences =
  var parser: CsvParser
  parser.open(fn)
  parser.readHeaderRow()
  while parser.readRow():
    let r = parser.row
    var sentence = new Sentence
    sentence.image = r[0]
    sentence.actorName = r[1]
    sentence.text = r[2]
    sentence.background = r[3]
    sentence.position = r[4]
    result.add(sentence)
