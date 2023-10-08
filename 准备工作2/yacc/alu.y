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
#ifndef YYSTYPE
#define YYSTYPE double
#endif

struct ident
{
    char name[50];
    double value;
}id_table[50];
char curr_idname[50];
double curr_idvalue;
int idnum=0;
int is_in_idtable(char* s);
void insert_table(char* s,double v);
void print_info();
int yylex();
extern int yyparse();
FILE* yyin;
void yyerror(const char* s);
%}

//TODO:给每个符号定义一个单词类别
%token EQUAL
%token ADD MINUS
%token MUL DIV
%token LEFTPART RIGHTPART
%token NUMBER
%token ID
%left ADD MINUS
%left MUL DIV
%right UMINUS   
%right EQUAL      

%%


lines   :       lines expr ';' { printf("%f\n", $2);}
        |       lines assign ';' {printf("assign:\n");print_info();}
        |       lines ';'
        |
        ;
//TODO:完善表达式的规则
    
expr    :       expr ADD expr   { $$=$1+$3; }                                
        |       expr MINUS expr   { $$=$1-$3; }
        |       expr MUL expr   { $$=$1*$3; }
        |       expr DIV expr   { if($3==0) yyerror("Divider cannot be zero!\n"); else $$=$1/$3; }
        |       ID    {$$=curr_idvalue;}
        |       MINUS expr %prec UMINUS   {$$=-$2;}
        |       LEFTPART expr RIGHTPART   {$$=$2;}
        |       NUMBER  {$$=$1;}
        ;

assign  :       ID  EQUAL expr  {$$=$3;
                                int index=is_in_idtable(curr_idname);
                                id_table[index].value=$3;
                                curr_idvalue=$3;}
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
        else if(isdigit(t)){
            //TODO:解析多位数字返回数字类型 
            yylval=0;
            while(isdigit(t)||t=='.')
            {
                if(t=='.')
                {
                    t=getchar();
                    int temp=1;
                    while(isdigit(t))
                    {
                        yylval+=(t-'0')*pow(10,-temp);
                        temp++;
                        t=getchar();
                    }
                }
                else{
                    yylval=yylval*10+t-'0';
                    t=getchar();
                }
            }
            ungetc(t , stdin);
            return NUMBER;
        }
        else if((t=='_')||((t>='a'&&t<='z')||(t>='A'&&t<='Z')))
        {
            //读取标识符名称
            int temp=0;
            while(t=='_'||((t>='a'&&t<='z')||(t>='A'&&t<='Z')))
            {
                curr_idname[temp]=t;
                temp++;
                t=getchar();
            }
            curr_idname[temp]='\0';
            ungetc(t , stdin);
            //查询该标识符是否在符号列表中
            int index=is_in_idtable(curr_idname);
            if(index==-1)
            {
                insert_table(curr_idname,0);
                curr_idvalue=0;
            }
            else
            {
                curr_idvalue=id_table[index].value;
            }
            return ID;
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
        else if(t=='='){
            return EQUAL;
        }
        else{
            return t;
        }
    }
}

int is_in_idtable(char* s)
{
    for(int i=0;i<idnum;i++)
    {
        if(strcmp(s,id_table[i].name)==0)
        {
            return i;
        }
    }
    return -1;
}

void insert_table(char* s,double v)
{
    id_table[idnum].value=v;
    strcpy(id_table[idnum].name,s);
    idnum++;
}

void print_info()
{
    printf("curr_idname:%s\n",curr_idname); 
    printf("curr_idvalue:%f\n",curr_idvalue);
    printf("idnum:%d\n",idnum);
    printf("id_table:\n");
    for(int i=0;i<idnum;i++)
    {
        printf("%s:",id_table[i].name);
        printf("%f ",id_table[i].value);
    }
    printf("\n");
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