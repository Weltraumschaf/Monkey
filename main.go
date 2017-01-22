package main

import (
	"fmt"
	"github.com/Weltraumschaf/monkey/antlr"
	"github.com/Weltraumschaf/monkey/interpreter"
	"github.com/Weltraumschaf/monkey/repl"
	"github.com/Weltraumschaf/monkey/visitor"
	antlr_rt "github.com/antlr/antlr4/runtime/Go/antlr"
	"gopkg.in/alecthomas/kingpin.v2"
	"os"
)

var (
	// See https://github.com/alecthomas/kingpin
	app     = kingpin.New("monkey", "The Monkey programming language.")
	debug   = app.Flag("debug", "Enable debug mode.").Short('d').Bool()
	verbose = app.Flag("verbose", "Enable verbose mode.").Short('v').Bool()

	replCmd = app.Command("repl", "Starts the REPL.")

	runCmd      = app.Command("run", "Interpret the given file.")
	runFilename = runCmd.Flag("file", "File to run.").Short('f').Required().String()

	antlrCmd      = app.Command("antlr", "Experimental ANTLR4 parser.")
	antlrShowTree = antlrCmd.Flag("tree", "Show parse tree.").Short('t').Bool()
	antlrFilename = antlrCmd.Flag("file", "File to parse.").Short('f').Required().String()
)

func main() {
	kingpin.Version("1.0.0-SNAPSHOT")

	switch kingpin.MustParse(app.Parse(os.Args[1:])) {
	case replCmd.FullCommand():
		fmt.Println("Feel free to type in commands.")
		repl.Start(os.Stdin, os.Stdout)
	case runCmd.FullCommand():
		interpreter.Start(*runFilename, os.Stdout)
	case antlrCmd.FullCommand():
		fmt.Printf("Parsing '%s' with ANTLR4 parser...\n", *antlrFilename)
		input := antlr_rt.NewFileStream(*antlrFilename)
		lexer := antlr.NewMonkeyLexer(input)
		stream := antlr_rt.NewCommonTokenStream(lexer, 0)
		p := antlr.NewMonkeyParser(stream)
		p.AddErrorListener(antlr_rt.NewDiagnosticErrorListener(true))
		p.BuildParseTrees = true
		tree := p.Program()

		if *antlrShowTree {
			fmt.Println(tree.ToStringTree(nil, p))
		} else {
			antlr_rt.ParseTreeWalkerDefault.Walk(visitor.NewTreeShapeListener(), tree)
		}
	default:
		fmt.Println("Bad sub command!")
	}
}
