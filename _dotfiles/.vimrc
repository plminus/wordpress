" 表示 {{{
"-------------------------------------------------------------------------------
" 表示 Apperance
"-------------------------------------------------------------------------------
set cursorline        " カーソル行をハイライト
"set display=uhex      " 印字不可能文字を16進数で表示
set lazyredraw        " コマンド実行中は再描画しない
set list              " 不可視文字表示
"set listchars=tab:>.,trail:_,extends:>,precedes:<        " 不可視文字の表示形式
"set listchars=tab:*-,extends:~,trail:_                   " 不可視文字の表示形式
set listchars=tab:»-,trail:-,extends:»,precedes:«,nbsp:% " 不可視文字の表示形式
set novisualbell      " ビジュアルベルを無効にする
set number            " 行番号表示
set ruler             " カーソルが何行目の何列目に置かれているかを表示する
set showmatch         " 括弧の対応をハイライト
set ttyfast           " 高速ターミナル接続を行う

"改行文字とタブ文字の色設定（NonTextが改行、SpecialKeyがタブ）
highlight NonText    ctermfg=0 guibg=NONE guifg=DarkGreen
highlight SpecialKey ctermfg=0 guibg=NONE guifg=DarkGray
"highlight NonText    ctermfg=18 guibg=NONE guifg=DarkGreen
"highlight SpecialKey ctermfg=18 guibg=NONE guifg=DarkGray

" 全角スペースの表示
"highlight ZenkakuSpace cterm=underline ctermfg=lightblue guibg=darkgray
highlight ZenkakuSpace ctermbg=white guibg=white
match ZenkakuSpace /　/

" カレントウィンドウにのみ罫線を引く
augroup cch
  autocmd! cch
  autocmd WinLeave * set nocursorline
  autocmd WinEnter,BufRead * set cursorline
augroup END

highlight clear CursorLine
highlight CursorLine gui=underline
highlight CursorLine ctermbg=black guibg=black

" }}}
" 基本設定 {{{
"-------------------------------------------------------------------------------
" 基本設定 Basics
"-------------------------------------------------------------------------------
let mapleader = ","              " キーマップリーダー
set autoread                     " 他で書き換えられたら自動で読み直す
set backspace=indent,eol,start   " バックスペースでなんでも消せるように
set browsedir=buffer             " Exploreの初期ディレクトリ
set cmdheight=2                  " コマンドラインに使われるスクリーン上の行数
set directory=$HOME/.vim/swap    " swapファイルの保存ディレクトリ
set formatoptions=lmoq           " テキスト整形オプション，マルチバイト系を追加
set hidden                       " 編集中でも他のファイルを開けるようにする
set modelines=0                  " モードラインを探す行数
set nobackup                     " バックアップ取らない
set nomodeline                   " モードラインは無効
set noscrollbind                 " スクロール同期しない
set noswapfile                   " スワップファイル作らない
set nowritebackup                " バックアップ取らない
set scrolloff=0                  " スクロール時の余白確保
set showcmd                      " コマンドをステータス行に表示
set showmode                     " 現在のモードを表示
set textwidth=0                  " 一行に長い文章を書いていても自動折り返しをしない
"set viminfo='50,<1000,s100,\"50  " viminfoファイルの設定
"set whichwrap=b,s,h,l,<,>,[,]    " カーソルを行頭、行末で止まらないようにする

" コントロールコードの上書きを抑制
" http://blog.nyarla.net/2009/10/12/1
"^? -> Ctrl+v Ctrl+<backspace>
"^H -> Ctrl+v Ctrl+H
noremap   
noremap!  
noremap  <BS> 
noremap! <BS> 

" 画面分割用キーマップ
map  <C-W><C-V> :Vexplore!<CR>
map  <C-W><C-H> :Hexplore<CR>
map! <C-W><C-V> <ESC>:Vexplore!<CR>
map! <C-W><C-H> <ESC>:Hexplore<CR>

