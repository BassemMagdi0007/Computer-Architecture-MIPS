# Computer-Architecture-MIPS

## Table of Contents

- [Task Description](#task-description)
- [Program Features](#program-features)
- [Code Structure](#code-structure)
- [Execution Instructions](#execution-instructions)
- [Output Format](#output-format)
- [Use Cases](#use-cases)
- [License](#license)
- 
## Task Description:
In this task, the goal is to implement a program that manages requests based on their priorities in a system. The system comprises four lists, each with a capacity of 20 elements. Requests are associated with one of four priorities (1-Critical, 2-High, 3-Medium, 4-Low). Upon arrival, a request is stored in the list with available space, starting from the first list.

## Program Features:
The program provides users with the following functionalities:

- **Search Request:** Utilize Binary Search on the lists to search for a specific request based on criteria such as request data, priority, or both.

- **Delete Requests by Priority:** Remove all requests with a specified priority.

- **Process Requests by Priority:** Process (print) all requests with a specific priority.

- **Empty All Lists:** Clear all lists, removing all stored requests.

 **Bonus:** Sort all requests through one list or all lists (Quick Sort).
 Hints: request can be any character a, b ,c ..etc, process request is printing it.

## Code Structure

- Bubble Sort Implementation:
  ---------------------------
   - **BubbleSort Function:**
       - Description: Initiates the Bubble Sort algorithm on the array.
       - Steps:
            1) Calls cleanArrayFUNCTION to prepare the array for sorting.
            2) Calculates the size of the array by dividing itr by 4 (each element is 4 bytes).
            3) Calls sortInts with the array's length and base address to perform the Bubble Sort.
               
   - **sortInts Function:**
      - Description: Implements the Bubble Sort algorithm for sorting integers.
       - Steps:
            1) Swaps adjacent elements if they are in the wrong order, iteratively going through the array until it's sorted.
            2) Updates additional arrays (arrP and arrI) to keep track of the sorting process.

- Binary Search Implementation:
  ---------------------------
   - **BinarySearch Function:**
       - Description: Prompts the user to enter a letter and then calls the binary_search function.
       - Steps:
            1) Asks for user input.
            2) Calls binary_search with the entered letter to search in the sorted array.
            3) Prints the result of the search.

   - **binary_search Function:**
       - Description: Implements the Binary Search algorithm to find a specific value in the sorted array.
       - Steps:
            1) Calls print_status to print the current search status (low and high indices).
            2) Compares the entered letter with the middle element and recursively calls itself for the left or right half.
            3) Returns the position of the letter in the array or where it would be inserted.

   - **print_status Function:**
       - Description: Prints the current status of the binary search, indicating the low and high indices of the search region.
       - Steps:
            1) Prints a string describing the current search region.
            2) Prints the low and high indices.
            3) Prints a newline for formatting.


- Additional Functions:
  ---------------------------
   - **PRINT Function:**
       - Description: Prints the elements of the array.
       - Steps:
            1) Prints each element of the array separated by spaces.
            2) Prints a newline for formatting.

   - **cleanArrayFUNCTION Function:**
       - Description: Initializes the array elements to zero.
       - Steps:
            1) Sets each element of the array to zero.


- Data Sections:
  ---------------------------
   - **Arrays:**
       - letterArr: The main array of letters to be sorted and searched.
       - arrP: An auxiliary array to keep track of the sorting process during Bubble Sort.
       - arrI: An auxiliary array to keep track of the sorting process during Bubble Sort.

   - **Strings:**
       - Strings used for printing messages and prompts.
       - arrP: An auxiliary array to keep track of the sorting process during Bubble Sort.
       - arrI: An auxiliary array to keep track of the sorting process during Bubble Sort.

## Execution Instructions:
To run the MIPS code, follow the steps outlined below:

- **Java Runtime Environment (JRE):** Ensure that the 'Java Runtime Environment' is installed on your system.
- **Mars MIPS Simulator:** Download the 'Mars MIPS simulator' from the official website.
- **Launch Mars MIPS Simulator:** Open the 'Mars.jar' file to start the Mars MIPS simulator.
- **Select Assembly File:** Load the MIPS assembly code file (with the '.asm' extension) within the Mars MIPS simulator.
- **Compile the Code:** Choose 'Run' => 'Assemble' to compile the MIPS assembly code.
- **Execute the Code:** Initiate the program execution by pressing the 'Run' button within the Mars MIPS simulator.

## Output formate

## Use Cases
- Educational Purpose:
   - Scenario: Computer science students or learners studying assembly language programming can use this project to understand and practice fundamental sorting and searching algorithms in a low-level language.

- Algorithm Understanding:
   -Scenario: Developers or researchers aiming to deepen their understanding of the Bubble Sort and Binary Search algorithms can use this project as a practical example. The code provides a clear implementation of these algorithms.

- Assembly Language Learning:
   -Scenario: Individuals who are learning MIPS Assembly language can use this project to practice writing assembly code, understanding memory management, and working with arrays.

- Demonstration of Sorting and Searching:
   -Scenario: The project can serve as a demonstration tool for illustrating how sorting and searching algorithms work. This can be used in a classroom setting or in educational tutorials to explain algorithmic concepts.

- Debugging Practice:
   -Scenario: Aspiring programmers can use this project as a means to practice debugging skills. They can introduce intentional errors into the code and then debug and correct these errors to observe the impact on sorting and searching.

- Algorithm Optimization:
   -Scenario: Software engineers interested in algorithm optimization can use this project as a starting point for experimenting with enhancements or modifications to the sorting and searching algorithms to achieve better performance.

- Hands-On Assembly Programming:
   -Scenario: Developers or hobbyists looking to gain hands-on experience with assembly programming can use this project to work on a complete and functional assembly program, implementing sorting and searching functionalities.

- Integration into Larger Systems:
   -Scenario: Sections of this code, particularly the sorting and searching algorithms, can be integrated into larger systems or applications written in higher-level languages, demonstrating how low-level assembly components can be part of a broader software architecture.

- Algorithmic Comparison:
   -Scenario: This project can be used as a foundation for comparing the performance of Bubble Sort and Binary Search against other sorting and searching algorithms. This could be part of a study or research project focusing on algorithmic efficiency.


## License 

MIT License

Copyright (c) [year] [fullname]

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
