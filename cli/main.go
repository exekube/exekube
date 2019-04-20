package main

import (
	"fmt"
	"os"
	"os/exec"

	log "github.com/sirupsen/logrus"
	"github.com/urfave/cli"
)

func main() {
	app := cli.NewApp()

	cli.AppHelpTemplate = appHelpTemplate
	cli.CommandHelpTemplate = commandHelpTemplate
	app.Name = "Exekube"
	app.Version = "0.5.0"
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
			Name:    "apply",
			Aliases: []string{},
			Usage:   "Apply a module in a path",
			Action: func(c *cli.Context) error {
				err := runTerragruntCmd(c)
				if err != nil {
					return err
				}
				return nil
			},
		},
		{
			Name:    "apply-all",
			Aliases: []string{"up"},
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
			Name:    "destroy",
			Aliases: []string{},
			Usage:   "Destroy a module in a path",
			Action: func(c *cli.Context) error {
				err := runTerragruntCmd(c)
				if err != nil {
					return err
				}
				return nil
			},
		},
		{
			Name:    "destroy-all",
			Aliases: []string{"down"},
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
			Usage:   "Plan a module in a path",
			Action: func(c *cli.Context) error {
				err := runTerragruntCmd(c)
				if err != nil {
					return err
				}
				return nil
			},
		},
		{
			Name:    "plan-all",
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
			Usage:   "Show output variables for a module in a path",
			Action: func(c *cli.Context) error {
				err := runTerragruntCmd(c)
				if err != nil {
					return err
				}
				return nil
			},
		},
		{
			Name:    "output-all",
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
	// If two args or more, exit with error
	if c.NArg() > 1 {
		return fmt.Errorf("Too many arguments for \"%s\" command", c.Command.Name)
	}

	// If zero or one args, set to env var
	dir := mustGetenv("TF_VAR_default_dir")

	// Overwrite if exactly 1 arg
	if c.NArg() == 1 {
		dir = c.Args().First()
	}

	terragruntAction := c.Command.Name

	if c.Command.Name == "up" {
		terragruntAction = "apply-all"
	}

	if c.Command.Name == "down" {
		terragruntAction = "destroy-all"
	}

	cmd := exec.Command("terragrunt", terragruntAction)
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
