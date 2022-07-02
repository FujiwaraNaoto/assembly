;　for (i=1;i<=5;i++){}
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


    ;xor rcx,rcx
    mov rcx,0
.loop:
    
    inc rcx
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


    cmp rcx,5;rcx=5ならzero flag 
    ;inc rcx;cmpの直後にjmp関係の命令を持ってこなければ失敗するみたい
    jne .loop ;rcx!=5のとき
    jz .end

.end:
    call exit

