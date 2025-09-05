.data
operation_number: .long 0
operation_type: .long 0
file_number: .long 0
file_descriptor: .long 0
file_size: .long 0
add_ecx_copy: .long 0
delete_ecx_copy: .long 0
defrag_ecx_copy: .long 0
v: .space 4096
needed_slots: .long 0           
zero_count: .long 0                  
inceput: .long -1                    
sfarsit: .long -1                 
formatScanf: .asciz "%d"
formatOutput1: .asciz "%d: (%d, %d)\n"
formatOutput2: .asciz "(%d, %d)\n"
formatError: .asciz "%d: (0, 0)\n"
.text
.global main
add_function:
    push %ebp
    mov %esp, %ebp
    push %ebx
    push %esi
    push %edi

    lea v, %edi
    xor %ecx, %ecx                        

    mov 8(%ebp), %ebx                  
    add $7, %ebx                 
    shr $3, %ebx                        
    movl %ebx, needed_slots         

    cmp $8192, %edx
    jge array_full
while_array:
    cmp $1024, %ecx                     
    jge array_full

    mov (%edi,%ecx,4), %eax                
    cmpl $0, %eax                        
    je found_zero_start

    inc %ecx                            
    jmp while_array
found_zero_start:
    mov %ecx, inceput                  
    movl $0, zero_count
    jmp count_zeros
count_zeros:
    cmp $1024, %ecx                    
    jge check_needed_slots

    mov (%edi,%ecx,4), %eax                
    cmp $0, %eax                        
    jne check_needed_slots

    addl $1, zero_count                      
    inc %ecx                            
    jmp count_zeros
check_needed_slots:
    mov zero_count, %eax                
    cmp needed_slots, %eax             
    jl while_array

    mov inceput, %eax                   # inceput + needed_slots - 1
    mov needed_slots, %edx
    add %edx, %eax
    dec %eax                            # sfarsit = inceput + needed_slots - 1
    mov %eax, sfarsit

    mov 12(%ebp), %edi                   
    mov inceput, %eax                   
fill_sequence:
    cmp sfarsit, %eax                   # while (k <= sfarsit)
    jg print_output

    mov %edi, v(,%eax,4)                # v[k] = id
    inc %eax                            # k++
    jmp fill_sequence
print_output:
    push sfarsit                        # Push sfarsit
    push inceput                        # Push inceput
    push 12(%ebp)                        # Push id && v[i] != 0
    push $formatOutput1                  # Push format string
    call printf
    add $16, %esp                       # Clean up the stack
    jmp done
array_full:
    push file_descriptor
    push $formatError                   # Push format string
    call printf
    addl $8, %esp                       # Clean up the stack
done:
    pop %edi
    pop %esi
    pop %ebx
    pop %ebp
    ret

get_function:
    push %ebp
    mov %esp, %ebp    # 8(%ebp) = id

    cmp $-1, %eax
    je end_get

    lea v, %edi
    push %edx
    push %eax
    push %ecx

    xor %ebx, %ebx  #inceput=0
    xor %esi, %esi  # sfarsit=0
    xor %edx, %edx  #i=0
while_get_1:
    cmp $1024, %edx          # if (i >= 500)
    jge print                 # Exit loop if i >= 500

    mov (%edi, %edx, 4), %eax     # Load v[i] into eax
    cmp 8(%ebp), %eax                # if (v[i] == id)
    je found_first_id
    inc %edx
    jmp while_get_1             # Skip if v[i] != id
found_first_id:
    mov %edx, %ebx
    jmp find_last_id
find_last_id:
    mov %edx, %esi 

    inc %edx
    mov (%edi, %edx, 4), %eax     # Load v[i] into eax

    cmp 8(%ebp), %eax                # if (v[i] != id)
    jne print         # Exit inner loop if v[i] != id

    inc %esi               # sfarsit++
    jmp find_last_id             # Repeat inner loop
print:
    push %esi                  # Push sfarsit
    push %ebx                  # Push inceput
    push $formatOutput2        
    call printf                   # Print result
    add $12, %esp                 # Clean up stack

    jmp end_get
end_get:
    mov $1, %eax
    pop %ecx
    pop %eax
    pop %edx
    pop %ebp

    ret   
                        
delete_function:
    push %ebp
    mov %esp, %ebp

    lea v, %edi                    
    push %ecx                      
    push %eax
    push %edx
    push %ebx

    xor %ecx, %ecx    #     i=0
    mov $-1, %ebx   #inceput=-1
delete_for_1:
    cmp $1024, %ecx
    jge before_delete_for

    mov (%edi,%ecx,4), %edx
    cmp 8(%ebp), %edx
    je found_delete_id
    inc %ecx
    jmp delete_for_1
found_delete_id:
    movl $0, (%edi, %ecx, 4)
    inc %ecx
    jmp delete_for_1
before_delete_for:
    xor %ecx, %ecx   # i=0
delete_for_2:
    cmp $1024, %ecx
    jge delete_done

    mov (%edi,%ecx,4), %edx
    cmp $0, %edx
    jne delete_if_1

    inc %ecx
    jmp delete_for_2
