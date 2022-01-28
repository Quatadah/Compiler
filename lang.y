%{

#include "Table_des_symboles.h"
#include "Attribute.h"
#include "PCode/PCode.h"

#include <stdio.h>
#include <string.h>


int num_label = 0;
int num_arg = 0;
int is_main = 0;

extern int yylex();
extern int yyparse();

void yyerror (char* s) {
  printf ("%s\n",s);
  }
int new_label(){
  return num_label++;
}		

%}

%union { 
	struct ATTRIBUTE * att;
}

%token <att> NUM
%token TINT
%token <att> ID
%token AO AF PO PF PV VIR
%token RETURN VOID EQ
%token <att> IF ELSE WHILE

%token <att> AND OR NOT DIFF EQUAL SUP SUPEQ INF INFEQ
%token PLUS MOINS STAR DIV
%token DOT ARR

%left OR                       // higher priority on ||
%left AND                      // higher priority on &&
%left DIFF EQUAL SUP INF       // higher priority on comparison
%left PLUS MOINS               // higher priority on + - 
%left STAR DIV                 // higher priority on * /
%left DOT ARR                  // higher priority on . and -> 
%nonassoc UNA                  // highest priority on unary operator
%nonassoc ELSE


%start prog  

// liste de tous les non terminaux dont vous voulez manipuler l'attribut
%type <att> exp  typename 
%type <att> if
%type <att> while        

%%

prog : include func_list               {}
;

include : {printf("#include \"PCode.h\"\n#include <stdio.h>\n\n\n");}

func_list : func_list fun      {}
| fun                          {}
;


// I. Functions

fun : type fun_head fun_body        {}
;


fun_head : ID PO PF            {if(!strcmp($1->name,"main")){
                                  is_main = 1;
                                  printf("int %s(){\n\n\tprint_stack();\n\n", $1->name);}
                                else
                                  printf("void %s(){\n\n\tprint_stack();\n\n", $1->name);}
| ID PO params PF              {if(!strcmp($1->name,"main")){
                                  is_main = 1;
                                  printf("int %s(){\n\n\tprint_stack();\n\n", $1->name);}
                                else
                                  printf("void %s(){\n\n\tprint_stack();\n\n", $1->name);
                                  num_arg = 0;}
;

params: type ID vir params     {sid s = string_to_sid($2->name);
                                attribute a = new_attribute();
                                a->int_val = -2 - num_arg;
                                set_symbol_value(s,a);
                                num_arg++;}
| type ID                      {sid s = string_to_sid($2->name);
                                attribute a = new_attribute();
                                a->int_val = -2 - num_arg;
                                num_arg++;
                                set_symbol_value(s,a);}

vlist: vlist vir ID            {printf("\tLOADI(0);\n");
                                sid s = string_to_sid($3->name);
                                attribute a = new_attribute();
                                a->int_val = sp - mp;
                                set_symbol_value(s,a);
                                LOADI(0);}
| ID                           {printf("\tLOADI(0);\n");
                                sid s = string_to_sid($1->name);
                                attribute a = new_attribute();
                                a->int_val = sp - mp;
                                set_symbol_value(s,a);
                                LOADI(0);}
;

vir : VIR                      {/*printf("\tprint_stack();\n");*/}
;

fun_body : AO list_block AF         {printf("}\n");}
;

// Block

list_block: block list_block    {}
| block                         {}
;

block:
decl_list inst_list            {}
;

// I. Declarations

decl_list : decl_list decl     {}
|                              {}
;

decl: var_decl PV              {}
;

var_decl : vtype vlist          {}
;

vtype : typename               {}
;

type
: typename                     {/*printf("void ");*/}
;

typename
: TINT                          { $$ = new_attribute();
                                  $$->type_val = INT; }
| VOID                          { $$ = new_attribute();
                                  $$->type_val = VOID;}
;

// II. Intructions

inst_list: inst inst_list   {}
| inst                      {}
;

pv : PV                       {printf("\tprint_stack();\n");}
;

inst:
exp pv                        {}
| ao block af                 {}
| aff pv                      {}
| ret pv                      {}
| cond                        {}
| loop                        {}
| pv                          {}
;

cond_inst:
exp pv                        {}
| AO block AF                 {}
| aff pv                      {}
| ret pv                      {}
| cond                        {}
| loop                        {}
| pv                          {}
;

// Accolades pour gerer l'entrée et la sortie d'un sous-bloc

ao : AO                       {printf("\tENTER_BLOCK(0);\n");
                               ENTER_BLOCK(0);
                               num_block++;}
;

af : AF                       {printf("\tEXIT_BLOCK(0);\n");
                               EXIT_BLOCK(0);
                               num_block--;
                               }
;


// II.1 Affectations

