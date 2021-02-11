run:
	make clean compile move package execute

#clean the old executions
clean:
	rm -rf target

#1. create the target folder for the files to be generated
#2. use bison and flex to compile 
compile:
	mkdir target
	bison -d app.y
	flex app.l

#move the files generated to the target folder
move: 
	mv lex.yy.c ./target/lex.yy.c	
	mv app.tab.c ./target/app.tab.c
	mv app.tab.h ./target/app.tab.h

#execute the generated files and create the executable file
package:
	g++ ./target/app.tab.c ./target/lex.yy.c -o output.o 
	mv output.o ./target/output.o

#execute the generated file
execute:
	./target/output.o