" Netrwのエクスプローラー設定
"let g:netrw_sort_sequence="[\/]$,*,\.\(mv\|old\|cp\|bak\|orig\)[0-9]*[\/]$,\.\(mv\|old\|cp\|bak\|orig\)[0-9]*$,\.o$,\.info$,\.swp$,\.obj$ "
"let g:netrw_sort_sequence="[\/]$,\<core\%(\.\d\+\)\=,\.[a-np-z]$,\.h$,\.c$,\.cpp$,*,\.o$,\.obj$,\.info$,\.swp$,\.bak$,\~$"
"let g:netrw_sort_sequence='[\/]$,\.h$,\.c$,\.cpp$,*,\.o$,\.obj$,\.info$,\.swp$,\.bak$,\~$'
"let g:netrw_sort_sequence=''

" 拡張子別ファイルタイプ設定
autocmd! BufRead,BufNewFile *.conf   set filetype=sh
autocmd! BufRead,BufNewFile *.erb    set filetype=html
autocmd! BufRead,BufNewFile *.htm    set filetype=html
autocmd! BufRead,BufNewFile *.rhtml  set filetype=html
autocmd! BufRead,BufNewFile *.t.html set filetype=html
autocmd! BufRead,BufNewFile *.tmpl   set filetype=html
autocmd! BufRead,BufNewFile *.tpl    set filetype=html

