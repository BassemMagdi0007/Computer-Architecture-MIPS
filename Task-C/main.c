#include <stdio.h>
#include <stdlib.h>
#define MAX_ARRAY_SIZE 160
#define MAX_REQUEST_SIZE 20
#define LIST_SIZE 20
#define NUMBER_OF_LISTS 4

int nextEmptyArrIndex = 0;
int lastUpdatedIndex = -1;

int list;
int indexInList;

char temp_arr_Letters[MAX_REQUEST_SIZE];
char main_arr_Letters[MAX_ARRAY_SIZE];

int arr_priority[MAX_ARRAY_SIZE];
int arr_indices[MAX_ARRAY_SIZE];
int arr_integerFromLetters[MAX_ARRAY_SIZE];
char arr_lettersFromInteger[MAX_ARRAY_SIZE];


unsigned int cleanArray(char letterArr[], int arrP[], int arrI[])
{
    unsigned int itr= 0;

    for(int i= 0; i< nextEmptyArrIndex; i++)
    {
        ///non deleted values NON(-1, -2) in the 3 arrays copied to the 3 sort_ arrays
        if(arr_indices[i] < 0)
            continue;
        else
        {
            ///copy values
            letterArr[itr] = main_arr_Letters[i];
            arrP[itr] = arr_priority[i];
            arrI[itr] = arr_indices[i];
            itr++;
        }
    }
    return itr;
}


void printArrays()
{
    printf("\nRequests: \t");
    for(int j=0; j<nextEmptyArrIndex; j++)
    {
           printf("%c ",main_arr_Letters[j]);
    }

    printf("\nPriority: \t");
    for(int j=0; j<nextEmptyArrIndex; j++)
    {
           printf("%d ",arr_priority[j]);
    }

    printf("\nIndex: \t\t");
    for(int j=0; j<nextEmptyArrIndex; j++)
    {
           printf("%d ",arr_indices[j]);
    }
}


void swap(int *xp, int *yp)
{
    int temp = *xp;
    *xp = *yp;
    *yp = temp;
}


/* This function takes last element as pivot, places
   the pivot element at its correct position in sorted
    array, and places all smaller (smaller than pivot)
   to left of pivot and all greater elements to right
   of pivot */
int partition (int arr[], int low, int high)
{
    int pivot = arr[high];    // pivot
    int i = (low - 1);  // Index of smaller element

    for (int j = low; j <= high- 1; j++)
    {
        // If current element is smaller than the pivot
        if (arr[j] < pivot)
        {
            i++;    // increment index of smaller element
            swap(&arr[i], &arr[j]);
        }
    }
    swap(&arr[i + 1], &arr[high]);
    return (i + 1);
}


/* The main function that implements QuickSort
 arr[] --> Array to be sorted,
  low  --> Starting index,
  high  --> Ending index */
void quickSort(int arr[], int low, int high)
{
    if (low < high)
    {
        /* pi is partitioning index, arr[p] is now
           at right place */
        int pi = partition(arr, low, high);

        // Separately sort elements before
        // partition and after partition
        quickSort(arr, low, pi - 1);
        quickSort(arr, pi + 1, high);
    }
}


void bubbleSort(int arrToBeSorted[], int arr2[], int arr3[], int n)
{
    //bubbleSort is performed on arrToBeSorted
   int i, j;
   for (i = 0; i < n-1; i++)

       // Last i elements are already in place
       for (j = 0; j < n-i-1; j++)
           if (arrToBeSorted[j] > arrToBeSorted[j+1])
           {
              swap(&arrToBeSorted[j], &arrToBeSorted[j+1]);
              swap(&arr2[j], &arr2[j+1]);
              swap(&arr3[j], &arr3[j+1]);
           }
}


int binarySearch(int arr[], int first, int last, int value)
{
    while (first <= last) {
        int m = first + (last - first) / 2;

        // Check if x is present at mid
        if (arr[m] == value)
            return m;

        // If x greater, ignore left half
        if (arr[m] < value)
            first = m + 1;

        // If x is smaller, ignore right half
        else
            last = m - 1;
    }

    // if we reach here, then element was
    // not present
    return -1;
}


//smallest data type possible to hold( 1 || 2 || 3 || 4 )
void listNumber(int index)
{
	int firstIndex, lastIndex;

	for(int i = 0; i < NUMBER_OF_LISTS; i++)
	{
		firstIndex = LIST_SIZE * i ;
		lastIndex = LIST_SIZE * (i + 1);
		if(index >= firstIndex && index < lastIndex)
		{
			list = i + 1;
            indexInList = index - (LIST_SIZE * i);
			break;
		}
	}
}


