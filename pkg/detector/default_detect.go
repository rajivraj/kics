package detector

import (
	"strconv"
	"strings"

	"github.com/Checkmarx/kics/pkg/model"
	"github.com/rs/zerolog"
)

const (
	UndetectedVulnerabilityLine = -1
)

type defaultDetectLine struct {
}

func (d defaultDetectLine) DetectLine(file *model.FileMetadata, searchKey string,
	logWithFields *zerolog.Logger, outputLines int) model.VulnerabilityLines {
	text := strings.ReplaceAll(file.OriginalData, "\r", "")
	lines := strings.Split(text, "\n")
	foundAtLeastOne := false
	currentLine := 0
	isBreak := false
	var extractedString [][]string
	extractedString = GetBracketValues(searchKey, extractedString, "")
	sanitizedSubstring := searchKey
	for idx, str := range extractedString {
		sanitizedSubstring = strings.Replace(sanitizedSubstring, str[0], `{{`+strconv.Itoa(idx)+`}}`, -1)
	}

	for _, key := range strings.Split(sanitizedSubstring, ".") {
		substr1, substr2 := GenerateSubstrings(key, extractedString)

		foundAtLeastOne, currentLine, isBreak = DetectCurrentLine(lines, substr1, substr2, currentLine, foundAtLeastOne)

		if isBreak {
			break
		}
	}

	if foundAtLeastOne {
		return model.VulnerabilityLines{
			Line:     currentLine + 1,
			VulnLine: GetAdjacentLines(currentLine, outputLines, lines),
		}
	}

	logWithFields.Warn().Msgf("failed to detect line, query response %s", searchKey)

	return model.VulnerabilityLines{
		Line:     UndetectedVulnerabilityLine,
		VulnLine: model.VulnLines{},
	}
}
