section .data
codes:
    db '0123456789ABCDEF'
section .text
global _start
_start:
    ;この 1122... という数字は16進数表記
    mov rax,0x1122334455667788

    mov rdi,1
    mov rdx,1
    mov rcx,64

.loop:
    push rax
    sub rcx,4
    ;cl is register
    ; rax>eax>ax=ah+al
    ; rcx>ecx>cx=ch+cl
    sar rax,cl
    and rax,0xf

    lea rsi,[codes + rax]
    mov rax,1

    ;syscall 
    push rcx;rcxの値を退避
    syscall
    pop rcx;複元

    pop rax
    ; test 0 かをチェック
    test rcx,rcx
    jnz .loop

    mov rax,60
    xor rdi,rdi
    syscall