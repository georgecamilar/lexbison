clean:
	rm -rf target

flex:
	mkdir target
	flex app.l
	g++ lex.yy.c -o output.o 
	mv lex.yy.c ./target/lex.yy.c
	mv output.o ./target/output.o
	# ./target/output.o

bison:
	
run:
	clean flex bison execute
