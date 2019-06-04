package main

import (
	"fmt"
	"os"

	"github.com/jiro4989/txtconv4mv/config"
	"github.com/jiro4989/txtconv4mv/project"
	"github.com/jiro4989/txtconv4mv/sentence"
)

func main() {
	// 妄想レベルでこんなふうな処理ロジックにしたい案
	args := os.Args
	textFilePath := args[0]
	textData, err := sentence.ReadFile(textFilePath)
	if err != nil {
		panic(err)
	}

	convertConfigFilePath := args[1]
	convertConfig, err := config.ReadConfigFile(convertConfigFilePath)
	if err != nil {
		panic(err)
	}

	if err := convert(textData, convertConfig); err != nil {
		panic(err)
	}

	// if err := RootCommand.Execute(); err != nil {
	// 	fmt.Fprintln(os.Stderr, err)
	// 	os.Exit(-1)
	// }
}

func convert(sentences sentence.Sentences, conf config.Config) error {
	dataDir := conf.ProjectRoot + "/data"

	// 新たに生成するファイルのファイル名を決定するためのインデックスの取得
	mapIndex, err := project.GetBiggestMapIndex(dataDir)
	if err != nil {
		return err
	}
	mapIndex++ // 次に生成するファイル名のインデクスは1加算されていないといけない
	// ファイルの生成
	mapFileName := fmt.Sprintf(dataDir+"/Map%03d.json", mapIndex)
	if err := project.WriteMapJSONFile(mapFileName, sentences, conf); err != nil {
		return err
	}

	// 更新するMapInfos.jsonの取得
	mapInfoFileName := dataDir + "/MapInfo.json"
	dataMapInfos, err := project.ReadDataMapInfosFile(mapInfoFileName)
	if err != nil {
		return err
	}

	// MapInfos.jsonの更新
	m := project.DataMapInfo{
		ID:       mapIndex,
		Expanded: false,
		Name:     "txtconv4mv",
		Order:    mapIndex, // TODO ???
		ParentID: 1,        // TODO ???
		ScrollX:  300.5,    // TODO
		ScrollY:  300.5,    // TODO
	}
	dataMapInfos.Add(&m)
	if err := project.WriteMapInfosFile(mapInfoFileName, dataMapInfos); err != nil {
		return err
	}

	return nil
}
