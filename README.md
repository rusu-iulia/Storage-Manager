# Storage-Manager
## Overview
Storage-Manager is a Computer System Architecture university project written in x86 assembly. It simulates file storage using memory arrays, first with a 1D array and later expanded to a 2D matrix for a more complex management. It supports adding, retrieving, deleting, and defragmenting files.

## Features 

The Storage-Manager provides the following operations:
- Add File
  - Allocates contiguous memory blocks for a file.
  - Handles memory overflow and prints an error if the array is full.
  - Prints the start and end positions of allocated blocks.

- Get File
  - Retrieves the location of a file in memory.
  - Prints the start and end positions of the file.

- Delete File 
  - Frees the memory blocks used by a file.
  - Updates the internal storage structure accordingly.
  - Prints the deleted block ranges.

- Defragmentation 
  - Moves files to eliminate gaps and free contiguous memory space.
  - Prints the rearranged memory block positions for all files.
 
## Memory Structure 

Memory is represented as a fixed-size array:
- 1D Version: v array with 1024 elements.
- 2D Version: matrice array with 1024×1024 elements (improved design).

Each element stores a file identifier or 0 if the block is free.

## How to use
1. Compile the file
2. Run the script
```
\.storage-manager
```
3. Input
- Enter the number of operations to perform.
- For each operation:
  - Enter the operation type (1=Add, 2=Get, 3=Delete, 4=Defragment).
  - Provide additional parameters as required (file number, file descriptor, file size).

4. Output
- Displays memory allocation, retrieval, deletion, and defragmentation results.

## Notes
- Designed for x86 32-bit architecture.
- Uses Linux system calls for program exit.
- A more detailed description of the assignment is found in the requirement paper.
## Conclusion 
This project demonstrates how fundamental memory management techniques can be implemented at a low level in assembly. It serves as both a learning exercise in Computer System Architecture and a practical example of assembly programming applied to system-level problems.
