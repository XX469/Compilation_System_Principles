#include <stdio.h>
#include <math.h>
#include <stdlib.h>
#include <ctype.h>
#include <string.h>

#define Eps 'E'
struct NFA
{
    char **graph;
    int statenum;
};

typedef struct NFA nfa;

void print_nfa(nfa a)
{
    printf("statenum:%d\nstart:%d\nend:%d\n", a.statenum, 0, a.statenum - 1);
    for (int i = 0; i < a.statenum; i++)
    {
        for (int j = 0; j < a.statenum; j++)
        {
            if (a.graph[i][j] != 0)
            {
                printf("(%d)-%c->(%d)\n", i, a.graph[i][j], j);
            }
        }
    }
}

nfa single_nfa(char element) // L(a)
{
    nfa res;
    res.statenum = 2;
    res.graph=(char **)malloc(2 * sizeof(char *));
    for (int i = 0; i < 2; i++)
    {
        res.graph[i]=(char *)malloc(2 * sizeof(char));
        for (int j = 0; j < 2; j++)
        {
            if(i==0 && j==1)
            {
                res.graph[i][j]=element;
            }
            else
            {
                res.graph[i][j]=0;
            }
        }
    }
    return res;
}

nfa nfa_or(nfa a, nfa b) // a|b
{
    int numa = a.statenum, numb = b.statenum;
    int n = numa + numb + 2; // new statenums
    nfa res;
    res.statenum = n;
    res.graph=(char**)malloc(n*sizeof(char*));
    //copy a and b
    //printf("numa:%d\nnumb:%d\nn:%d\n",numa,numb,n);
    // printf("copy a and b\n");
    for(int i=0;i<n;i++)
    {
        res.graph[i]=(char*)malloc(n*sizeof(char));
        for(int j=0;j<n;j++)
        {
            if(i<=numa && i!=0 && j<=numa && j!=0) //copy a
            {
                res.graph[i][j]=a.graph[i-1][j-1];
            }
            else if(i>numa && i!=n-1 && j>numa && j!=n-1) //copy b
            {
                res.graph[i][j]=b.graph[i-numa-1][j-numa-1];
            }
            else
            {
                res.graph[i][j]=0;
            }
            // printf("%c ",res.graph[i][j]);
        }
        // printf("\n");
    }
    //add 4 new edge
    //printf("add 4 new edge\n");
    res.graph[0][1]=Eps;
    res.graph[0][numa+1]=Eps;
    res.graph[numa][n-1]=Eps;
    res.graph[n-2][n-1]=Eps;
    //free a
    for(int i=0;i<numa;i++)
    {
        free(a.graph[i]);
    }
    free(a.graph);
    //free b
    for(int i=0;i<numb;i++)
    {
        free(b.graph[i]);
    }
    free(b.graph);
    return res;
}

nfa nfa_connect(nfa a, nfa b) // ab
{
    int numa = a.statenum, numb = b.statenum;
    int n = numa + numb - 1; // new statenums
    nfa res;
    res.statenum = n;
    res.graph=(char**)malloc(n*sizeof(char*));
    for (int i = 0; i < n; i++) //connect a and b
    {
        res.graph[i]=(char*)malloc(n*sizeof(char));
        for (int j = 0; j < n; j++)
        {
            if (i < numa && j < numa) // copy a
            {
                res.graph[i][j] = a.graph[i][j];
            }
            else if (i >= numa-1 && j >= numa-1) // copy b
            {
                res.graph[i][j] = b.graph[i-numa+1][j-numa+1];
            }
            else
            {
                res.graph[i][j] = 0;
            }
        }
    }
    //free a
    for(int i=0;i<numa;i++)
    {
        free(a.graph[i]);
    }
    free(a.graph);
    //free b
    for(int i=0;i<numb;i++)
    {
        free(b.graph[i]);
    }
    free(b.graph);
    return res;
}

nfa nfa_mul(nfa a) // a*
{
    int numa = a.statenum;
    int n = numa + 2; // new statenums
    nfa res;
    res.statenum = n;
    res.graph=(char**)malloc(n*sizeof(char*));
    // copy a
    for (int i = 0; i < n; i++)
    {
        res.graph[i]=(char*)malloc(n*sizeof(char));
        for (int j = 0; j < n; j++)
        {
            if (i == 0 || i == n - 1 || j == 0 || j == n - 1)
            {
                res.graph[i][j] = 0;
            }
            else
            {
                res.graph[i][j] = a.graph[i - 1][j - 1];
            }
        }
    }
    // add 4 new edge
    res.graph[0][1] = Eps;
    res.graph[0][n - 1] = Eps;
    res.graph[n - 2][1] = Eps;
    res.graph[n - 2][n - 1] = Eps;
    //free a
    for(int i=0;i<numa;i++)
    {
        free(a.graph[i]);
    }
    free(a.graph);
    return res;
}