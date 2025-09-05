.data
operation_number: .long 0
operation_type: .long 0
file_number: .long 0
file_descriptor: .long 0
file_size: .long 0
startx:  .long 0
starty:  .long 0
endx:    .long 0
endy:    .long 0
blocuri: .long 0
matrice: .space 4194304 
defrag_copy: .long 0        
formatScanf: .asciz "%d"
formatOutput1: .asciz "%d: ((%d, %d), (%d, %d))\n"
formatOutput2: .asciz "((%d, %d), (%d, %d))\n"
formatError: .asciz "%d: ((0, 0), (0, 0))\n"
.text
add_function:
    push %ebp
    mov %esp, %ebp
    push %ebx
    push %esi
    push %edi
    push %eax
    push %ecx

    lea matrice, %edi
    mov 8(%ebp), %ecx
    cmp $8192, %ecx
    jg print_eroare
    movl %ecx, blocuri
    addl $7, blocuri
    shrl $3, blocuri

    xor %ecx, %ecx #i=0
for_linii_1:
    cmp $1024, %ecx
    je if_linii

    xor %esi, %esi #k=0
    xor %edx, %edx #j=0
    for_coloane_1:
        cmp $1024, %edx
        je cont_for_linii_1

        mov %ecx, %eax
        shl $10, %eax
        add %edx, %eax
        movl (%edi, %eax, 4), %ebx

        cmp $0, %ebx
        je if_1

        xor %esi, %esi

        inc %edx
        jmp for_coloane_1

    if_1:
        inc %esi
        inc %edx

        cmp blocuri, %esi
        jge if_3
        cmp $1024, %esi
        je if_3
    jmp for_coloane_1

cont_for_linii_1:
    inc %ecx
    jmp for_linii_1

    if_linii:
        cmp blocuri, %esi
        jge if_3
        jmp else

if_3:
    mov %edx, endy
    mov %ecx, startx
    subl blocuri, %edx
    mov %edx, starty
    xor %esi, %esi  #b=0
    jmp for_3

    for_3:
        cmp blocuri, %esi
        jge add_print

        mov %ecx, %eax
        shl $10, %eax
        add %edx, %eax
        movl (%edi, %eax, 4), %ebx
        mov 12(%ebp), %ebx
        mov %ebx, (%edi, %eax, 4)

        inc %edx
        inc %esi
        jmp for_3

else:
    inc %ecx
    xor %edx, %edx
    movl %ecx, startx
    movl %edx, starty
    xor %esi, %esi  
    jmp for_4

    for_4:
        cmp blocuri, %esi
        jg add_print

        mov %ecx, %eax
        shl $10, %eax
        add %edx, %eax
        movl (%edi, %eax, 4), %ebx
        mov 12(%ebp), %ebx
        mov %ebx, (%edi, %eax, 4)

        inc %edx
        inc %esi
        jmp for_4

add_print:
    mov %ecx, endx
    dec %edx
    mov %edx, endy

    cmp $-1, %edx
    je if_special

    jmp print
if_special:
    movl $1023, endy
    decl endx
    jmp print

print_eroare:
    push file_descriptor
    push $formatError
    call printf
    add $8, %esp

    jmp add_finish
print:
    pushl endy
    pushl endx
    pushl starty
    pushl startx
    push file_descriptor
    push $formatOutput1
    call printf
    add $24, %esp

add_finish:
    pop %ecx
    pop %eax
    pop %edi
    pop %esi
    pop %ebx
    pop %ebp
    ret
get_function:
    push %ebp
    mov %esp, %ebp
    push %ebx
    push %esi
    push %edi
    push %eax
    push %ecx

    lea matrice, %edi

    movl $0, startx
    movl $0, starty
    movl $0, endx
    movl $0, endy
    xor %ecx, %ecx #i=0
    mov $-1, %edx

