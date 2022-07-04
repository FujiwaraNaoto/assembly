;文字列を自分でカウントするプログラム
;表示する.
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


;文字列長さを数える
strlen:
    xor rcx,rcx;rcxレジスタを0クリア カウントに利用


.loop:
    
    cmp byte [rdi+rcx],0;null文字との比較
    je .end

    inc rcx
    jmp .loop


.end:
    mov rax,rcx;
    ret ;return


;main
_start:


    xor rcx,rcx;rcxを0クリア
    
.loop:
    
    inc rcx
    ;call printHello

   
    ;print Hello World
    mov rdi,message; rdi(第一引数)にHelloWorldのありかを教える
    push rcx; str_lenで使われるので
    call strlen;Hell worldの文字数
    mov rdx,rax;//return をrcxに返す.
    pop rcx
    mov rax,1; write
    mov rsi,message
    mov rdi,1;stdout
    
    push rcx;syscall でrcxは値が書き変わる
    syscall;print hello world
    pop rcx;戻す


    cmp rcx,5;rcx=5ならzero flag 
    ;inc rcx;cmpの直後にjmp関係の命令を持ってこなければ失敗するみたい
    jne .loop ;rcx!=5のとき
    jz .end

.end:
    call exit