void pre_post_binarySearch(int critiron, int prio, char req)
{
    char to_sort_arr_letters[MAX_ARRAY_SIZE];
    int to_sort_arr_priority[MAX_ARRAY_SIZE];
    int to_sort_arr_indices[MAX_ARRAY_SIZE];
	int to_sort_integers[MAX_ARRAY_SIZE];
    int result1, result2;
    unsigned int itr= 0;

    itr = cleanArray(to_sort_arr_letters, to_sort_arr_priority, to_sort_arr_indices);

	for (int i = 0; i < itr; i++)
	{
        //Cast and store the requests by its ascii values in to_sort_integer
		to_sort_integers[i] = (int) to_sort_arr_letters[i];
	}

    switch(critiron)
    {
        ///Binary search by letter
        case 1:
            //sort the values in the to_sort_integers & swap the rest two according to the sorted array
            //change in the same array
            //549128367
            bubbleSort(to_sort_integers, to_sort_arr_priority, to_sort_arr_indices, itr);
            //123456789
            //retrieve the index of the requested character inside the sorted array
            result1 = binarySearch(to_sort_integers, 0, itr - 1, req);
            //
            if(result1 == -1)
            {
                printf("\nElement is not present in array");
            }
            else
            {
                listNumber(to_sort_arr_indices[result1]);
                printf("The request you searched for is in List: %d at index: %d with priority: %d ", list, indexInList, to_sort_arr_priority[result1]);
            }
            break;


        ///Binary search by priority
        case 2:
            bubbleSort(to_sort_arr_priority, to_sort_integers, to_sort_arr_indices, itr);
            result2 = binarySearch(to_sort_arr_priority, 0, itr - 1, prio);

            if(result2 == -1)
            {
                printf("\nElement is not present in array");
            }
            else
            {
                listNumber(to_sort_arr_indices[result2]);
                printf("The priority you searched for is of request: %c in List: %d at index: %d ", to_sort_integers[result2], list ,indexInList);
            }

            break;
    }
}


void emptyAll()
{
   for(int i= 0; i< nextEmptyArrIndex; i++)
    {
        arr_indices[i] = -2;
        arr_priority[i] = -2;
    }

    lastUpdatedIndex = -1;
    printf("All requests were successfully deleted");
}


void process(int search_priority, int arr_priority[], char main_arr_Letters[], int arr_indices[])
{

    for(int i= 0; i< nextEmptyArrIndex; i++)
    {
        if(arr_priority[i] == search_priority)
        {
			///check which list was printed from
			listNumber(arr_indices[i]);

			printf("\nrequest: %c\t list: %d\t index: %d\t ", main_arr_Letters[i], list, indexInList);
        }
    }
}


void update_indices(int arr_indices[])
{
    int update_val= 0;
    int backwardIndex= nextEmptyArrIndex-1;

    for(int i= 0; i< nextEmptyArrIndex; i++)
    {
        if(arr_indices[i] == -1)
        {
            update_val--;
			arr_indices[i] = -2;
            continue;
        }

        ///History of deleted operations
        if(arr_indices[i] == -2)
        {
            continue;
        }

        arr_indices[i] = arr_indices[i] + update_val;
    }
	//Find first non-negative index going backwards

	int i;
	for(i = nextEmptyArrIndex-1; i >= 0; i--)
	{
		if(arr_indices[i] < 0) {
			continue;
		}
		else{
			lastUpdatedIndex = arr_indices[i];
			return;
		}
	}
	//List is empty
	if(i == -1)
	{
		lastUpdatedIndex = -1;
	}
}


void deleteByPriority(int del_priority,int arr_indices[], int arr_priority[])
{
    int deletePerformed = 0;
    for(int i= 0; i< nextEmptyArrIndex; i++)
    {
        if(del_priority == arr_priority[i])
        {
            arr_indices[i] = -1;
            arr_priority[i] = -1;
            deletePerformed = 1;
        }
    }
    if(deletePerformed)
    {
        update_indices(arr_indices);
    }
}


