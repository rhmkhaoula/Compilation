%{ 
#include<stdio.h>
#include<stdlib.h>
#include "snt.tab.h"
#include "TS.h"
extern nb_ligne;
extern col;
int i;
extern YYSTYPE yylval;
%}

%option noyywrap

lettre [a-z]
chiffre [0-9]
idf [A-Z]({lettre}|{chiffre})*
entier \([+-]{chiffre}+\)|{chiffre}+
float ({chiffre}+,{chiffre}+)|(\([[+-]{chiffre}+,{chiffre}+\))
char '.'
bool [true|false]
COMMENT #[.]
space ("\t"|" ")+
saut "\n"+
%%
{COMMENT} { printf ("Un Commentaire reconnue\n");
                               for(i=0;i<strlen(yytext);i++){if(yytext[i] == '\n' ){nb_ligne++;  Col = 1;	  }  Col++;	}}
                        /*declaratin des mtes clte */
"    "  {printf ("%s est un mot cl�",yytext); col= Col + strlen(yytext); rechercher (yytext,"Mot cle"," ",0, 1);   return(inde);   }						
"int"   {printf ("%s est un mot cl�",yytext); Col= Col + strlen(yytext); rechercher (yytext,"Mot cle"," ",0, 1);  return(mc_int);   }	
"reel"  {printf ("%s est un mot cl�",yytext); Col= Col + strlen(yytext); rechercher (yytext,"Mot cle"," ",0, 1);   return(mc_reel);   }		
"chat"  {printf ("%s est un mot cl�",yytext); Col= Col + strlen(yytext); rechercher (yytext,"Mot cle"," ",0, 1);   return(mc_char);   }
"bool"  {printf ("%s est un mot cl�",yytext); Col= Col + strlen(yytext); rechercher (yytext,"Mot cle"," ",0, 1);return(mc_bool);   }			
"if"    {printf ("%s est un mot cl�",yytext); Col= Col + strlen(yytext); rechercher (yytext,"Mot cle"," ",0, 1);   return(IF);   }
"else"  {printf ("%s est un mot cl�",yytext); Col= Col + strlen(yytext); rechercher (yytext,"Mot cle"," ",0, 1);  return(mc_else); } 
"for"   {printf ("%s est un mot cl�",yytext); Col= Col + strlen(yytext); rechercher (yytext,"Mot cle"," ",0, 1);  return(FOR);  } 
"while" {printf ("%s est un mot cl�",yytext); Col= Col + strlen(yytext); rechercher (yytext,"Mot cle"," ",0, 1);   return(WHILE);}
"and"   {printf ("%s est un mot cl�",yytext); Col= Col + strlen(yytext); rechercher (yytext,"Mot cle"," ",0, 1);   return(AND);  }
"or"    {printf ("%s est un mot cl�",yytext); Col= Col + strlen(yytext); rechercher (yytext,"Mot cle"," ",0, 1);  return(OR);   }
"not"   {printf ("%s est un mot cl�",yytext); Col= Col + strlen(yytext); rechercher (yytext,"Mot cle"," ",0, 1);  return(NOT);  }
"in"    {printf ("%s est un mot cl�",yytext); Col= Col + strlen(yytext); rechercher (yytext,"Mot cle"," ",0, 1);  return(IN);   }   
"range" {printf ("%s est un mot cl�",yytext); Col= Col + strlen(yytext); rechercher (yytext,"Mot cle"," ",0, 1);   return(RANGE);}
                           /*declartion des types */
{float}  {printf("%s est un float+++++\n",yytext);  Col= Col + strlen(yytext); yylval.reel= atof(yytext);rechercher(yytext,"reel","reel",Atof_v2(yytext), 0);  return(REEL);   }
{entier} {if(atoi(yytext)<=32767 && atoi(yytext)>= -32768){  Col= Col + strlen(yytext); printf("%s est un entier\n",yytext);yylval.entier = atoi(yytext);rechercher (yytext,"entier","entier",Atoi_v2(yytext), 0)  return ENTIER;}
			else{ Col= Col + strlen(yytext);	printf("erreur lexicale a la ligne :%d et colonne :%d  depassement de capacite\n",nb_ligne, Col) ;}}
{char}   {printf("%s est un char++++\n",yytext);   Col= Col + strlen(yytext); yylval.str = strdup(yytext); rechercher (yytext,"car","car",atoi(yytext), 0); return(CHAR);   }
{bool}   {printf("%s est un bool++++\n",yytext);    Col= Col + strlen(yytext); yylval.str = strdup(yytext); return(BOOLIEN);}
{idf}    {if (yyleng <=8){ Col= Col + strlen(yytext); 	   printf("IDF reconnu %s \n",yytext);  yylval.str =strdup(yytext); rechercher (yytext,"IDF ","",0, 0);	   return (IDF); }
         	 else        { Col= Col + strlen(yytext); 	   printf("ERREUR ligne :%d  et colonne :%d  IDF %s est tres long\n",nb_ligne,ol, yytext);}}
                        /*declaration des autres symboles definis dans le langage*/
"+"  {printf ("%s additon\n",yytext);  Col= Col + strlen(yytext); rechercher (yytext,"op ar",0,0,2); return(ADD);}
"-"  {printf ("%s soustraction\n",yytext); Col= Col + strlen(yytext);rechercher (yytext,"op ar",0,0,2); return(SUB);}
"*"  {printf ("%s multiplication\n",yytext); Col= Col + strlen(yytext);rechercher (yytext,"op ar",0,0,2); return(MUL);}
"/"  {printf ("%s division\n",yytext);  Col= Col + strlen(yytext);rechercher (yytext,"op ar",0,0,2); return(DIV);}
"="  {printf ("%s egalit�\n",yytext); Col= Col + strlen(yytext); rechercher (yytext,"Separateur",0,0,2);return(AFF);}
"<"  {printf ("%s infariere\n",yytext);  Col= Col + strlen(yytext);rechercher (yytext,"Separateur",0,0,2); return INF;}
"<=" {printf ("%s infariere au egalit�\n",yytext); Col= Col + strlen(yytext);rechercher (yytext,"Separateur",0,0,2);  return INFG ;}
"==" {printf ("%s egalit�\n",yytext); Col= Col + strlen(yytext); rechercher (yytext,"Separateur",0,0,2); return EGL ;}
">"  {printf ("%s suparier\n",yytext); Col= Col + strlen(yytext);rechercher (yytext,"Separateur",0,0,2); return SP ;}
">=" {printf ("%s suparier au egalit�\n",yytext);  Col= Col + strlen(yytext);rechercher (yytext,"Separateur",0,0,2); return SPG ;}
"!=" {printf ("%s defirente\n",yytext); Col= Col + strlen(yytext);;rechercher (yytext,"Separateur",0,0,2); return NEGL ;}
"."  {printf ("%s point \n",yytext); Col= Col + strlen(yytext);rechercher (yytext,"Separateur",0,0,2); return '.' ;}
";"  {printf ("%s point virguel\n",yytext); Col= Col + strlen(yytext);rechercher (yytext,"Separateur",0,0,2); return ';' ;}
":"  {printf ("%s deux point virguel\n",yytext); Col= Col + strlen(yytext);rechercher (yytext,"Separateur",0,0,2);  return ':' ;}
"("  {printf ("%s virguel\n",yytext); Col= Col + strlen(yytext);rechercher (yytext,"Separateur",0,0,2);  return '(' ;}
")"  {printf ("%s pa_far virguel\n",yytext); Col= Col + strlen(yytext); rechercher (yytext,"Separateur",0,0,2); return ')' ;}
"["  {printf ("%s sop ouvrent\n",yytext); Col= Col + strlen(yytext);rechercher (yytext,"Separateur",0,0,2);return '[' ;}
"]"  {printf ("%s sop farment\n",yytext); Col= Col +  strlen(yytext);rechercher (yytext,"Separateur",0,0,2); return ']' ;}
{space} {Col+=yyleng;}
{saut} {Col=1; nb_ligne+=yyleng;}
. {printf ("erreur lexicale line %d, colonne %d\n",line,Col);}
%%

 