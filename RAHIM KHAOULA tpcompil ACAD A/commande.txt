flex lex.l
bison -d snt.y
gcc lex.yy.c snt.tab.c   -lfl -ly -o yp.exe
yp.exe<exemple.txt 