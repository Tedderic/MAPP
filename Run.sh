yacc -d test.y
lex test.l
gcc -std=gnu99 lex.yy.c y.tab.c -o test
./test
