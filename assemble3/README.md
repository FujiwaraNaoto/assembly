# LOw Level Programming

objectファイルを作るさいに利用する
```
nasm -felf64 hello.asm
```
リンカで実行ファイルを作る際に利用する
```
ld -o hello hello.o
```
標準出力させたい場合のコマンド
```
exit $?
```

呼び出し先退避レジスタ　(プログラマーが逐一push popしなくていい)
rbx,rbp,rsp,r12~r15

呼び出し元退避レジスタ 
(プログラマーが関数を呼び出す際に逐一,push　関数が終わった後で逐一popする必要があるレジスタ達)
上記以外.つまりこれらのレジスタを使う際には取り扱いに注意.

chapter2 
    print_rax.asm
    strlen.asm 実行したあとで echo $? とすると結果が出る


## for 文
- デクリメントの場合
```
for (i=5;i>0;i--){  }
```
これは　いかに相当する
```
    mov rcx,5
.loop:

    test rcx,rcx; rcx=0ならzero flag
    dec rcx
    jnz .loop

```

使用例. syscall の際にrcxの内容が書き換わるので,pushで退避 popで取り出し
```
_start:

    xor rcx,rcx
    mov rcx,5
.loop:
    
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

    test rcx,rcx;rcx=0ならzero flag
    dec rcx
    jnz .loop; jump if not zero
    
    
    call exit
```
- インクリメントの場合
```
for( i=1;i<=5;i++) {}
```

具体例
```

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


```
なお,cmpの命令のすぐあとにjmp関係の命令をしないと失敗するため,
incを置くさいには注意が必要





## while 文

jmp (label)  これはlabelに無条件にジャンプする
```
while(1){}
```
は
```
jmp _start に相当
```

使い方
```
section .data
correct: dq -1
section .text

global _start
_start:
    jmp _start
```