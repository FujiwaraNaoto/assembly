section .data

demo1:dq 0x1122334455667788
demo2: db 0x11,0x22,0x33,0x44,0x55,0x66,0x77,0x88

newline_char: db 10
codes: db '0123456789abcdef'

section .text
global _start

print_newline:
 mov rax,1 ;writeシステムコール
 mov rdi,1 ;stdoutのディスクリプタ
 mov rsi,newline_char ;書き込むデータ場所
 mov rdx,1 ;書き込むバイト数
 syscall 
 ret

print_hex:
 mov rax,rdi
 mov rdi,1
 mov rdx,1
 mov rcx,64

iterate:
 push rax ;raxレジスタの値を対比
 sub rcx,4;
 sar rax,cl;raxをclbit分右に回転シフト

 and rax,0xf
 lea rsi,[codes+rax] ;16進文字コードを取得

 mov rax,1;'write'システムコール

 push rcx;syscall のための対比
 syscall
 pop rcx; rcxの復元
 pop rax; raxの値を復元
 test rcx,rcx;　rcx=0なら全部の桁を表示した
 jnz iterate

 ret

_start:
 mov rdi,[demo1]
 call print_hex
 call print_newline

 mov rdi,[demo2]
 call print_hex
 call print_newline

 mov rax,60
 xor rdi,rdi
 syscall









