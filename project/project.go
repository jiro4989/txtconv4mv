package project

import (
	"io/ioutil"
	"regexp"

	"github.com/jiro4989/txtconv4mv/config"
	"github.com/jiro4989/txtconv4mv/sentence"
)

var mapJsonRe = regexp.MustCompile(`Map\d+\.json`)

func GetBiggestMapIndex(dataDir string) (int, error) {
	files, err := ioutil.ReadDir(dataDir)
	if err != nil {
		return -1, err
	}

	// MapXXX.jsonにマッチするファイルの件数を算出
	var matchedCount int
	for _, file := range files {
		if mapJsonRe.MatchString(file.Name()) {
			matchedCount++
		}
	}

	return matchedCount, nil
}

func WriteMapJSONFile(fn string, ss sentence.Sentences, conf config.Config) error {
	return nil
}
