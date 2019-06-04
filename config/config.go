package config

import (
	"encoding/json"
	"io/ioutil"
)

type (
	Config struct {
		ProjectRoot      string
		WrapWithBrackets bool
		Brackets         [2]string
		UseIndent        bool
		UseWordWrap      bool
		WrapLength       int
	}
)

func ReadConfigFile(fn string) (Config, error) {
	data, err := ioutil.ReadFile(fn)
	if err != nil {
		return Config{}, nil
	}

	var conf Config
	err = json.Unmarshal(data, &conf)
	return conf, err
}
