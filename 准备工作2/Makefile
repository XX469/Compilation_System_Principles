.PHONY:test clean yacc

ARMPRE:=arm-linux-gnueabihf-
SOURCE:=./arm/main
TESTFILE:=./arm/findmax
YACCSOURCE:=./yacc/alu
    
test:
	$(ARMPRE)gcc $(SOURCE).c -o $(SOURCE)
	qemu-arm -L /usr/arm-linux-gnueabihf $(SOURCE)
	$(ARMPRE)gcc $(TESTFILE).S -o $(TESTFILE).out
	qemu-arm -L /usr/arm-linux-gnueabihf $(TESTFILE).out

clean:
	rm */*.S */*.o 

yacc:
	yacc $(YACCSOURCE).y -o $(YACCSOURCE).tab.c
	gcc $(YACCSOURCE).tab.c -lm -o $(YACCSOURCE)
	./$(YACCSOURCE)