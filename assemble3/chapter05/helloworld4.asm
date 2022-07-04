;printf
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

;第一引数rdiに文字列を受け取ったところからはじまる
printf:

    push rdi;
    push rcx;    
    push r11;r11とrcxはシステムコールで上書きされるため

    mov rdi, message
    call strlen
    mov rdx,rax;返り値 文字数
    mov rax,1;write
    mov rsi,rdi;message
    mov rdi,1;stdout
    syscall
    pop r11;
    pop rcx;
    pop rdi;
    
    ret;


;main
_start:


    xor rcx,rcx;rcxを0クリア
    
.loop:
    
    inc rcx
    ;call printHello

   
    ;print Hello World
    mov rdi,message; rdi(第一引数)にHelloWorldのありかを教える
    call printf

    cmp rcx,5;rcx=5ならzero flag 
    ;inc rcx;cmpの直後にjmp関係の命令を持ってこなければ失敗するみたい
    jne .loop ;rcx!=5のとき
    jz .end

.end:
    call exit

