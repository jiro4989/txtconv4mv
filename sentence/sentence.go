package sentence

import (
	"encoding/csv"
	"io"
	"os"

	"golang.org/x/text/encoding/japanese"
	"golang.org/x/text/transform"
)

type (
	Background int
	Position   int
	Sentence   struct {
		Image      string
		ActorName  string
		Text       string
		Background Background
		Position   Position
	}
	Sentences []Sentence
)

const (
	BackgroundWindow Background = iota
	PositionTop      Position   = iota
	PositionCenter
	PositionBottom
)

func ReadFile(fn string) (Sentences, error) {
	f, err := os.Open(fn)
	if err != nil {
		return nil, err
	}
	defer f.Close()

	var sentences Sentences
	reader := csv.NewReader(transform.NewReader(f, japanese.ShiftJIS.NewDecoder()))
	for {
		record, err := reader.Read() // 1行読み出す
		if err == io.EOF {
			break
		} else if err != nil {
			return nil, err
		}

		// 1行読み取ったレコードをカラム順に取得
		// カラム数が不足していたときのための対策でforを使用
		var sentenceData Sentence
		for i, v := range record {
			switch i {
			case 0:
				sentenceData.Image = v
			case 1:
				sentenceData.ActorName = v
			case 2:
				sentenceData.Text = v
			case 3:
				// TODO
				sentenceData.Background = BackgroundWindow
			case 4:
				// TODO
				sentenceData.Position = PositionTop
			}
		}
		sentences = append(sentences, sentenceData)
	}
	return sentences, nil
}
