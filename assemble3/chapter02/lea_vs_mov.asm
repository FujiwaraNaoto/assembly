;rsi<- ラベル'codes'のアドレス(数値)
mov rsi,codes

;rsi<-'codes'というアドレスからはじまるメモリの内容
; rsiは8byte長さなので　codesの連続する8byteが取られる
mov rsi,[codes]

; rsi<-address of 'codes' のアドレス
; mov rsi,codesと等しい
;アドレスが複数の部分を含むことができる
lea rsi,[codes]

;rsi<- (codes+rax)からはじまるメモリ内容
mov rsi, [codes+rax]

;rsi<-codes+rax
; これは次の二つの組み合わせたものと等しい
; --mov rsi,codes
; --add rsi,rax
;1回のmovでこれはできない
lea rsi,[codes+rax]