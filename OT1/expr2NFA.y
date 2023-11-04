%{
/*********************************************
将所有的词法分析功能均放在 yylex 函数内实现，为 +、-、*、\、(、 ) 每个运算符及整数分别定义一个单词类别，在 yylex 内实现代码，能
识别这些单词，并将单词类别返回给词法分析程序。
实现功能更强的词法分析程序，可识别并忽略空格、制表符、回车等
空白符，能识别多位十进制整数。
YACC file
**********************************************/
#include<stdio.h>
#include<math.h>
#include<stdlib.h>
#include<ctype.h>
#include<string.h>
#include "nfa.h"
#ifndef YYSTYPE
#define YYSTYPE nfa
#endif

char curr_element;
int yylex();
extern int yyparse();
FILE* yyin;
void yyerror(const char* s);
%}

//TODO:给每个符号定义一个单词类别
%token OR
%token MUL
%token ELEMENT
%token LEFTPART RIGHTPART
%left OR

%%


lines   :       lines expr '\n' {print_nfa($2); }
        |       lines '\n'
        |
        ;


expr    :       expr expr   { $$=nfa_connect($1,$2);}                                
        |       expr OR expr   { $$=nfa_or($1,$3);}
        |       expr MUL   { $$=nfa_mul($1);}
        |       LEFTPART expr RIGHTPART   {$$=$2;}
        |       ELEMENT  {$$=single_nfa(curr_element);}
        ;
%%

// programs section

int yylex()
{
    int t;
    while(1){
        t=getchar();
        if(t==' '||t=='\t'){
            //do noting
        }
        else if(t=='|'){
            return OR;
        }
        else if(t=='*'){
            return MUL;
        }
        else if(t=='('){
            return LEFTPART;
        }
        else if(t==')'){
            return RIGHTPART;
        }
        else if(t=='\n'){
            return t;
        }
        else{
            curr_element=t;
            return ELEMENT;
        }
    }
}

int main(void)
{
    yyin=stdin;
    do{
        yyparse();
    }while(!feof(yyin));
    return 0;
}
void yyerror(const char* s){
    fprintf(stderr,"Parse error: %s\n",s);
    exit(1);
}