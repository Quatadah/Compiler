all :	lang test1_1 test2_1 test3_1 test3_2 test4_1 test4_2 test5_1 test6_1 test6_2 test6_3 test7_1 test7_2 test7_3

syntax : lexic	lang.y
	bison -v -y  -d  lang.y
lexic : lang.l
	flex lang.l

PCode/PCode.o : PCode/PCode.c PCode/PCode.h
	cd PCode; make pcode

lang		:	syntax Table_des_symboles.c Table_des_chaines.c Attribute.c PCode/PCode.o
	gcc -o lang lex.yy.c y.tab.c PCode/PCode.o Attribute.c Table_des_symboles.c Table_des_chaines.c

test1_1:
	./lang < test/test1_1.myc > PCode/test1_1.c

test2_1:
	./lang < test/test2_1.myc > PCode/test2_1.c

test3_1:
	./lang < test/test3_1.myc > PCode/test3_1.c

test3_2:
	./lang < test/test3_2.myc > PCode/test3_2.c

test4_1:
	./lang < test/test4_1.myc > PCode/test4_1.c

test4_2:
	./lang < test/test4_2.myc > PCode/test4_2.c

test5_1:
	./lang < test/test5_1.myc > PCode/test5_1.c

test6_1:
	./lang < test/test6_1.myc > PCode/test6_1.c

test6_2:
	./lang < test/test6_2.myc > PCode/test6_2.c

test6_3:
	./lang < test/test6_3.myc > PCode/test6_3.c

test7_1:
	./lang < test/test7_1.myc > PCode/test7_1.c

test7_2:
	./lang < test/test7_2.myc > PCode/test7_2.c

test7_3:
	./lang < test/test7_3.myc > PCode/test7_3.c

clean		:	
	rm -f lex.yy.c *.o y.tab.h y.tab.c lang *~ y.output; cd PCode; make clean

