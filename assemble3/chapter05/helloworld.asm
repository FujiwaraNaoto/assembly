global _start:

section .data
message: db 'Hello World',0 ;null文字の検知
section .text

; 第一引数rdiに入れられたメッセージを用いる
strlen:
    xor rax,rax; rax　0クリア
;
;while(*s!=0){
; cnt++;
;}
;
.loop:
    cmp byte [rdi+rax],0

    je .end ;
    inc rax
    jmp .loop
.end:
    ret ;return rax 

;Hello worldを表示
printHello:

    mov rdi,message; count_messageの第一引数
    call strlen
    mov rdx,rax; count_messageからの帰り値をrdx

    ;syscallの前
    push rbx
    push rbp
    push r12
    push r13
    push r14
    push r15
    
    

    mov rax,1;write systemcall
    mov rdi,1;stdout
    syscall

    pop r15
    pop r14
    pop r13
    pop r12
    pop rbp
    pop rbx

    ret; return 


;exit(0)
exit:
    xor rdi,rdi
    mov rax,60
    syscall


;main
_start:


    xor rcx,rcx
    mov rcx,5
.loop:
    
    ;call printHello

    push rcx;syscall でrcxは値が書き変わる
    
    ;print Hello World
    mov rax,1
    mov rsi,message
    mov rdi,1
    mov rdx,11
    syscall
    
    ;戻す
    pop rcx

    test rcx,rcx;rcx=0ならzero flag
    dec rcx
    jnz .loop; jump if not zero
    ;inc rcx
    
    
    

    call exit

