package interpreter

import (
	"github.com/Weltraumschaf/monkey/error"
	"github.com/Weltraumschaf/monkey/evaluator"
	"github.com/Weltraumschaf/monkey/lexer"
	"github.com/Weltraumschaf/monkey/object"
	"github.com/Weltraumschaf/monkey/parser"
	"io"
	"io/ioutil"
)

func Start(filename string, out io.Writer) {
	content, err := ioutil.ReadFile(filename)

	if nil != err {
		io.WriteString(out, "Can not read file "+filename+"!\n")
	}

	io.WriteString(out, "Interpreting "+filename+"...\n")

	l := lexer.New(string(content))
	p := parser.New(l)
	program := p.ParseProgram()

	if len(p.Errors()) != 0 {
		error.PrintParserErrors(out, p.Errors())
		return
	}

	env := object.NewEnvironment()
	evaluator.Eval(program, env)
}
