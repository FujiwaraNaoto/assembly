;%%%%%%%%%%%%%%%%%%%%%%%%%%%%
; bug修正済み　r13が呼び出し元退避レジスタであることに注意
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global _start

section .data
test_string: db "abcdef", 0

section .text

strlen:
 xor r13, r13 ;0クリア
.loop:
 cmp byte [rdi+r13],0
 je .end
 inc r13
 jmp .loop
.end:
 
 mov rax,r13 ;return はratに返る
 ret
_start:
 mov rdi,test_string
 push r13
 call strlen
 mov rdi,rax
 pop r13

 ;mov rax,1
 ;xor rdi,rdi ;exit(0)

 mov rax,60
 syscall

 ;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 ; strlenの中にpush r13 と　pop r13をしてもよい つまり
 ;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;strlen:
; push r13
; xor r13, r13 ;0クリア
;.loop:
; cmp byte [rdi+r13],0
; je .end
; inc r13
; jmp .loop
;.end:
; mov rax,r13 ;return はratに返る
; pop r13
; ret

;_start:
; mov rdi test_string
; call strlen
; mov rdi,rax
; mov rax,60
; syscall