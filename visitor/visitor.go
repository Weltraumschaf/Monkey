package visitor

import (
	"fmt"
	"github.com/Weltraumschaf/monkey/antlr"
	antlr_rt "github.com/antlr/antlr4/runtime/Go/antlr"
	"reflect"
)

type TreeShapeListener struct {
	*antlr.BaseMonkeyListener
}

func NewTreeShapeListener() *TreeShapeListener {
	return new(TreeShapeListener)
}

func (this *TreeShapeListener) EnterEveryRule(ctx antlr_rt.ParserRuleContext) {
	fmt.Printf("('%s', %s)\n", ctx.GetText(), reflect.TypeOf(ctx))
}
