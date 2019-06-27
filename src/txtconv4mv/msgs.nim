import tables

const
  message* = {
    "ja": {
      "start": "これよりツールの設定を行います (Ctrl + Cで処理を中断)",
      "projectDir": "RPGツクールMVのゲームのプロジェクトフォルダを指定してください",
      "wrapWithBrackets": "文章を括弧で括りますか？ [y/n]",
      "whatsBrackets": "どの括弧を使用しますか？",
      "indents": "括弧でくくる際は高さを揃えますか？ [y/n]",
      "wordWrap": "入力のテキストが表示幅を超過する際は折り返しますか？ [y/n]",
      "width": "何文字で折り返しますか？ [デフォルト:NN]",
      "confirmConfig": "入力した設定を表示します",
      "finalConfirm": "以上の設定でよろしいですか？ [y/n]",
    }.toTable,
    "en": {
      "start": "これよりツールの設定を行います (Ctrl + Cで処理を中断)",
      "projectDir": "RPGツクールMVのゲームのプロジェクトフォルダを指定してください",
      "wrapWithBrackets": "文章を括弧で括りますか？",
      "whatsBrackets": "どの括弧を使用しますか？",
      "indents": "括弧でくくる際は高さを揃えますか？",
      "wordWrap": "入力のテキストが表示幅を超過する際は折り返しますか？",
      "charCount": "何文字で折り返しますか？ [デフォルト:NN]",
      "confirmConfig": "入力した設定を表示します",
      "finalConfirm": "以上の設定でよろしいですか？",
    }.toTable,
  }.toTable