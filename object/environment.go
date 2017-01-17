package object

type Environment struct {
	store map[string]Object
	outer *Environment
}

func NewEnvironment() *Environment {
	return NewEnclosedEnvironment(nil)
}

func NewEnclosedEnvironment(outer *Environment) *Environment {
	s := make(map[string]Object)
	return &Environment{store: s, outer: outer}
}

func (e *Environment) Get(name string) (Object, bool) {
	obj, ok := e.store[name]

	if !ok && e.outer != nil {
		obj, ok = e.outer.Get(name)
	}

	return obj, ok
}

func (e *Environment) Set(name string, val Object) Object {
	e.store[name] = val
	return val
}