aff : ID EQ exp               {sid s = string_to_sid($1->name);
                              attribute a = get_symbol_value(s);
                              if(num_block == a->num_block){
                                printf("\tSTORE(mp + (%d));\n",a->int_val);
                                }
                              else{
                                printf("\tSTORE(");
                                for(int i = 0; i < num_block - a->num_block;i++){
                                  printf("stack[");
                                  }
                                printf("mp");
                                for(int i = 0; i < num_block - a->num_block;i++){
                                  printf("-1]");
                                  }
                                printf("+ (%d));\n",a->int_val);}
                              STORE(mp+a->int_val);
                              }
;


// II.2 Return
ret : RETURN exp              {if(is_main){
                                printf("\tSTORE(mp);\n\tEXIT_MAIN;\n");
                                STORE(mp);
                                EXIT_MAIN;}
                               else
                                printf("\tprint_stack();\n\treturn;\n");}
| RETURN PO PF                {}
;

// II.3. Conditionelles
//           N.B. ces rêgles génèrent un conflit déclage reduction
//           qui est résolu comme on le souhaite par un décalage (shift)
//           avec ELSE en entrée (voir y.output)

cond :
if bool_cond cond_inst elsop       {printf("Fin%d:\n\tNOP;\n",$<att>1->num_label);}
; 

// la regle avec else vient avant celle avec vide pour induire une resolution
// adequate du conflit shift / reduce avec ELSE en entrée

elsop : else cond_inst             {}
|                             {printf("Else%d:\n\tNOP\n",$<att>-2->num_label);}
;

bool_cond : PO exp PF         {printf("\tIFN(Else%d);\n", $<att>0->num_label);}
;

if : IF                       {$$=new_attribute();
                               $$->num_label = new_label();}
;

else : ELSE                   {printf("\tGOTO(Fin%d);\nElse%d:\n",$<att>-2->num_label, $<att>-2->num_label);}
;

// II.4. Iterations

loop : while while_cond cond_inst  {printf("\tGOTO(Loop%d);\n\nEnd%d:\n\tNOP\n",$1->num_label,$1->num_label);}
;

while_cond : PO exp PF        {printf("\tIFN(End%d);\n",$<att>0->num_label);}
;

while : WHILE                 {$$=new_attribute();
                               $$->num_label = new_label();
                               printf("Loop%d:\n",$$->num_label);}
;


// II.3 Expressions
/*exp*/
// II.3.1 Exp. arithmetiques
exp : MOINS exp %prec UNA         {printf("\tNEGI;\n");NEGI;}
         // -x + y lue comme (- x) + y  et pas - (x + y)
| exp PLUS exp                {printf("\tADDI;\n");ADDI;}
| exp MOINS exp               {printf("\tSUBI;\n");SUBI;}
| exp STAR exp                {printf("\tMULTI;\n");MULTI;}
| exp DIV exp                 {printf("\tDIVI;\n");DIVI;}
| PO exp PF                   {/*printf("print_stack();\n");*/}
| ID                          {sid s = string_to_sid($1->name);
                              attribute a = get_symbol_value(s);
                              if(num_block == a->num_block){
                                printf("\tLOAD(mp + (%d));\n",a->int_val);
                                }
                              else{
                                printf("\tLOAD(");
                                for(int i = 0; i < num_block - a->num_block;i++){
                                  printf("stack[");
                                  }
                                printf("mp");
                                for(int i = 0; i < num_block - a->num_block;i++){
                                  printf("-1]");
                                  }
                                printf("+ (%d));\n",a->int_val);}
                              LOAD(mp+a->int_val);
                              }
| app                         {}
| NUM                         {printf("\tLOADI(%i);\n", $1->int_val);LOADI($1->int_val);}


// II.3.2. Booléens

| NOT exp %prec UNA           {printf("\tNOTI;\n");NOTI;}
| exp INF exp                 {printf("\tLT;\n");LT;}
| exp SUP exp                 {printf("\tGT;\n");GT;}
| exp INFEQ exp           {printf("\tLEQ;\n");LEQ;}
| exp SUPEQ exp           {printf("\tGEQ;\n");GEQ;}
| exp EQUAL exp               {printf("\tEQUALI;\n");EQUALI;}
| exp DIFF exp                {printf("\tDIFFI;\n");DIFFI;}
| exp AND exp                 {printf("\tANDI;\n");ANDI;}
| exp OR exp                  {printf("\tORI;\n");ORI;}

;

// II.4 Applications de fonctions

app : ID PO args PF           {printf("\tENTER_BLOCK(%d);\n\t%s();\n\tEXIT_BLOCK(%d);\n",num_arg, $1->name,num_arg);
                               num_arg=0;}
;

args :  arglist               {}
|                             {}
;

arglist : exp VIR arglist     {num_arg++;}
| exp                         {num_arg++;}
;



%% 
int main () {

  /* Ici on peut ouvrir le fichier source, avec les messages 
     d'erreur usuel si besoin, et rediriger l'entrée standard 
     sur ce fichier pour lancer dessus la compilation.
   */
//printf ("Compiling MyC source code into PCode (Version 2021) !\n\n");
//stdin = fopen("test.myc","r");
//stdout = fopen("PCode/result.c","w");
return yyparse ();
//fclose(stdin);
//fclose(stdout);
 
} 

