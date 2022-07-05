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
    
    ;mov rax,0; readシステムコール 
    xor rax,rax
    push rax
    xor rdi,rdi;mov rdi,0; stdinなので0
    mov rsi,rsp; stackの先頭 スタックのアドレスを配列のバッファとみなす
    mov rdx,1;1文字
    syscall
    pop rax; stackの先頭　raxが帰り値.
    ret ;return

printHello:
    mov rax,1
    mov rdi,1
    mov rsi,message
    mov rdx,13
    syscall
    call exit


_start:
    ;push rcx
    ;push r11
    ;call readchar
    ;pop r11
    ;pop rcx
    ;cmp byte [rax],0 ;
    ;je .end
    ;jmp .putchar

    ;mov rax,0; readシステムコール 
    xor rax,rax
    push rax
    xor rdi,rdi;mov rdi,0; stdinなので0
    mov rsi,rsp; stackの先頭 スタックのアドレスを配列のバッファとみなす
    mov rdx,1;1文字
    syscall
    pop rax; stackの先頭　raxが帰り値
    
    jmp .end

.putchar:
    mov r11,rax
    mov rsi,r11;返り値rax をrsi
    mov rax,1;writeシステムコール
    mov rdi,1;stdout
    mov rdx,1; 1byte
    syscall
    call exit

.end:
   call printHello

    
    