while_get_1:
    cmp $1023, %ecx
    je print_get

    inc %edx

    mov %ecx, %eax
    shl $10, %eax
    add %edx, %eax
    movl (%edi, %eax, 4), %ebx  

    cmp 8(%ebp), %ebx
    je before_while_get_2

    cmp $1023, %edx
    je linie_noua

    jmp while_get_1

linie_noua:
    mov $-1, %edx
    inc %ecx
    jmp while_get_1

before_while_get_2:
    movl %ecx, startx
    movl %ecx, endx
    movl %edx, starty
    movl %edx, endy
    jmp while_get_2
while_get_2:
    movl endx, %eax
    shll $10, %eax
    addl endy, %eax
    movl (%edi, %eax, 4), %ebx

    cmp 8(%ebp), %ebx
    jne  break_while_2

    incl endy
    movl endy, %esi
    cmp $1023, %esi
    je if_get

    jmp while_get_2

if_get:
    incl endx
    xor %esi, %esi
    movl %esi, endy
    jmp while_get_2

break_while_2:
    decl endy;
    jmp print_get

print_get:
    pushl endy
    pushl endx
    pushl starty
    pushl startx
    push $formatOutput2
    call printf
    add $20, %esp

get_finish:
    pop %ecx
    pop %eax
    pop %edi
    pop %esi
    pop %ebx
    pop %ebp
    ret
delete_function:
    push %ebp
    mov %esp, %ebp
    push %ebx
    push %esi
    push %edi
    push %eax
    push %ecx

    lea matrice, %edi
    xor %ecx, %ecx #i=0

for_delete_1:
    cmp $1024, %ecx
    je before_for_2

    xor %edx, %edx  #j=0
    for_coloane_delete_1:
        cmp $1024, %edx
        je cont_for_linii_2

        mov %ecx, %eax
        shl $10, %eax
        add %edx, %eax
        movl (%edi, %eax, 4), %ebx

        cmp 8(%ebp), %ebx
        je if_delete_1

        inc %edx
        jmp for_coloane_delete_1
    
    if_delete_1:
        xor %ebx, %ebx
        mov %ebx, (%edi,%eax, 4)
        inc %edx
        jmp for_coloane_delete_1

    cont_for_linii_2:
        inc %ecx
        jmp for_delete_1
    
before_for_2:
    xor %ecx, %ecx
for_delete_2:
    cmp $1024, %ecx
    je done_finish
    mov %ecx, startx   #startx=i

    xor %edx, %edx  #j=0
    for_coloane_delete_2:
        cmp $1024, %edx
        je cont_for_linii_3

        mov %ecx, endx  #endx=i

        movl startx, %eax
        shl $10, %eax
        add %edx, %eax
        movl (%edi, %eax, 4), %ebx

        cmp $0, %ebx
        jne if_delete_2

        inc %edx
        jmp for_coloane_delete_2
    
    if_delete_2:
        movl %edx, starty
        movl %edx, endy

        jmp while_delete

    while_delete:
        movl endx, %eax
        shl $10, %eax
        addl endy, %eax
        movl (%edi, %eax, 4), %ebx

        movl endx, %eax
        shl $10, %eax
        addl starty, %eax
        movl (%edi, %eax, 4), %esi

        cmp $0, %ebx
        je print_delete

        cmp %ebx, %esi
        jne print_delete

        movl endy, %esi
        cmp $1024, %esi
        je print_delete

        incl endy
        jmp while_delete

    print_delete:
        decl endy

        pushl endy
        pushl endx
        pushl starty
        pushl startx
        push %esi
        push $formatOutput1
        call printf
        add $24, %esp

        movl startx, %ecx
        movl endy, %edx
        inc %edx
        jmp for_coloane_delete_2

    cont_for_linii_3:
        inc %ecx
        jmp for_delete_2
done_finish:
    pop %ecx
    pop %eax
    pop %edi
    pop %esi
    pop %ebx
    pop %ebp
    ret
