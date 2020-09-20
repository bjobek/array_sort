#include <stdio.h>
#include <sys/time.h>

static const int length = 10;
#define NANO_SECONDS 1000000000

void print_list(int list[])
{
    printf("\t");
    for(int i = 0; i < length; i++)
    {
        printf("%d ", list[i]);
    }
    printf("\n");
}

void swap_int(int* i1, int* i2)
{
    int tmp = *i1;
    *i1 = *i2;
    *i2 = tmp;
}

void selection_sort(int list[])
{
    for(int i = 0; i < length-1; i++)
    {
        int min = i;

        for(int j = i+1; j < length; j++)
        {
            if(list[j] < list[min])
            {
                min = j;
            }
        }
        swap_int(&list[i], &list[min]);
    }
}

int main()
{
    // Start measuring time
    struct timeval begin, end;
    gettimeofday(&begin, 0);

    int list[] = {3, 7, 1, 3, 6, 4, 8, 9, 20, 2};

    printf("Unsorted list: ");
    print_list(list);
    selection_sort(list);
    printf("Sorted list: ");
    print_list(list);

    // Stop measuring time and calculate the elapsed time
    gettimeofday(&end, 0);
    long seconds = end.tv_sec - begin.tv_sec;
    long microseconds = end.tv_usec - begin.tv_usec;
    double elapsed = seconds + microseconds*1e-6;
    
    printf("Time measured: %.0f ns (%.7f s)\n", elapsed*NANO_SECONDS, elapsed);
    
    return 0;
}
