package main

import "os"

func main() {
	// 妄想レベルでこんなふうな処理ロジックにしたい案
	args := os.Args
	textFilePath := args[0]
	textData := readText(textFilePath)
	convertConfigFilePath := args[1]
	convertConfig := readConfig(convertConfigFilePath)

	if err := convert(textData, convertConfig); err != nil {
		panic(err)
	}

	// if err := RootCommand.Execute(); err != nil {
	// 	fmt.Fprintln(os.Stderr, err)
	// 	os.Exit(-1)
	// }
}

func convert(textData *TextData, config *Config) error {
	// MapXXX.jsonの更新
	mapFiles := getMapJSONFiles()
	mapIdx := getBiggestIndex(mapFiles)
	mapFileName := config.projectRoot + "/data/Map%03d.json"
	if err := writeMapJSONFile(textData, mapFileName); err != nil {
		return err
	}

	// MapInfo.jsonの更新
	mapInfoFileName := config.ProjectRoot + "/data/MapInfo.json"
	if err := addMapInfoJSONFile(mapInfoFileName, mapFileName); err != nil {
		return err
	}

	return nil
}