void pre_post_QuickSort(int low)
{
    char quickSort_letters[MAX_ARRAY_SIZE ];
    int quickSort_priority[MAX_ARRAY_SIZE ];
    int quickSort_indices[MAX_ARRAY_SIZE ];
	int quickSort_Integers[MAX_ARRAY_SIZE];
    int high;

    unsigned int itr_QuickSort= 0;

    //update quickSort_letters to carry non-deleted characters, return itr_QuickSort = 0.
    itr_QuickSort = cleanArray(quickSort_letters, quickSort_priority, quickSort_indices);
    (itr_QuickSort-low) > 20 ? (high = low + 20) : (high = itr_QuickSort);

    printf("\nList %d Before QuickSort\n", (low/20)+1);
    for(int i= low; i < high; i++)
    {
        printf("%c ", quickSort_letters[i]);
    }
    printf("\n");

    //apply quick sort
	for (int i = 0; i < itr_QuickSort; i++)
	{
		quickSort_Integers[i] = (int) quickSort_letters[i];
	}
    quickSort(quickSort_Integers, low, high-1);

    printf("\nList %d After QuickSort\n", (low/20)+1);
    for(int i= low; i < high; i++)
    {
        printf("%c ", quickSort_Integers[i]);
    }
	printf("\n=========================================\n");
}


int main()
{
    int ListChoice;
    int requestPriority;
    int requestSize;
    int del_priority;
    int search_priority;
    int pr;
    int listScan;
    char ch;

    do
    {
        printf("\n                  _______________________________________________________________\n");
        printf("                                1. Insert request\n");
        printf("                                2. Delete all requests with specific priority\n");
        printf("                                3. Process all requests with specific priority\n");
        printf("                                4. Empty all lists\n");
        printf("                                5. Binary Search by request\n");
        printf("                                6. Binary Search by priority\n");
        printf("                                7. Quick Sort list(s)\n");
        printf("                                9. Exit\n");
        printf("                  _______________________________________________________________\n");
        printf("                  _______________________________________________________________\n");

        printf("Enter Your Choice : ");
        scanf("%d", &ListChoice);

    switch(ListChoice)
    {
        ///insert
        case 1:

            printf("Enter size of request (max 5): \n");
            scanf("%d", &requestSize);


            printf("Enter request: \n");
            scanf("%s", temp_arr_Letters);
            //TODO
            //insert_check(temp_arr_Letters)

            printf("Enter request priority: \n");
            scanf("%d", &requestPriority);
            //TODO
            //priority must be only 1 2 3 4

            for(int i=0; i <requestSize; i++)
            {
               // printf("%d   %c\n ", i, temp_arr_Letters[i]);
                ///append from tempArr to mainArr
                main_arr_Letters[ nextEmptyArrIndex ] = temp_arr_Letters[i];

                ///fill in arr_priority with the given requestPriority
                arr_priority[ nextEmptyArrIndex ] = requestPriority;

                ///fill in arr_indices according to nextEmptyArrIndex
                arr_indices[ nextEmptyArrIndex ] = ++lastUpdatedIndex;

                nextEmptyArrIndex ++;
            }

            ///print main arrays
            printArrays();
            break;


        case 2:
            printf("Delete request(s) with the following priority: \n");
            scanf("%d", &del_priority);

            deleteByPriority(del_priority, arr_indices, arr_priority);
            ///print main arrays
            printArrays();


            break;

        case 3:
               printf("pre_post_binarySearch request(s) given the following priority: \n");
               scanf("%d", &search_priority);

               process(search_priority, arr_priority, main_arr_Letters, arr_indices);
            break;

        case 4:
            emptyAll();
            break;

        case 5:

            printf("Enter character to search for: ");
            //fflush(stdin);
            scanf("\n%c", &ch);

            pre_post_binarySearch(1, 0, ch);

            break;

        case 6:

            printf("Enter priority to search for: \n");
            scanf("%d", &pr);

            pre_post_binarySearch(2, pr, '\0');

            break;

        case 7:
            printf("\n1-QuickSort first List \n2-QuickSort second List \n3-QuickSort third List \n4-QuickSort fourth List \n5-QuickSort all Lists \n\nChoice: ");
            scanf("%d", &listScan);

			if(listScan >= 1 && listScan<=4)
			{
				printf("\nQuickSort of list %d\n", listScan);
                pre_post_QuickSort(0);
			}
			else if (listScan == 5)
			{
				int loop;
				loop = ((nextEmptyArrIndex - 1) / 20);
				for(int i = -1; i < loop; i++)
				{
					pre_post_QuickSort(LIST_SIZE * (i+1));
				}

			}
        }

    }while(ListChoice!=9);

  return 0;
}