" }}}
" カラー関連 {{{
"-------------------------------------------------------------------------------
" カラー関連 Colors
"-------------------------------------------------------------------------------
" ターミナルタイプによるカラー設定
if &term =~ "xterm-256color" || "screen-256color"
  " 256色
  set t_Co=256
  set t_Sf=[3%dm
  set t_Sb=[4%dm
elseif &term =~ "xterm-debian" || &term =~ "xterm-xfree86"
  set t_Co=16
  set t_Sf=[3%dm
  set t_Sb=[4%dm
elseif &term =~ "xterm-color"
  set t_Co=8
  set t_Sf=[3%dm
  set t_Sb=[4%dm
endif

" ハイライト on
"syntax enable
if has("syntax")
  syntax on
endif

" ポップアップメニューのカラーを設定
"highlight Pmenu guibg=#003000
"highlight PmenuSel guibg=#006800
"highlight PmenuSbar guibg=#001800
"highlight PmenuThumb guifg=#006000

" 補完候補のハイライト色を設定 for vim7
"highlight Pmenu     ctermbg=white ctermfg=darkgray
"highlight PmenuSel  ctermbg=blue  ctermfg=white
"highlight PmenuSbar ctermbg=0 ctermfg=9
highlight Pmenu     ctermbg=4
highlight PmenuSel  ctermbg=1
highlight PmenuSbar ctermbg=4

" }}}
" 補完・履歴 {{{
"-------------------------------------------------------------------------------
" 補完・履歴 Complete
"-------------------------------------------------------------------------------
set complete+=k            " 補完に辞書ファイル追加
set history=100            " コマンド・検索パターンの履歴数
set wildchar=<tab>         " コマンド補完を開始するキー
set wildmenu               " コマンド補完を強化
set wildmode=list:full     " リスト表示，最長マッチ

" Ex-modeでの<C-p><C-n>をzshのヒストリ補完っぽくする
noremap <C-p>  <Up>
noremap <Up>   <C-p>
noremap <C-n>  <Down>
noremap <Down> <C-n>

" }}}
" 編集関連 {{{
"-------------------------------------------------------------------------------
" 編集関連 Edit
"-------------------------------------------------------------------------------
set expandtab         " Tabキーを空白に変換
set foldmethod=syntax " foldは各FileTypeに任せる
"set foldlevelstart=99 " 折りたたみは全て展開した状態で開始する

" .vimはmarker
autocmd FileType vim :set foldmethod=marker

" <Leader>mでfoldmethod=markerを適用する
nnoremap <silent> <Leader>m <ESC>:set foldmethod=marker<CR>

" insertモードを抜けるとIMEオフ
set iminsert=0 imsearch=0
set noimcmdline
set noimdisable
inoremap <silent> <ESC> <ESC>:set iminsert=0<CR>

" 保存時に行末の空白を除去する
"autocmd BufWritePre * :%s/\s\+$//ge
"
" 保存時にtabをスペースに変換する
"autocmd BufWritePre * :%s/\t/  /ge

" yeでそのカーソル位置にある単語をレジスタに追加
nmap ye :let @"=expand("<cword>")<CR>

" Visualモードでのpで選択範囲をレジスタの内容に置き換える
vnoremap p <ESC>:let current_reg = @"<CR>gvdi<C-R>=current_reg<CR><ESC>

" コンマの後に自動的にスペースを挿入
"inoremap , ,<Space>

" 日時の自動入力
inoremap <expr> ,df strftime('%Y-%m-%d %H:%M:%S')
inoremap <expr> ,dd strftime('%Y-%m-%d')
inoremap <expr> ,dt strftime('%H:%M:%S')

" 括弧を自動補完
"inoremap { {}<LEFT>
"inoremap [ []<LEFT>
"inoremap ( ()<LEFT>
"inoremap " ""<LEFT>
"inoremap ' ''<LEFT>
"vnoremap { "zdi^V{<C-R>z}<ESC>
"vnoremap [ "zdi^V[<C-R>z]<ESC>
"vnoremap ( "zdi^V(<C-R>z)<ESC>
"vnoremap " "zdi^V"<C-R>z^V"<ESC>
"vnoremap ' "zdi'<C-R>z'<ESC>

" バイナリ編集(xxd)モード（vim -b での起動、もしくは *.bin で発動します）
augroup BinaryXXD
  autocmd!
  autocmd BufReadPre   *.bin let &binary =1
  autocmd BufReadPost  * if &binary | silent %!xxd -g 1
  autocmd BufReadPost  * set ft=xxd | endif
  autocmd BufWritePre  * if &binary | %!xxd -r | endif
  autocmd BufWritePost * if &binary | silent %!xxd -g 1
  autocmd BufWritePost * set nomod | endif
augroup END

" XMLの閉タグを自動挿入
"augroup MyXML
"  autocmd!
"  autocmd Filetype xml inoremap <buffer> </ </<C-x><C-o>
"augroup END

" }}}
" エンコーディング関連 {{{
"-------------------------------------------------------------------------------
" エンコーディング関連 Encoding
"-------------------------------------------------------------------------------
" デフォルト文字コード
set encoding=utf-8

" 文字コードの自動認識
set fileencodings=ucs-bom,iso-2022-jp-3,iso-2022-jp,eucjp-ms,euc-jisx0213,euc-jp,sjis,cp932,utf-8

" 改行コードの自動認識
set fileformats=unix,dos,mac

" □とか○の文字があってもカーソル位置がずれないようにする
if exists('&ambiwidth')
  set ambiwidth=double
endif

" ファイルタイプ別に文字コードを設定
autocmd FileType css   :set fileencoding=utf-8
autocmd FileType csv   :set fileencoding=sjis
autocmd FileType cvs   :set fileencoding=euc-jp
autocmd FileType html  :set fileencoding=utf-8
autocmd FileType java  :set fileencoding=utf-8
autocmd FileType js    :set fileencoding=utf-8
autocmd FileType php   :set fileencoding=utf-8
autocmd FileType ruby  :set fileencoding=utf-8
autocmd FileType scala :set fileencoding=utf-8
autocmd FileType svn   :set fileencoding=utf-8
autocmd FileType tsv   :set fileencoding=sjis
autocmd FileType xml   :set fileencoding=utf-8
autocmd FileType yaml  :set fileencoding=utf-8

" ワイルドカードで表示するときに優先度を低くする拡張子
set suffixes=.bak,~,.swp,.o,.info,.aux,.log,.dvi,.bbl,.blg,.brf,.cb,.ind,.idx,.ilg,.inx,.out,.toc

" 指定文字コードで強制的にファイルを開く
command! Cp932     edit ++enc=cp932
command! Eucjp     edit ++enc=euc-jp
command! Iso2022jp edit ++enc=iso-2022-jp
command! Utf8      edit ++enc=utf-8
command! Jis Iso2022jp
command! Sjis Cp932

" }}}
" インデント {{{
"-------------------------------------------------------------------------------
" インデント Indent
"-------------------------------------------------------------------------------
set autoindent   " 自動でインデント
set cindent      " Cプログラムファイルの自動インデントを始める
set smartindent  " 新しい行を開始したときに、新しい行のインデントを現在行と同じ量にする
set smarttab     " スマートタブ

" softtabstopはTabキー押し下げ時の挿入される空白の量，0の場合はtabstopと同じ，BSにも影響する
set tabstop=2 shiftwidth=2 softtabstop=0

if has("autocmd")
  "ファイルタイプの検索を有効にする
  filetype plugin on
  "そのファイルタイプにあわせたインデントを利用する
  filetype indent on
  " これらのftではインデントを無効に
  "autocmd FileType php filetype indent off

  autocmd FileType apache     setlocal sw=4 sts=4 ts=4 et
  autocmd FileType aspvbs     setlocal sw=4 sts=4 ts=4 et
  autocmd FileType bash       setlocal sw=2 sts=2 ts=2 et
  autocmd FileType c          setlocal sw=4 sts=4 ts=4 et
  autocmd FileType cpp        setlocal sw=4 sts=4 ts=4 et
  autocmd FileType cs         setlocal sw=4 sts=4 ts=4 et
  autocmd FileType css        setlocal sw=2 sts=2 ts=2 et
  autocmd FileType diff       setlocal sw=4 sts=4 ts=4 et
  autocmd FileType eruby      setlocal sw=4 sts=4 ts=4 et
  autocmd FileType haml       setlocal sw=2 sts=2 ts=2 et
  autocmd FileType html       setlocal sw=2 sts=2 ts=2 et
  autocmd FileType java       setlocal sw=4 sts=4 ts=4 et
  autocmd FileType javascript setlocal sw=2 sts=2 ts=2 et
  autocmd FileType perl       setlocal sw=4 sts=4 ts=4 et
  autocmd FileType php        setlocal sw=4 sts=4 ts=4 noet
  autocmd FileType python     setlocal sw=4 sts=4 ts=4 et
  autocmd FileType ruby       setlocal sw=2 sts=2 ts=2 et
  autocmd FileType scala      setlocal sw=2 sts=2 ts=2 et
  autocmd FileType sh         setlocal sw=2 sts=2 ts=2 et
  autocmd FileType sql        setlocal sw=4 sts=4 ts=4 et
  autocmd FileType vb         setlocal sw=4 sts=4 ts=4 et
  autocmd FileType vim        setlocal sw=2 sts=2 ts=2 et
  autocmd FileType wsh        setlocal sw=4 sts=4 ts=4 et
  autocmd FileType xhtml      setlocal sw=4 sts=4 ts=4 et
  autocmd FileType xml        setlocal sw=4 sts=4 ts=4 et
  autocmd FileType yaml       setlocal sw=2 sts=2 ts=2 et
  autocmd FileType zsh        setlocal sw=4 sts=4 ts=4 et
endif

" }}}
" 移動設定 {{{
"-------------------------------------------------------------------------------
" 移動設定 Move
"-------------------------------------------------------------------------------
" ファイルのディレクトリをカレントディレクトリに変更する
noremap <silent> <Leader>. <ESC>:cd %:h<CR>

" カーソルを表示行で移動する
nnoremap h <Left>
nnoremap j gj
nnoremap k gk
nnoremap l <Right>
nnoremap <Down> gj
nnoremap <Up>   gk

" 8, 9で行頭、行末へ
nmap 8 ^
nmap 9 $

" insert mode での移動
inoremap  <C-e> <END>
inoremap  <C-a> <HOME>

" インサートモードでもCtrl + hjklで移動
inoremap <C-j> <Down>
inoremap <C-k> <Up>
inoremap <C-h> <Left>
inoremap <C-l> <Right>

" <Leader><Leader>で直前のバッファ
nnoremap <silent> <Leader><Leader> <ESC>:b#<CR>

" F2で前のバッファ
map <F2> <ESC>:bp<CR>
" F3で次のバッファ
map <F3> <ESC>:bn<CR>
" F4でバッファを削除する
map <F4> <ESC>:bw<CR>
"map <F4> <ESC>:bnext \| bdelete #<CR>
"command! Bw :bnext \| bdelete #

"フレームサイズを怠惰に変更する
map <kPlus>  <C-W>+
map <kMinus> <C-W>-

" 前回終了したカーソル行に移動
autocmd BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal g`\"" | endif

" 最後に編集された位置に移動
nnoremap gb '[
nnoremap gp ']

" 対応する括弧に移動
nnoremap ( %
nnoremap ) %

" 最後に変更されたテキストを選択する
nnoremap gc  `[v`]
vnoremap gc <C-u>normal gc<Enter>
onoremap gc <C-u>normal gc<Enter>

" カーソル位置の単語をyankする
nnoremap vy vawy

" 矩形選択で自由に移動する
set virtualedit+=block

"ビジュアルモード時vで行末まで選択
vnoremap v $h

" Ctrl-hjklでウィンドウ移動
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
nnoremap <C-h> <C-w>h

" git-diff-aware version of gf commands.
" http://labs.timedia.co.jp/2011/04/git-diff-aware-gf-commands-for-vim.html
nnoremap <expr> gf          <SID>do_git_diff_aware_gf('gf')
nnoremap <expr> gF          <SID>do_git_diff_aware_gf('gF')
nnoremap <expr> <C-w>f      <SID>do_git_diff_aware_gf('<C-w>f')
nnoremap <expr> <C-w><C-f>  <SID>do_git_diff_aware_gf('<C-w><C-f>')
nnoremap <expr> <C-w>F      <SID>do_git_diff_aware_gf('<C-w>F')
nnoremap <expr> <C-w>gf     <SID>do_git_diff_aware_gf('<C-w>gf')
nnoremap <expr> <C-w>gF     <SID>do_git_diff_aware_gf('<C-w>gF')

function! s:do_git_diff_aware_gf(command)
  let target_path = expand('<cfile>')
  if target_path =~# '^[ab]/'  " with a peculiar prefix of git-diff(1)?
    if filereadable(target_path) || isdirectory(target_path)
      return a:command
    else
      " BUGS: Side effect - Cursor position is changed.
      let [_, c] = searchpos('\f\+', 'cenW')
      return c . '|' . 'v' . (len(target_path) - 2 - 1) . 'h' . a:command
    endif
  else
    return a:command
  endif
endfunction

" insert mode でjjでesc
inoremap jj <ESC>

" }}}
" 検索設定 {{{
"-------------------------------------------------------------------------------
" 検索設定 Search
"-------------------------------------------------------------------------------
set hlsearch     " 検索文字をハイライト
set ignorecase   " 大文字小文字無視
set incsearch    " インクリメンタルサーチする
set smartcase    " 検索文字列に大文字が含まれている場合は区別して検索する
set wrapscan     " 最後まで検索したら先頭へ戻る

" 検索語が画面の真ん中に来るようにする
nmap n  nzz
nmap N  Nzz
nmap *  *zz
nmap #  #zz
nmap g* g*zz
nmap g# g#zz

"ESCの2回押しでハイライト消去
nmap <ESC><ESC> :nohlsearch<CR><ESC>

"選択した文字列を検索
vnoremap <silent> // y/<C-R>=escape(@", '\\/.*$^~[]')<CR><CR>

"選択した文字列を置換
vnoremap /r "xy:%s/<C-R>=escape(@x, '\\/.*$^~[]')<CR>//gc<Left><Left><Left>

"s*置換後文字列/g<Cr>でカーソル下のキーワードを置換
nnoremap <expr> s* ':%substitute/\<' . expand('<cword>') . '\>/'

" Ctrl-iでヘルプ
nnoremap <C-i>  :<C-u>help<Space>

" カーソル下のキーワードをヘルプでひく
nnoremap <C-i><C-i> :<C-u>help<Space><C-r><C-w><Enter>

" :Gb <args> でGrepBufferする
command! -nargs=1 Gb :GrepBuffer <args>

" カーソル下の単語をGrepBufferする
nnoremap <C-g><C-b> :<C-u>GrepBuffer<Space><C-r><C-w><Enter>

" :Gr <args>でカレントディレクトリ以下を再帰的にgrepする
command! -nargs=1 Gr :Rgrep <args> *<Enter><CR>
" カーソル下の単語をgrepする
nnoremap <silent> <C-g><C-r> :<C-u>Rgrep<Space><C-r><C-w> *<Enter><CR>

let Grep_Skip_Dirs = '.git .svn'
let Grep_Skip_Files = '*.bak *~'

" }}}
" ステータスライン {{{
"-------------------------------------------------------------------------------
" ステータスライン StatusLine
"-------------------------------------------------------------------------------
set laststatus=2      " 常にステータスラインを表示

" ステータスラインに文字コードと改行文字を表示する
"set statusline=%<%f\ %m%r%h%w%{'['.(&fenc!=''?&fenc:&enc).']['.&ff.']'}%=%l,%c%V%8P
"set statusline=%n:\ %<%f\ %m%r%h%w[%{&fileformat}][%{has('multi_byte')&&\ &fileencoding!=''?&fileencoding:&encoding}]\ 0x%B=%b%=%l,%c\ %P

" ステータスラインに文字コードと改行文字を表示する
set statusline+=%n:   " バッファ番号
set statusline+=\     " 空白スペース
set statusline=%<     " 行が長すぎるときに切り詰める位置
set statusline+=%f    " ファイル名
set statusline+=\     " 空白スペース
set statusline+=%m    " %m 修正フラグ
set statusline+=%r    " %r 読み込み専用フラグ
set statusline+=%h    " %h ヘルプバッファフラグ
set statusline+=%w    " %w プレビューウィンドウフラグ
"set statusline+=%{'['.(&fenc!=''?&fenc:&enc).':'.&ff.']'}  " fencとffを表示
"set statusline+=%{'['.&ff.':'.(&fenc!=''?&fenc:&enc).']'}  " ffとfencを表示
set statusline+=%{'['.(&fenc!=''?&fenc:&enc).']'}  " fencを表示
set statusline+=%{'['.&ff.']'}                     " ffを表示
set statusline+=%y    " バッファ内のファイルのタイプ
set statusline+=\     " 空白スペース
set statusline+=0x%B=%b  " カーソル下の文字の文字コード(%B=16進数, %b=10進数)
"set statusline+=\    " 空白スペース
"if winwidth(0) >= 130
"  set statusline+=%F  " バッファ内のファイルのフルパス
"else
"  set statusline+=%t  " ファイル名のみ
"endif
set statusline+=%=    " 左寄せ項目と右寄せ項目の区切り
"set statusline+=%{fugitive#statusline()}  " Gitのブランチ名を表示
set statusline+=\     " 空白スペース
set statusline+=%l    " 何行目にカーソルがあるか
set statusline+=/
set statusline+=%L    " バッファ内の総行数
set statusline+=,
set statusline+=\     " 空白スペース
set statusline+=%c    " 何列目にカーソルがあるか
set statusline+=%V    " 画面上の何列目にカーソルがあるか
set statusline+=\     " 空白スペース
set statusline+=%P    " ファイル内の何％の位置にあるか

" 入力モード時、ステータスラインのカラーを変更
"augroup InsertHook
"  autocmd!
"  "autocmd BufRead,BufNewFile * highlight StatusLine guifg=#2E4340 guibg=#ccdc90 ctermfg=Magenta
"  autocmd BufRead,BufNewFile * highlight StatusLine guifg=#2E4340 guibg=#ccdc90 ctermfg=DarkGreen
"  autocmd InsertEnter        * highlight StatusLine guifg=#ccdc90 guibg=#2E4340 ctermfg=Red
"  autocmd InsertLeave        * highlight StatusLine guifg=#2E4340 guibg=#ccdc90 ctermfg=DarkGreen
"augroup END

" }}}
" タグ関連 {{{
"-------------------------------------------------------------------------------
" タグ関連 Tags
"-------------------------------------------------------------------------------
set notagbsearch

" set tags
if has("autochdir")
  " 編集しているファイルのディレクトリに自動で移動
  set autochdir
  set tags=tags:
else
  set tags=./tags,./../tags,./*/tags,./../../tags,./../../../tags,./../../../../tags,./../../../../../tags
endif
"set tags+=~/.tags

"<C-t>はscreentとかぶるので削除
"tab pagesを使い易くする
" nnoremap <C-t>  <Nop>
" nnoremap <C-t>n :<C-u>tabnew<CR>
" nnoremap <C-t>c :<C-u>tabclose<CR>
" nnoremap <C-t>o :<C-u>tabonly<CR>
" nnoremap <C-t>j :<C-u>execute 'tabnext' 1 + (tabpagenr() + v:count1 - 1) % tabpagenr('$')<CR>
" nnoremap <C-t>k gT

"tags-and-searchesを使い易くする
nnoremap t  <Nop>
"「飛ぶ」
nnoremap tt <C-]>
"「進む」
nnoremap tj :<C-u>tag<CR>
"「戻る」
nnoremap tk :<C-u>pop<CR>
"履歴一覧
nnoremap tl :<C-u>tags<CR>

" }}}
" 言語別の折りたたみ設定 {{{
"-------------------------------------------------------------------------------
" 言語別の折りたたみ設定 Foldings
"-------------------------------------------------------------------------------
let perl_fold=1
autocmd Syntax perl set fdm=syntax

let php_folding=1
autocmd Syntax php  set fdm=syntax

let ruby_fold=1
autocmd Syntax ruby set fdm=syntax

" PHPFoldSetting {{{

function! PHPFoldSetting(lnum)
  let l:line = getline(a:lnum)
  if l:line =~ 'function'
    return '>1'
  elseif getline(a:lnum + 1) =~ ' \* '
    return 0
  elseif getline(a:lnum) =~ ' \* '
    return 0
  else
    return '='
  endif
endfunction

" }}}
" BASHFoldSetting {{{

function! BASHFoldSetting(lnum)
  let l:line = getline(a:lnum)
  if l:line =~ '^.*() {'
    return '>1'
  elseif getline(a:lnum) =~ '^}'
    return '<1'
  elseif getline(a:lnum - 1) =~ '^}'
    return '0'
  else
    return '='
  endif
endfunction

" }}}

"autocmd BufEnter *.php   set foldmethod=expr foldexpr=PHPFoldSetting(v:lnum)
"autocmd BufEnter *.php   set noexpandtab
"autocmd BufEnter .bashrc set foldmethod=expr foldexpr=BASHFoldSetting(v:lnum)

" }}}
