section .data
    message: db "Hello World.",0x0a

section .text
    global _start

;exit(0)
exit:
    xor rdi,rdi
    mov rax,60
    syscall



readchar:
    xor rax,rax; readシステムコール 
    push rax
    xor rdi,rdi;mov rdi,0; stdinなので0
    mov rsi,rsp; stackの先頭 スタックのアドレスを配列のバッファとみなす
    mov rdx,1;1文字
    syscall
    cmp byte [rax],0
    je .printHello
    pop rax
    jmp .end
    
.printHello:
    mov rax,1
    mov rdi,1
    mov rsi,message
    mov rdx,13
    syscall
    call exit

.end:
    mov rdi,rax
    mov rax,60;
    syscall


_start:
    
    call readchar

    
    




