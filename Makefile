Gram=y.tab.c y.tab.h

all: $(Gram) y.tab.c
	@gcc symbol.c init.c math.c y.tab.c -lm
	@echo Compiled

$(Gram): hoc3.y
	@yacc -d hoc3.y

