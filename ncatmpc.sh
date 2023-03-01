#!/bin/sh

# ======変数の設定======

export LANG=C

# ホスト名とポート番号の環境変数があるかを確認,無ければ"localhost","6600"を代入
test -n "${MPD_HOST}" || export MPD_HOST="localhost"
test -n "${MPD_PORT}" || export MPD_PORT="6600"

# 条件分岐,1番目の引数に応じて変数に代入する文字列を変更
case "${1}" in

	# 引数がない場合
	"" ) 
		
		command="cat - " ; arg1="status"

	;;

	# "status","listall","play"の場合
	"status" | "listall" | "play" ) 

		command="cat - " ; arg1="${1}"

	;;
	
	# "lsplaylist","lsplaylists"の場合
	"lsplaylist" | "lsplaylists" )

		command="cat - " ; arg1="listplaylists"

	;;	

	# "toggle"の場合
	"toggle" )

		command="cat - " ; arg1="pause"

	;;

	# "playlist"の場合
	"playlist" ) command="cut -d: -f2-" ; arg1="${1}" ;;

	# 上記のどれにも一致しない場合
	* ) 

		command="cat - " ; arg1="status"

	;;

esac

# 2番目の引数があれば真,無ければ偽
if [ -n "${2}" ] ; then 
	
	# 真の場合は2番目の引数と"status",改行で挟んだ"close"を代入
	arg2="${2}\nstatus\nclose\n"

else
	
	# 偽の場合は改行で挟んだ"close"を代入
	arg2="\nclose\n"

fi

# ======変数の設定の終了======

# 引数を出力
printf "${arg1} ${arg2}" |

# ncに文字列を渡す
nc "${MPD_HOST}" "${MPD_PORT}" |

# 行頭に"OK","Last-Modified","directory: "を含む行を除外
grep -v -e "^OK" -e "^Last-Modified" -e "^directory: " |

# "command"を実行
${command} |

# "file: "を削除
sed -e "s/^file: //" -e "s/^playlist: //"

