    # Add comments to this file
from typing import List, TypeVar

T = TypeVar('T')

'''
time complexity : O(N^2) worst case 
time complexity : O(N) best cases
worst case : descending order list
best case : ascending order list

What the code is doing :
At any given point of the while loop
the list will have 2 of the same elements
next to each other

at at the end of the while loop, 
the j will point to the smallest element
where key will be stored at 
'''

def insertion_sort(the_list: List[T]):
    length = len(the_list)
    for i in range(1, length):
        key = the_list[i]                   # this gets the value at index i
        j = i-1                             # j is the value before i
        while j >= 0 and key < the_list[j]: # as long as the element before is greater then equal 0
                                            # and the current element selected by j is lesser then before
            the_list[j + 1] = the_list[j]   # change the next element to be the same as the current element
            j -= 1                          # subtract one cause, need to continue to check if
                                            # the previous element was bigger then the current element
        the_list[j + 1] = key               # the smaller number stored at where the j is


def main() -> None:
    arr = [6, -2, 7, 4, -10]
    insertion_sort(arr)
    for i in range(len(arr)):
        print(arr[i], end=" ")
    print()


main()