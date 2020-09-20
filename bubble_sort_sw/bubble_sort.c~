#include <stdio.h>

void swap(int* lhs, int* rhs){
int tmp;
tmp = *lhs;
*lhs = *rhs;
*rhs = tmp;


}

void bubble_sort(int iarr[],int len){

    int tmp = 0;
    while(tmp < len){

        int tmp_len = len - tmp;

        for(int i = 1; i < tmp_len; ++i){
            if( iarr[i] < iarr[i-1]){
                swap(iarr + i, iarr +(i-1));

        }
        }
        ++tmp;
    }

}

int main() {

    
    int len = 10;
    int iarr[] = {3,9,5,8,7,3,2,9,12,3};

    for(int i = 0; i < len; ++i){

        printf("%d ",iarr[i]);
    }
    printf("\n");


    bubble_sort(iarr,len);

    for(int i = 0; i < len; ++i){

        printf("%d ",iarr[i]);
    }
    printf("\n");

}
