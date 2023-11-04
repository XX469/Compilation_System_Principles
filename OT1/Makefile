.PHONY:expr2NFA

YACCSOURCE:=./expr2NFA

clean:
	rm */*.S */*.o 

expr2NFA:
	yacc $(YACCSOURCE).y -o $(YACCSOURCE).tab.c
	gcc $(YACCSOURCE).tab.c -lm -o $(YACCSOURCE)
	./$(YACCSOURCE)