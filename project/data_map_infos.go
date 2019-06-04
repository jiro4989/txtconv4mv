package project

type MapInfos []struct {
	Expanded bool    `json:"expanded"`
	ID       int64   `json:"id"`
	Name     string  `json:"name"`
	Order    int64   `json:"order"`
	ParentID int64   `json:"parentId"`
	ScrollX  float64 `json:"scrollX"`
	ScrollY  float64 `json:"scrollY"`
}
