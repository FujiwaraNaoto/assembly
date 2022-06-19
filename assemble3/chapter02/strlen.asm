;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;文字列長を調べるアセンブリ
;
; 実行後に echo $? 　を入力
;
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global _start

section .data

test_string: db "abcdef",0

section .text

strlen: ;この関数はただ一つの引数をrdiから受け取る(そのように我々が決めた)
        ; 第一引数がrdiになるのはもともとそういう使用 
 xor rax,rax ;raxに文字列の長さが入る　最初に0で初期化しなければランダムな値になる故

.loop: ;ここから関数strlenのメインループ
 cmp byte [rdi+rax],0;現在の文字（もしくは記号）がヌルかどうかを調べる
 ;ここでは必ずbyteが必要　というのもcmpは左右のオペランドで同じサイズを比較
 ; メモリから何バイト取り出して0と比較するか　byteがなければ不明だから

 je .end ;nullを見つけたら終了
 
 inc rax ;nullでない場合　次の文字へカウント 
 jmp .loop

.end:
 ret ;'ret'に到達　raxに戻り値が入る(そういう仕様)

_start:
 mov rdi,test_string
 call strlen
 mov rdi,rax
 mov rax,60
 syscall