%{
/*********************************************
将所有的词法分析功能均放在 yylex 函数内实现，为 +、-、*、\、(、 ) 每个运算符及整数分别定义一个单词类别，在 yylex 内实现代码，能
识别这些单词，并将单词类别返回给词法分析程序。
实现功能更强的词法分析程序，可识别并忽略空格、制表符、回车等
空白符，能识别多位十进制整数。
YACC file
**********************************************/
#include<stdio.h>
#include<string.h>
#include<stdlib.h>
#include<ctype.h>
#ifndef YYSTYPE
#define YYSTYPE char*
#endif
char num[100];
int yylex();
extern int yyparse();
FILE* yyin;
void yyerror(const char* s);
%}

//TODO:给每个符号定义一个单词类别
%token ADD MINUS
%token MUL DIV
%token LEFTPART RIGHTPART
%token NUMBER
%left ADD MINUS
%left MUL DIV
%right UMINUS         

%%


lines   :       lines expr ';' { printf("%s\n", $2); }
        |       lines ';'
        |
        ;
//TODO:完善表达式的规则
expr    :       expr ADD expr   { $$=(char *)malloc(100*sizeof (char)); strcpy($$,strcat($1,$3)); strcat($$,"+"); }
        |       expr MINUS expr   { $$=(char *)malloc(100*sizeof (char)); strcpy($$,strcat($1,$3)); strcat($$,"-"); }
        |       expr MUL expr   { $$=(char *)malloc(100*sizeof (char)); strcpy($$,strcat($1,$3)); strcat($$,"*"); }
        |       expr DIV expr   { $$=(char *)malloc(100*sizeof (char)); strcpy($$,strcat($1,$3)); strcat($$,"/"); }
        |       MINUS expr %prec UMINUS   {$$=(char *)malloc(100*sizeof (char));strcpy($$,$2);strcat($$,"-");}
        |       LEFTPART expr RIGHTPART   {$$=(char *)malloc(100*sizeof (char));strcpy($$,$2);}
        |       NUMBER  {$$=(char *)malloc(100*sizeof (char));strcpy($$,$1);}
        ;


%%

// programs section

int yylex()
{
    int t;
    while(1){
        t=getchar();
        if(t==' '||t=='\t'||t=='\n'){
            //do noting
        }
        else if(t >= '0' && t <= '9'){
            int temp=0;
            while((t >= '0' && t <= '9')||(t=='.'))
            {
                num[temp]=t;
                temp++;
                t=getchar();
            }
            num[temp]='\0';
            yylval=num;
            ungetc(t , stdin);
            return NUMBER;
        }
        else if(t=='+'){
            return ADD;
        }
        else if(t=='-'){
            return MINUS;
        }
        else if(t=='*'){
            return MUL;
        }
        else if(t=='/'){
            return DIV;
        }
        else if(t=='('){
            return LEFTPART;
        }
        else if(t==')'){
            return RIGHTPART;
        }
        else{
            return t;
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