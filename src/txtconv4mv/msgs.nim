import tables

const
  message* = {
    "ja": {
      "start": "これよりツールの設定を行います。 (Ctrl + Cで処理を中断)",
      "projectDir": "RPGツクールMVのゲームのプロジェクトフォルダを指定してください。",
      "wrapActorWithBrackets": "アクター名を括弧で括りますか？ [y/n]",
      "startBracket": "開きの括弧を入力してください。",
      "endBracket": "閉じの括弧を入力してください。",
      "wrapTextWithBrackets": "文章を括弧で括りますか？ [y/n]",
      "wrapWord": "入力のテキストが表示幅を超過する際は折り返しますか？ [y/n]",
      "width": "折り返す幅を入力してください。 [デフォルト:55]",
      "useJoin": "折り返した文章を次の行と結合しますか？[y/n]",
      "confirmConfig": "入力した設定を表示します。",
      "finalConfirm": "以上の設定でよろしいですか？ [y/n]",
      "complete": "設定ファイルの生成を正常に完了しました。",
      "interruption": "設定ファイルの生成を中断しました。",
    }.toTable,
    "en": {
      "start": "Start setting of generating data. (Interrupt with Ctrl + C)",
      "projectDir": "Set a folder of a project of the RPG Maker MV.",
      "wrapActorWithBrackets": "Do wrap a actor name with brackets? [y/n]",
      "startBracket": "Set a opened brackets.",
      "endBracket": "Set a closed brackets.",
      "wrapTextWithBrackets": "Do wrap a text with brackets? [y/n]",
      "wrapWord": "入力のテキストが表示幅を超過する際は折り返しますか？ [y/n]",
      "width": "Set a wrap width. [デフォルト:55]",
      "useJoin": "Do join a new line and next line? [y/n]",
      "confirmConfig": "Print settings that you set.",
      "finalConfirm": "Do apply these settings? [y/n]",
      "complete": "Completed generating a setting.",
      "interruption": "Interrupted generating a setting.",
    }.toTable,
  }.toTable