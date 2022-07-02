
%define O_RDONLY 0
%define PROT_READ 0x1
%define MAP_PRIVATE 0x02

section .data
; file name
fname: db 'test.txt',0

section .text
global _start

;null で終結した文字列をプリントする際に用いる
print_string:
    push rdi
    call string_length
    pop rsi
    mov rdx,rax
    mov rax,1
    mov rdi,1
    syscall
    ret

string_length:
    xor rax,rax
.loop:
    cmp byte [rdi+rax],0
    je .end
    inc rax
    jmp .loop
.end:
    ret

_start:
;call open
mov rax,2
mov rdi, fname
mov rsi,O_RDONLY ;modeを選択
mov rdx,0
syscall 

;call mmap
mov r8,rax

mov rax,9 ;mmap system call
mov rdi,0
mov rsi,1024
mov rdx,PROT_READ ;新しいメモリ領域はread only
mov r10,MAP_PRIVATE; pageの共有無し
  
mov r9,0 
syscall

mov rdi,rax
call print_string

;exit system call
mov rax,60
xor rdi,rdi
syscall