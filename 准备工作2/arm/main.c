#include <stdio.h>

int N=15;

int find_max(int nums[],int n)
{
    int max=nums[0];
    int i=1;
    int curr;
    while(i!=n){
        curr=nums[i];
        if(curr>max){
            max=curr;
        }
        else
        {
            max=max;
        }
        i++;
    }
    return max;
}

int main() {
    int numbers[10];
    for (int i = 0; i < 10; i++) {
        numbers[i]=i|((i*N)/(i+1));
    }
    int max=find_max(numbers,10);
    printf("max: %d\n", max);
    return 0;
}
