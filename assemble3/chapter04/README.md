
main.oは存在しないが,問題ない.次のコマンドを入力
```
nasm -felf64 -o main.o mappings_loop.asm
```
これでmain.oが存在する
```
ld -o main main.o
./main &
```

```
naoto@DESKTOP-FJTLMRQ:~$ ./main &
[1] 256
naoto@DESKTOP-FJTLMRQ:~$ cat /proc/256/maps
00400000-00401000 r--p 00000000 08:10 60856                              /home/chapter04/main
00401000-00402000 r-xp 00001000 08:10 60856                              /home/chapter04/main
00402000-00403000 rw-p 00002000 08:10 60856                              /home/chapter04/main
7ffc4ecc5000-7ffc4ece6000 rw-p 00000000 00:00 0                          [stack]
7ffc4edf1000-7ffc4edf5000 r--p 00000000 00:00 0                          [vvar]
7ffc4edf5000-7ffc4edf6000 r-xp 00000000 00:00 0                          [vdso]
naoto@DESKTOP-FJTLMRQ:~$

```

つづいてLinuxの /proc/<PID>/mapsを見る.
00400000-00401000 r--p 00000000 08:10 60856                              /home/chapter04/main
00401000-00402000 r-xp 00001000 08:10 60856                              /home/chapter04/main
00402000-00403000 rw-p 00002000 08:10 60856                              /home/chapter04/main
7ffd64109000-7ffd6412a000 rw-p 00000000 00:00 0                          [stack]
7ffd641a1000-7ffd641a5000 r--p 00000000 00:00 0                          [vvar]
7ffd641a5000-7ffd641a6000 r-xp 00000000 00:00 0                          [vdso]
naoto@DESKTOP-FJTLMRQ:~$





question 26のヒント

stat のシステムコール
ディレクトリ/usr/include/x86_64-linux-gnu/asm$
で以下のコマンド
```
cat unistd_64.h | grep stat
```
結果
```
#define __NR_stat 4
#define __NR_fstat 5
#define __NR_lstat 6
#define __NR_ustat 136
#define __NR_statfs 137
#define __NR_fstatfs 138
#define __NR_newfstatat 262
#define __NR_statx 332
```


struct stat {
    dev_t     st_dev;     /* ファイルがあるデバイスの ID */
    ino_t     st_ino;     /* inode 番号 */
    mode_t    st_mode;    /* アクセス保護 */
    nlink_t   st_nlink;   /* ハードリンクの数 */
    uid_t     st_uid;     /* 所有者のユーザー ID */
    gid_t     st_gid;     /* 所有者のグループ ID */
    dev_t     st_rdev;    /* デバイス ID (特殊ファイルの場合) */
    off_t     st_size;    /* 全体のサイズ (バイト単位) */
    blksize_t st_blksize; /* ファイルシステム I/O での
                             ブロックサイズ */
    blkcnt_t  st_blocks;  /* 割り当てられた 512B のブロック数 */
};

https://elixir.bootlin.com/linux/v5.18.4/source/tools/include
から調べる

次のように定義されている 

typedef unsigned int	__kernel_uid32_t;
typedef u32 uint32_t

<linux/types.h>
typedef u32 __kernel_dev_t;

typedef __kernel_fd_set		fd_set;
typedef __kernel_dev_t		dev_t;
typedef __kernel_ulong_t	ino_t;
typedef __kernel_mode_t		mode_t;
typedef unsigned short		umode_t;
typedef u32			nlink_t;
typedef __kernel_off_t		off_t;
typedef __kernel_pid_t		pid_t;
typedef __kernel_daddr_t	daddr_t;
typedef __kernel_key_t		key_t;
typedef __kernel_suseconds_t	suseconds_t;
typedef __kernel_timer_t	timer_t;
typedef __kernel_clockid_t	clockid_t;
typedef __kernel_mqd_t		mqd_t;

typedef _Bool			bool;

typedef __kernel_uid32_t	uid_t;
typedef __kernel_gid32_t	gid_t;
typedef __kernel_uid16_t        uid16_t;
typedef __kernel_gid16_t        gid16_t;


dev_t は<linux/types.h>で定義され__kernel_dev_tと同じ　さかのぼるとu32,と等しく,さらにさかのぼるとu32はuint32_t　これは　32bit=unsigned int = 4byte

ino_t は __kernel_ulong_t であり、さかのぼるとunsigned long で4byte = 32bit同様

mode_tは__kernel_mode_t であり,さかのぼるとunsigned short で

nlink_t はu32で uint32_tと等しくこれは32bit = 4byte


uid_t は__kernel_uid32_t と同様で さかのぼるとunsigned int  = 4byte


gid_t は__kernel_gid32_tと同様で　unsigned int 


dev_t は先ほど出てきた

off_t __kernel_off_t型であり これは__kernel_long_tと等しく これはさかのぼると long と等しい long は4byte


blksize_t　は<nolibc/nolibc.h>からsigned long に等しい

blkcnt_t　は<nolibc/nolibc.h>からsigned long に等しい


まとめると
dev_t = 4byte,
ino_t = 4byte,
mode_t = 2byte,
nlink_t = 4byte,
uid_t = 4byte,
gid_t = 4byte,
dev_t = 4byte,
off_t = 4byte,
blksize_t = 4byte,
blkcnt_t = 4byte
