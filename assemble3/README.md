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

