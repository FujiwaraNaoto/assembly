;for(i=5;i>0;i--){}
;5回　表示して終わる
;
;
global _start:

section .data
message: db 'Hello World',0 ;null文字の検知
section .text

;exit(0)
exit:
    xor rdi,rdi
    mov rax,60
    syscall



;main
_start:
;for i=5;i>0;i--{
; printf("Hello World");
;}
;

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
    
    
    call exit

