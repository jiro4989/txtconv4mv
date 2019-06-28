import tables

const
  message* = {
    "ja": {
      "start": "これよりツールの設定を行います。 (Ctrl + Cで処理を中断)",
      "projectDir": "RPGツクールMVのゲームのプロジェクトフォルダを指定してください。",
      "wrapActorWithBrackets": "アクター名をを括弧で括りますか？ [y/n]",
      "startBracket": "開きの括弧を入力してください。",
      "endBracket": "閉じの括弧を入力してください。",
      "wrapTextWithBrackets": "文章を括弧で括りますか？ [y/n]",
      "wrapWord": "入力のテキストが表示幅を超過する際は折り返しますか？ [y/n]",
      "width": "何文字で折り返しますか？ [デフォルト:55]",
      "useJoin": "折り返した文章を次の行と結合しますか？[y/n]",
      "confirmConfig": "入力した設定を表示します。",
      "finalConfirm": "以上の設定でよろしいですか？ [y/n]",
      "complete": "設定ファイルの生成を正常に完了しました。",
      "interruption": "設定ファイルの生成を中断しました。",
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