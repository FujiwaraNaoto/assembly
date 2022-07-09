
section .data
    message: db "Hello World.",0x0a

section .text
    global _start


exit:
    xor rdi,rdi
    mov rax,60
    syscall

read_char:
    push 0
    xor rax,rax;read systemcall = 0
    xor rdi,rdi;stdin なので0
    mov rsi,rsp; stackの先頭アドレス
    mov rdx,1;読み取る文字数
    syscall
    pop rax;帰り値
    ret;

read_word:
    push r14
    push r15
    xor r14,r14
    mov r15,rsi
    dec r15

    .A:
    push rdi
    call read_char
    pop rdi;

    ;raxレジスタに返ってくる　その下のバイト2byteを見る
    cmp al,' ';空白文字
    je .A ;alが空文字と等しいならAへジャンプ
    cmp al,10;LF 改行コード 0x0A
    je .A
    cmp al,13;CR キャリッジリターン 0x0D
    je .A
    cmp al,9;水平タブ 0x09
    je .A
    test al,al;alのandをとる
    jz .C;ZF=1の時にCへジャンプ

    .B:
    mov byte [rdi+r14],al
    inc r14


    push rdi
    call read_char
    pop rdi
    cmp al,' ';空白文字
    je .C ;alが空文字と等しいならAへジャンプ
    cmp al,10;LF 改行コード 0x0A
    je .C
    cmp al,13;CR キャリッジリターン 0x0D
    je .C
    cmp al,9;水平タブ 0x09
    je .C
    test al,al;alのandをとる
    jz .C;ZF=1の時にCへジャンプ
    cmp r14,r15
    je .D

    jmp .B



    .C:
    mov byte [rdi+r14],0
    mov rax,rdi

    mov rdx,r14
    pop r15
    pop r14
    ret

    .D:
    xor rax,rax
    pop r15
    pop r14
    ret



_start:
    call read_word

    call exit
