package main

var commandHelpTemplate = `NAME:
   {{.HelpName}} - {{.Usage}}
USAGE:
   {{if .UsageText}}{{.UsageText}}{{else}}{{.HelpName}}{{if .VisibleFlags}} [command options]{{end}} [path]{{end}}{{if .Category}}
CATEGORY:
   {{.Category}}{{end}}{{if .Description}}
DESCRIPTION:
   {{.Description}}{{end}}{{if .VisibleFlags}}
OPTIONS:
   {{range .VisibleFlags}}{{.}}
   {{end}}{{end}}
`

var appHelpTemplate = `NAME:
{{.Name}} - {{.Usage}}
USAGE:
{{.HelpName}} {{if .VisibleFlags}}[global options]{{end}}{{if .Commands}} command {{end}}[path]
{{if len .Authors}}
AUTHOR:
{{range .Authors}}{{ . }}{{end}}
{{end}}{{if .Commands}}
COMMANDS:
{{range .Commands}}{{if not .HideHelp}}   {{join .Names ", "}}{{ "\t"}}{{.Usage}}{{ "\n" }}{{end}}{{end}}{{end}}{{if .VisibleFlags}}
GLOBAL OPTIONS:
{{range .VisibleFlags}}{{.}}
{{end}}{{end}}{{if .Copyright }}
COPYRIGHT:
{{.Copyright}}
{{end}}{{if .Version}}
VERSION:
{{.Version}}
{{end}}
`
