#!/bin/sh

# ======変数の設定======
export LANG=C

# ホスト名とポート番号の環境変数があるかを確認,無ければ"localhost","6600"を代入
test -n "${MPD_HOST}" || export MPD_HOST="localhost"
test -n "${MPD_PORT}" || export MPD_PORT="6600"

# パイプを素通りする"cat"を代入
command="cat - "

# 1番目の引数を代入
arg1="${1}"

# 改行で挟んだ"close"を代入
arg2="\nclose\n"

# 条件分岐,1番目の引数に応じて変数に代入する文字列を変更
case "${1}" in

	# 引数がない,"status"の場合
	"" | "status" ) 

		# "status"を代入
		arg1="status"

	;;

	# "listall"."stats"の場合
	"listall" | "stats" ) 

		# 何もしない
		:

	;;
	
	# "lsplaylist","lsplaylists"の場合
	"lsplaylist" | "lsplaylists" )

		# arg1に"listplaylists"を代入
		arg1="listplaylists"

	;;	

	# "play","pause","volume","add"の場合
	"play" | "pause" | "volume" | "add" )

		# 2番目の引数と改行で挟んだ"status"と"close"を出力
		arg2="${2}\nstatus\nclose\n"

	;;

	# "toggle"の場合
	"toggle" )

		# arg1に"pause"を代入
		arg1="pause"

		# 改行で挟んだ"status"と"close"を出力
		arg2="\nstatus\nclose\n"

	;;

	# "playlist"の場合
	"playlist" )

		# 区切り文字に":",2フィールド目以降を出力
		command="cut -d: -f2-" 
	
	;;

	# 上記のどれにも一致しない場合
	* ) 

		# arg1に"status"を代入
		arg1="status"

	;;

esac

# ======変数の設定の終了======

# 変数に代入された引数を出力
echo "${arg1}" "${arg2}" |

# ncに文字列を渡す,1秒経過でタイムアウト
nc -w 1 "${MPD_HOST}" "${MPD_PORT}" |

# 行頭に"OK","Last-Modified","directory: "を含む行を除外
grep -v -e "^OK" -e "^Last-Modified" -e "^directory: " |

# "cat"か"cut"を実行
${command} |

# 行頭の"file: ","playlist: "を削除
sed -e "s/^file: //" -e "s/^playlist: //"

