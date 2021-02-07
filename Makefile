clean:
	rm -rf target

flex:
	mkdir target
	flex app.l
	g++ lex.yy.c -o output.o 
	mv lex.yy.c ./target/lex.yy.c
	mv output.o ./target/output.o
	./target/output.o
	
run:
	clean flex bison execute


bison:
	bison -d app.y
	flex app.l
	g++ app.tab.c lex.yy.c -deprecated -o app 
	./app

cleanBison:
	rm -f app.tab.c
	rm -f app.tab.h
	rm -f lex.yy.c