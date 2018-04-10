package main

import (
	"fmt"
	"os"
	"os/exec"
	"strings"

	log "github.com/sirupsen/logrus"
	"github.com/urfave/cli"
)

func main() {
	app := cli.NewApp()

	cli.AppHelpTemplate = appHelpTemplate
	cli.CommandHelpTemplate = commandHelpTemplate
	app.Name = "Exekube"
	app.Version = "0.3.0"
	app.Usage = "Manage the whole lifecycle of Kubernetes-based projects as declarative code"
	app.Authors = []cli.Author{
		cli.Author{
			Name:  "Ilya Sotkov",
			Email: "ilya@sotkov.com",
		},
	}

	app.Action = func(c *cli.Context) error {
		args := c.Args().Tail()
		cmd := exec.Command(c.Args().First(), args...)
		cmd.Stdout = os.Stdout
		cmd.Stdin = os.Stdin
		cmd.Stderr = os.Stderr
		err := cmd.Run()
		if err != nil {
			return err
		}
		return nil
	}

	app.Commands = []cli.Command{
		{
			Name:    "up",
			Aliases: []string{"apply"},
			Usage:   "Apply all modules in a path",
			Action: func(c *cli.Context) error {
				err := runTerragruntCmd(c)
				if err != nil {
					return err
				}
				return nil
			},
		},
		{
			Name:    "down",
			Aliases: []string{"destroy"},
			Usage:   "Destroy all modules in a path (forces count of all resources to zero)",
			Action: func(c *cli.Context) error {
				err := runTerragruntCmd(c)
				if err != nil {
					return err
				}
				return nil
			},
		},
		{
			Name:    "plan",
			Aliases: []string{},
			Usage:   "Plan all modules in a path",
			Action: func(c *cli.Context) error {
				err := runTerragruntCmd(c)
				if err != nil {
					return err
				}
				return nil
			},
		},
		{
			Name:    "output",
			Aliases: []string{},
			Usage:   "Show output variables for all modules in a path",
			Action: func(c *cli.Context) error {
				err := runTerragruntCmd(c)
				if err != nil {
					return err
				}
				return nil
			},
		},
	}

	err := app.Run(os.Args)
	if err != nil {
		log.Fatal(err)
	}
}

func runTerragruntCmd(c *cli.Context) error {
	// If two args or more
	if c.NArg() > 1 {
		return fmt.Errorf("Too many arguments for \"%s\" command", c.Command.Name)
	}

	// If zero args
	dir := mustGetenv("TF_VAR_default_dir")

	// Overwrite if exactly 1 arg
	if c.NArg() == 1 {
		dir = c.Args().First()
	}

	action := c.Command.Name

	if c.Command.Name == "up" {
		action = "apply"
	}

	if c.Command.Name == "down" {
		action = "destroy"
	}

	terragruntCmd := strings.Join([]string{action, "-all"}, "")

	cmd := exec.Command("terragrunt", terragruntCmd)
	cmd.Dir = dir
	cmd.Stdout = os.Stdout
	cmd.Stdin = os.Stdin
	cmd.Stderr = os.Stderr

	err := cmd.Run()
	if err != nil {
		return err
	}

	return nil
}

func mustGetenv(k string) string {
	v := os.Getenv(k)
	if v == "" {
		log.Fatalf("%s environment variable not set.", k)
	}
	return v
}