delete_if_1:
    cmp $-1, %ebx
    jne delete_if_2
    mov %ecx, %ebx
    jmp delete_if_2
delete_if_2:
    inc %ecx
    cmp %edx, (%edi, %ecx, 4)
    je delete_for_2
    cmp $1023, %ecx
    je print_delete

    jmp print_delete
print_delete:
    mov %ecx, delete_ecx_copy
    
    dec %ecx
    push %ecx
    push %ebx
    push %edx
    push $formatOutput1
    call printf
    add $16, %esp

    mov delete_ecx_copy, %ecx
    #inc %ecx
    mov $-1, %ebx
    jmp delete_for_2
alt_print:
    mov %ecx, delete_ecx_copy
    
    dec %ecx
    push %ecx
    push %ebx
    push %edx
    push $formatOutput1
    call printf
    add $16, %esp

    mov delete_ecx_copy, %ecx
    #inc %ecx
    mov $-1, %ebx
    jmp delete_for_2
delete_done:
    pop %ebx    
    pop %edx
    pop %eax
    pop %ecx                  
    pop %ebp
    ret

defragmentation_function:
    push %ebp
    mov %esp, %ebp

    lea v, %edi                    
    push %ecx                      
    push %eax
    push %edx
    push %ebx

    xor %ecx, %ecx  #i=0
    xor %edx, %edx  #j=0
    xor %ebx, %ebx  #inceput=0
    xor %esi, %esi 
while_defrag_1:
    cmp $1023, %ecx
    jg while_defrag_2

    mov (%edi, %ecx, 4), %esi
    cmp $0, %esi
    jne if_defrag_1

    inc %ecx
    jmp while_defrag_1
if_defrag_1:
    mov %esi, (%edi, %edx, 4)

    inc %edx
    inc %ecx
    jmp while_defrag_1
while_defrag_2:
    cmp %ecx, %edx
    jg before_for_defrag

    movl $0, (%edi, %edx, 4)

    inc %edx
    jmp while_defrag_2
before_for_defrag:
    xor %ecx, %ecx
    xor %edx, %edx
for_defrag:
    cmp $1024, %ecx
    jge defrag_done

    mov (%edi, %ecx, 4), %esi
    mov 4(%edi, %ecx,4), %edx

    cmp %esi, %edx
    jne second_if

    inc %ecx
    jmp for_defrag
second_if:
    cmp $0, %esi
    jne print_defrag
    cmp  $1023, %ecx
    je print_defrag
    inc %ecx
    jmp for_defrag
print_defrag:
    mov %ecx, defrag_ecx_copy
    push %ecx
    push %ebx
    push %esi
    push $formatOutput1
    call printf
    add $16, %esp

    mov defrag_ecx_copy, %ecx
    inc %ecx
    mov %ecx, %ebx
    jmp for_defrag
defrag_done:
    pop %ebx    
    pop %edx
    pop %eax
    pop %ecx                  
    pop %ebp
    ret
main:
    push $operation_number
    push $formatScanf
    call scanf
    add $8, %esp
scan_new_operation:
    mov operation_number, %ecx
    cmp $0, %ecx
    je et_exit

    push $operation_type
    push $formatScanf
    call scanf
    add $8, %esp

    mov operation_type, %ebx
    cmp $1, %ebx
    je add

    cmp $2, %ebx
    je get

    cmp $3, %ebx
    je delete

    cmp $4, %ebx
    je defragmentation

    jmp scan_new_operation
add:
    push $file_number
    push $formatScanf
    call scanf
    add $8, %esp
add_loop:
    mov file_number, %esi
    cmp $0, %esi
    je done_add

    push $file_descriptor
    push $formatScanf
    call scanf
    add $8, %esp

    push $file_size
    push $formatScanf
    call scanf
    add $8, %esp

    push file_descriptor
    push file_size
    call add_function
    add $8, %esp

    mov file_number, %esi
    dec %esi
    mov %esi, file_number
    jmp add_loop
done_add:
    mov operation_number, %ecx
    dec %ecx
    mov %ecx, operation_number
    jmp scan_new_operation
get:
    push $file_descriptor
    push $formatScanf
    call scanf
    add $8, %esp

    push file_descriptor
    call get_function
    add $4, %esp
     
    mov operation_number, %ecx
    dec %ecx
    mov %ecx, operation_number
    jmp scan_new_operation
delete:
    push $file_descriptor
    push $formatScanf
    call scanf
    add $8, %esp

    push file_descriptor
    call delete_function
    add $4, %esp
     
    mov operation_number, %ecx
    dec %ecx
    mov %ecx, operation_number
    jmp scan_new_operation
defragmentation:
    call defragmentation_function

    mov operation_number, %ecx
    dec %ecx
    mov %ecx, operation_number
    jmp scan_new_operation
et_exit:
    pushl $0
    call fflush
    popl %eax
    
    movl $1, %eax
    xorl %ebx, %ebx
    int $0x80
