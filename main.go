package main

import (
	"fmt"
	"gopkg.in/alecthomas/kingpin.v2"
	"os"
	"github.com/Weltraumschaf/monkey/repl"
)

var (
	// See https://github.com/alecthomas/kingpin
	app     = kingpin.New("monkey", "The Monkey programming language.")
	debug   = app.Flag("debug", "Enable debug mode.").Short('d').Bool()
	verbose = app.Flag("verbose", "Enable verbose mode.").Short('v').Bool()

	replCmd = app.Command("repl", "Starts the REPL.")

	runCmd = app.Command("run", "Interpret the given file.")
)

func main() {
	kingpin.Version("1.0.0-SNAPSHOT")

	switch kingpin.MustParse(app.Parse(os.Args[1:])) {
	case replCmd.FullCommand():
		fmt.Printf("Feel free to type in commands\n")
		repl.Start(os.Stdin, os.Stdout)
	case runCmd.FullCommand():
		fmt.Println("Not implemented yet!")
	default:
		fmt.Println("Bad sub command!")
	}
}
