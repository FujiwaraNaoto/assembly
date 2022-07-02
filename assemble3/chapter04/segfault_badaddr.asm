section .data
correct: dq -1
section .text

global _start
_start:
    mov rax,[0x400000-1];access 0x3fffff
    ;exit
    mov rax,60
    xor rdi,rdi
    syscall