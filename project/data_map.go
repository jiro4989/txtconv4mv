package project

type DataMap struct {
	AutoplayBgm     bool   `json:"autoplayBgm"`
	AutoplayBgs     bool   `json:"autoplayBgs"`
	Battleback1Name string `json:"battleback1Name"`
	Battleback2Name string `json:"battleback2Name"`
	Bgm             struct {
		Name   string `json:"name"`
		Pan    int64  `json:"pan"`
		Pitch  int64  `json:"pitch"`
		Volume int64  `json:"volume"`
	} `json:"bgm"`
	Bgs struct {
		Name   string `json:"name"`
		Pan    int64  `json:"pan"`
		Pitch  int64  `json:"pitch"`
		Volume int64  `json:"volume"`
	} `json:"bgs"`
	Data              []int64       `json:"data"`
	DisableDashing    bool          `json:"disableDashing"`
	DisplayName       string        `json:"displayName"`
	EncounterList     []interface{} `json:"encounterList"`
	EncounterStep     int64         `json:"encounterStep"`
	Events            []interface{} `json:"events"`
	Height            int64         `json:"height"`
	Note              string        `json:"note"`
	ParallaxLoopX     bool          `json:"parallaxLoopX"`
	ParallaxLoopY     bool          `json:"parallaxLoopY"`
	ParallaxName      string        `json:"parallaxName"`
	ParallaxShow      bool          `json:"parallaxShow"`
	ParallaxSx        int64         `json:"parallaxSx"`
	ParallaxSy        int64         `json:"parallaxSy"`
	ScrollType        int64         `json:"scrollType"`
	SpecifyBattleback bool          `json:"specifyBattleback"`
	TilesetID         int64         `json:"tilesetId"`
	Width             int64         `json:"width"`
}