defragmentation_function:
    push %ebp
    mov %esp, %ebp
    push %ebx
    push %esi
    push %edi
    push %eax
    push %ecx

    lea matrice, %edi
    xor %ecx, %ecx #i=0

for_linii_defrag_1:
    cmp $1024, %ecx
    je before_for_defrag

    xor %edx, %edx # j=0
    xor %esi, %esi #k=0

    for_coloane_defrag_1:
    cmp $1024, %esi
    je while_defrag

    mov %ecx, %eax
    shl $10, %eax
    add %esi, %eax
    movl (%edi, %eax, 4), %ebx  #matrice[i][k]
    mov %eax, defrag_copy

    cmp $0, %ebx
    jne if_defrag_1

    inc %esi
    jmp for_coloane_defrag_1

if_defrag_1:
    mov %ecx, %eax
    shl $10, %eax
    add %edx, %eax   #matrice[i][j]
    mov %ebx, (%edi, %eax, 4)

    cmp %edx, %esi
    jne if_defrag_2

    inc %edx
    inc %esi
    jmp for_coloane_defrag_1

    if_defrag_2:
        xor %ebx, %ebx
        movl defrag_copy, %eax
        mov %ebx, (%edi, %eax, 4)

        inc %edx
        inc %esi
        jmp for_coloane_defrag_1

    while_defrag:
        cmp $1024, %edx
        je cont_for_linii_defrag

        mov %ecx, %eax
        shl $10, %eax
        add %edx, %eax   #matrice[i][j]
        mov (%edi, %eax, 4), %ebx
        xor %ebx, %ebx
        mov %ebx, (%edi, %eax, 4)

        inc %edx
        jmp while_defrag
    
cont_for_linii_defrag:
    inc %ecx
    jmp for_linii_defrag_1

before_for_defrag:
    xor %ecx, %ecx
    jmp for_defrag_2

for_defrag_2:
    cmp $1024, %ecx
    je defrag_finish

    mov $-1, %edx
    mov %edx, startx
    mov %edx, starty
    mov %edx, endx
    mov %edx, endy

    movl startx, %esi
    xor %edx, %edx #j=0
    for_coloane_defrag_2:
        cmp $1023, %edx
        je cont_for_linii_defrag_2

        mov %ecx, %eax
        shl $10, %eax
        add %edx, %eax   #matrice[i][j]
        mov (%edi, %eax, 4), %ebx

        cmp 4(%edi, %eax, 4), %ebx
        jne print_defrag_1

        cmp $0, %ebx
        jne if_defrag_3

        cmp $-1, %esi
        jne print_defrag_1

        inc %edx
        jmp for_coloane_defrag_2

    if_defrag_3:
        cmp $-1, %esi
        je start
        mov %ecx, endx
        mov %edx, endy
        inc %edx
        jmp for_coloane_defrag_2

    start:
        mov %ecx, startx
        mov %edx, starty
        movl startx, %esi
        inc %edx
        jmp for_coloane_defrag_2

    print_defrag_1:
        incl endy
        pushl endy
        pushl endx
        pushl starty
        pushl startx
        push %ebx
        push $formatOutput1
        call printf
        add $24, %esp

        movl endy, %edx
        movl startx, %ecx

        mov $-1, %esi
        mov %esi, startx
        mov %esi, starty
        mov %esi, endx
        mov %esi, endy

        inc %edx
        jmp for_coloane_defrag_2

cont_for_linii_defrag_2:
    inc %ecx
    mov startx, %esi
    cmp $-1, %esi
    jne print_defrag_2
    jmp for_defrag_2

print_defrag_2:
    pushl endy
    pushl endx
    pushl starty
    pushl startx
    push %ebx
    push $formatOutput1
    call printf
    add $24, %esp

    movl endx, %ecx
    inc %ecx
    jmp for_defrag_2

defrag_finish:
    pop %ecx
    pop %eax
    pop %edi
    pop %esi
    pop %ebx
    pop %ebp
    ret
.global main
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