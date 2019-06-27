import eastasianwidth

import parsecsv
from sequtils import mapIt
import strutils, unicode

type
  Sentence* = ref SentenceObj
  SentenceObj* = object
    image*, actorName*, text*, background*, position*: string
  Sentences* = seq[Sentence]

proc readSentenceFile*(fn: string): Sentences =
  ## 文章を書いたCSVファイルを読み取る。
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

proc wrapEAW1Line(s: string, width: int): seq[string] =
  ## 表示上の文字幅で折り返す。
  ## 1行の文字列のみを処理する。
  var line: string
  for c in s.toRunes:
    if width < (line & $c).stringWidth:
      result.add(line)
      line = ""
    line.add(c)
  if 0 < line.len:
    result.add(line)

proc wrapEAW(s: string, width: int, useJoin: bool): seq[string] =
  ## 表示上の文字幅で折り返す。
  var lastLine: string
  for line in s.split("\n"):
    let wrapped = (lastLine & line).wrapEAW1Line(width)
    if useJoin:
      if 2 <= wrapped.len:
        result.add(wrapped[0..^2])
        # 折り返しで発生した最後の行を次の折り返しの先頭に追加するため
        lastLine = wrapped[^1]
      else:
        result.add(wrapped)
        lastLine = ""
    else:
      result.add(wrapped)
  if 0 < lastLine.len:
    result.add(lastLine)

proc format*(sentence: Sentence, actorNameBrackets: array[2, string],
                     wrapWidth: int, useJoin: bool, textBrackets: array[2, string]
                     ): seq[string] =
  ## * ``actorNameBrackets`` はアクター名を囲う括弧。
  ## * ``wrapWidth`` が0以下のとき、折り返しを実行しない。
  ## * ``useJoin`` がtrueのとき、文字列を折り返したときに次の行を同じ行に連結す
  ##   る。
  ## * ``textBrackets`` はセリフの前後を囲う括弧。
  ## * ``indentBracketsWidth`` は ``brackets`` の高さにテキストの高さを揃えるか
  ##   否か。
  # events[].pages[].list
  #     code:101 actor name 0 0
  #     code:401 message (1line)
  #     code:401 message (1line)
  #     code:401 message (1line)
  #     code:101 actor name 0 0
  #     code:401 message (1line)
  #     code:401 message (1line)
  #     code:0 (eventの最後)
  if sentence.actorName != "":
    let actor = actorNameBrackets[0] & sentence.actorName & actorNameBrackets[1]
    result.add(actor)

  # テキスト全体を括弧でくくるときは、先頭の括弧の高さに全てのテキストを合わせる
  # よって、追加するインデント分折り返しの長さを引いてからwrapする
  let indentWidth = textBrackets[0].stringWidth
  var wraped = sentence.text.wrapEAW(wrapWidth - indentWidth, useJoin)

  # 括弧によるインデント追加
  if 0 < indentWidth:
    proc genI(w: int): string = " ".repeat(w)
    # 先頭に括弧を追加し、先頭以外の行の行頭にインデントを追加
    wraped = (textBrackets[0] & wraped[0]) & wraped[1..^1].mapIt(genI(indentWidth) & it)
    # 最後の行の行末に括弧とじを追加
    wraped[^1].add(textBrackets[1])
    # 括弧とじを追加したことで折り返し幅を超えているときのための修正
    if wrapWidth < wraped[^1].stringWidth:
      let w = wraped[^1].wrapEAW1Line(wrapWidth)
      wraped[^1] = w[0]
      wraped.add(genI(indentWidth) & w[1])
  result.add(wraped)