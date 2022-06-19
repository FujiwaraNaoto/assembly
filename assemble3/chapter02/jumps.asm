mov rax,-1
mov rdx,2

cmp rax,rdx
jg locaton
ja locaton ;別のロジックであることに注意 jgは符号あり jaは符号なし

cmp rax,rdx
je location ;rax=rdxならばジャンプ
jne location;rax=rdxでないならばジャンプ [rax!=rdx]
  