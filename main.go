package main

import (
	"fmt"
	"github.com/Weltraumschaf/monkey/interpreter"
	"github.com/Weltraumschaf/monkey/antlr"
	"github.com/Weltraumschaf/monkey/repl"
	"gopkg.in/alecthomas/kingpin.v2"
	"os"
	antlr_rt "github.com/antlr/antlr4/runtime/Go/antlr"
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
	antlrFilename = antlrCmd.Flag("file", "File to parse.").Short('f').Required().String()
)

type TreeShapeListener struct {
	*antlr.BaseMonkeyListener
}

func NewTreeShapeListener() *TreeShapeListener {
	return new(TreeShapeListener)
}

func (this *TreeShapeListener) EnterEveryRule(ctx antlr_rt.ParserRuleContext) {
	fmt.Println(ctx.GetText())
}

func main() {
	kingpin.Version("1.0.0-SNAPSHOT")

	switch kingpin.MustParse(app.Parse(os.Args[1:])) {
	case replCmd.FullCommand():
		fmt.Printf("Feel free to type in commands\n")
		repl.Start(os.Stdin, os.Stdout)
	case runCmd.FullCommand():
		interpreter.Start(*runFilename, os.Stdout)
	case antlrCmd.FullCommand():
		fmt.Printf("Parsing '%s' with ANTLR4 parser...\n", *antlrFilename)
		input := antlr_rt.NewFileStream(*antlrFilename)
		lexer := antlr.NewMonkeyLexer(input)
		stream := antlr_rt.NewCommonTokenStream(lexer,0)
		p := antlr.NewMonkeyParser(stream)
		p.AddErrorListener(antlr_rt.NewDiagnosticErrorListener(true))
		p.BuildParseTrees = true
		tree := p.Program()
		antlr_rt.ParseTreeWalkerDefault.Walk(NewTreeShapeListener(), tree)
	default:
		fmt.Println("Bad sub command!")
	}
}
