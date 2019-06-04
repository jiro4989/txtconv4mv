package main

import (
	"github.com/spf13/cobra"
)

func init() {
	cobra.OnInitialize()
}

var RootCommand = &cobra.Command{
	Use:     "txtconv4mv",
	Short:   "",
	Version: Version,
}
