# Low Level Programming

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

システムコールの番号を調べたい場合.　cat と　grep を組み合わせる.
たとえば,execveシステムコール
```
cat usr/include/x86_64-linux_gnu/asm/unistd_64.h | grep execve
```
すると
```
#define __NR_execve 59
#define __NR_execveat 322
```
ここから,execveを利用する際にはraxレジスタには59を入れるべきとわかる

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
## strlen
文字列の長さを検知するプログラムの例
ヌル文字を検知することでカウントする.
なお,場合によっては,この関数を呼び出す際に, rcx,rax,rdi
をstackに退避しておくこと.
```
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
```

## printf
以上より, strlenと組み合わせることでprintfを作ることができる.
```
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
```


## exit

raxには60をいれ, 第一引数には rdiを入れる.
rdiが0のときは
```
xor rdi,rdi
```
でも良い.
以下は exit(0)のコード.
```
mov rax,60; exitシステムコール番号
mov rdi,0; exit(0)にするため 
syscall 
```

## file open
raxレジスタには
rdiにはファイルが入っているpath 同じディレクトリならばファイル名,
rsiには書き込み権限　や　読み込み権限
帰り値は ファイルディスクリプタがraxに書き込まれる
ファイルに失敗したらraxには負の値が返る.

```
FILE_OPEN: 
	mov	rax,	[SYS_OPEN]	; system call OPEN 00000002
	mov	rdi,	FILENAME	; file path address
	mov	rsi,	[O_RDWR]	; READ and WRITE 00000002
	syscall

	; Check File Open Result
	mov	r10,	rax		; file discriptor to R10
	cmp	rax,	0x00000000	; compare
	jl	c_MSG_ERROR		; rax < 0 then error ;ファイルがうまく開けなかったときの処理
```

## file close
    raxには 3,第二引数rdiにはfopenで用いたファイルディスクリプタ
```
FILE_CLOSE: 
	mov	rax,	3		;sys_close
	mov	rdi,	r10		; file discriptor
	syscall
```