type
  CSVData* = object
    image*, actor*, text*, background*, position*: string

proc validate*(csv: CSVData) =
  discard

proc readCSV*(path: string): seq[CSVData] =
  discard
