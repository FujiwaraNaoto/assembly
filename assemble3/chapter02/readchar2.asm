;
;$echo $? で見れる
;
;
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
    
    ;mov rax,0; readシステムコール 
    xor rax,rax
    push rax
    xor rdi,rdi;mov rdi,0; stdinなので0
    mov rsi,rsp; stackの先頭 スタックのアドレスを配列のバッファとみなす
    mov rdx,1;1文字
    syscall
    pop rax; stackの先頭　raxが帰り値
    

    ;exit()の際に入れてしまう
    ;echo $?で確認可能
    mov rdi,rax
    mov rax,60
    syscall
    
    




