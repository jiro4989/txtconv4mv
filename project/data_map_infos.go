package project

type (
	DataMapInfo struct {
		Expanded bool    `json:"expanded"`
		ID       int     `json:"id"`
		Name     string  `json:"name"`
		Order    int     `json:"order"`
		ParentID int     `json:"parentId"`
		ScrollX  float64 `json:"scrollX"`
		ScrollY  float64 `json:"scrollY"`
	}
	DataMapInfos []*DataMapInfo
)

func (mi DataMapInfos) Add(m *DataMapInfo) {
	mi = append(mi, m)
}
