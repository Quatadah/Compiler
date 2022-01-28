all :	ex1 ex2 ex3 ex4 ex5 ex6 ex7 test1_1 test2_1 test3_1 test3_2 test4_1 test4_2 test5_1 test6_1 test6_2 test6_3 test7_1 test7_2 test7_3

pcode : PCode.c PCode.h
	gcc -c PCode.c

ex1 :	pcode pcode-ex1.c
	gcc -o ex1 pcode-ex1.c PCode.o

ex2 :	pcode pcode-ex2.c
	gcc -o ex2 pcode-ex2.c PCode.o

ex3 :	pcode pcode-ex3.c
	gcc -o ex3 pcode-ex3.c PCode.o

ex4 :	pcode pcode-ex4.c
	gcc -o ex4 pcode-ex4.c PCode.o

ex5 :	pcode pcode-ex5.c
	gcc -o ex5 pcode-ex5.c PCode.o

ex6 :	pcode pcode-ex6.c
	gcc -o ex6 pcode-ex6.c PCode.o

ex7 :	pcode pcode-ex7.c
	gcc -o ex7 pcode-ex7.c PCode.o

result :	pcode result.c
	gcc -o result result.c PCode.o

test1_1:	pcode test1_1.c
	gcc -o test1_1 test1_1.c PCode.o

test2_1:	pcode test2_1.c
	gcc -o test2_1 test2_1.c PCode.o

test3_1:	pcode test3_1.c
	gcc -o test3_1 test3_1.c PCode.o

test3_2:	pcode test3_2.c
	gcc -o test3_2 test3_2.c PCode.o

test4_1:	pcode test4_1.c
	gcc -o test4_1 test4_1.c PCode.o

test4_2:	pcode test4_2.c
	gcc -o test4_2 test4_2.c PCode.o

test5_1:	pcode test5_1.c
	gcc -o test5_1 test5_1.c PCode.o

test6_1:	pcode test6_1.c
	gcc -o test1_1 test6_1.c PCode.o

test6_2:	pcode test6_2.c
	gcc -o test6_2 test6_2.c PCode.o

test6_3:	pcode test6_3.c
	gcc -o test6_3 test6_3.c PCode.o

test7_1:	pcode test7_1.c
	gcc -o test7_1 test7_1.c PCode.o

test7_2:	pcode test7_2.c
	gcc -o test7_2 test7_2.c PCode.o

test7_3:	pcode test7_3.c
	gcc -o test7_3 test7_3.c PCode.o

clean :
	rm -f ex* test* result* *.o
