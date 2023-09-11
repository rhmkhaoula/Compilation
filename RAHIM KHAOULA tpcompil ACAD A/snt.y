%{      #include "quad.h"
    int nb_ligne=1,Col=1;
	 char sauvType[50];
     int Fin_if,deb_else,val,num_quand,sauv,deb_while,Fin_w;
     int qc=0;
     char tmp[50];
%}
  %union{
      int entier;
      char* str;
      float reel;
}
%token ';' ',' '[' ']' IF mc_else FOR WHILE IN RANGE '(' ')' ':' mc_int mc_reel mc_char mc_bool inde
%token <str>IDF AFF <reel>REEL <entier>ENTIER <str>CHAR <str>BOOLIEN 
%left ADD SUB
%left MUL DIV
%left AND OR NOT
%left SP SPG EGL NEGL INF INFG 
%start S
%%
S:LIST_DEC INST {printf("prog syntaxiquement correct"); 
                     YYACCEPT;}
;
/*_______________________________________________________________________________________________________________*/
LIST_DEC:DEC LIST_DEC
         |     
;
/*_______________________________________________________________________________________________________________*/
DEC:DEC_VAR   
   |DEC_TAB
;
/*_______________________________________________________________________________________________________________*/
DEC_TAB: TYPE IDF'['ENTIER ']'

;
/*_______________________________________________________________________________________________________________*/
DEC_VAR: TYPE LIST_IDF         
        |IDF AFF LIST_ENS      {if(doubleDeclaration($1)==0)
                                     insererTYPE($1,sauvType);
                                 else  
                                printf("\nErreur semantique: Double declaration de {{%s}} a la ligne [%d] et a la colonne [%d]\n\n",$1,nb_ligne,Col);
                                 }
	;
/*______________________________________________________________________________________________________________*/	
LIST_IDF: IDF ',' LIST_IDF     {if(doubleDeclaration($1)==0)
                                     insererTYPE($1,sauvType);
                                 else  
                                printf("\nErreur semantique: Double declaration de {{%s}} a la ligne [%d] et a la colonne [%d]\n\n",$1,nb_ligne,Col);
                                 }
        | IDF                 {if(doubleDeclaration($1)==0)
                            insererTYPE($1,sauvType);
                         else  
                          printf("\nErreur semantique: Double declaration de {{%s}} a la ligne [%d] et a la colonne [%d]\n\n",$1,nb_ligne,Col);
                         }
;
/*_______________________________________________________________________________________________________________*/
LIST_ENS: mc_int
         |mc_char
		 |mc_reel
         |mc_bool		
;
/*_______________________________________________________________________________________________________________*/
TYPE:  ENTIER     {strcpy(sauvType,"entier");}
     | REEL  {strcpy(sauvType,"reel");}
	 | CHAR   {strcpy(sauvType,"car");}
	 | BOOLIEN   {strcpy(sauvType,"bool");}
;
INST: INST_AFF
     | INST_IF
	 | INST_FOR
	 | INST_WHILE
;
/*_______________________________________________________________________________________________________________*/
INST_AFF : IDF AFF EXP  
	      
;
/*_______________________________________________________________________________________________________________*/
EXP: mc_char
    |mc_int
    |mc_reel
    |exp opa exp
	|IDF
;
/*_______________________________________________________________________________________________________________*/
exp: IDF opa mc_int
    |IDF opa mc_reel
	|IDF opa IDF
;
/*_______________________________________________________________________________________________________________*/
opa:ADD
    |MUL 
    |DIV
    |SUB
    ;
/*_______________________________________________________________________________________________________________*/	
INST_IF :IF '(' COND ')' ':' bloc_inst   
        |B ELSE {sprintf(tmp,"%d",qc);
         ajour_quad(Fin_if,1,tmp);
           }
;
B:A ':'  bloc_inst {Fin_if=qc;
                    quadr("BR", "","vide", "vide");
                    sprintf(tmp,"%d",qc);
                    ajour_quad(num_quand,Col,val);}
;
A:IF '(' COND ')'     { deb_else=qc; 
                       quadr("BZ", "","temp_cond", "vide");}   
;
/*_______________________________________________________________________________________________________________*/
ELSE:mc_else ':' bloc_inst {sprintf(tmp,"%d",qc);
            ajour_quad(Fin_if,1,tmp);
           }
;
/*_______________________________________________________________________________________________________________*/      
COND : EXP_COMP
      |EXP_LOG
;
/*_______________________________________________________________________________________________________________*/
EXP_COMP:EXP oprc EXP
;
/*_______________________________________________________________________________________________________________*/
EXP_LOG: EXP_COMP oprl EXP_COMP
        |NOT EXP_COMP oprl EXP_COMP
		|EXP_COMP oprl NOT EXP_COMP
		|NOT EXP_COMP oprl  NOT EXP_COMP

;
/*_______________________________________________________________________________________________________________*/
oprc: SP
     |SPG
     |INF
     |INFG
     |EGL
     |NEGL
;
/*_______________________________________________________________________________________________________________*/
oprl: ADD
     |OR
	 |NOT
;
/*_______________________________________________________________________________________________________________*/
bloc_inst : inde INST  bloc_inst
          |
           

;
/*_______________________________________________________________________________________________________________*/
INST_FOR : FOR IDF IN RANGE '(' ENTIER',' ENTIER ')' ':' bloc_inst   
          |FOR IDF IN  IDF ':' bloc_inst   
;
/*_______________________________________________________________________________________________________________*/
INST_WHILE : WHILE '(' A COND B ')' ':' bloc_inst C
             |A B C  {sprintf(tmp,"%d",qc);
         ajour_quad(Fin_w,1,tmp);
                      }
     
C:B ')' ':' bloc_inst                { quadr("BR", "deb_while","vide", "vide"); qc++;
                                            sprintf(tmp,"%d",qc);
                                            ajour_quad(sauv,Col,val);  Fin_w=qc;
                                            }       
B: A COND                 { quadr("BZ", "","temp_cond", "vide");
                                      sauv=qc;      qc++;}
 A: '('                      {  deb_while=qc;}
 /*_______________________________________________________________________________________________________________*/
%%
main()
{
yyparse();
afficher();
afficher_qdr();
}
yywrap ()
{}
int yyerror ( char*  msg )  
 {
    printf ("Erreur Syntaxique a ligne %d a colonne %d \n", nb_ligne,Col);
  }