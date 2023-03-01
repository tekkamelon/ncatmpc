#!/bin/sh

# ======変数の設定======

export LANG=C

# ホスト名とポート番号の環境変数があるかを確認,無ければ"localhost","6600"を代入
test -n "${MPD_HOST}" || export MPD_HOST="localhost"
test -n "${MPD_PORT}" || export MPD_PORT="6600"

# 条件分岐,1番目の引数に応じて変数に代入する文字列を変更
case "${1}" in

	# 引数がない場合
	"" ) command="cat - " ; arg1="status" ;;

	# 引数が"status","listall","play","lsplaylist","lsplaylists"の場合
	"status" | "listall" | "play" | "lsplaylist" | "lsplaylists" ) command="cat - " ; arg1="${1}" ;;

	# 引数が"toggle"の場合
	"toggle" ) command="cat - " ; arg1="pause" ;;

	# 引数が"playlist"の場合
	"playlist" ) command="cut -d: -f2-" ; arg1="${1}" ;;

	# 上記のどれにも一致しない場合
	* ) command="cat - " ; arg1="status" ;;

esac

# 2番目の引数があれば真,無ければ偽
if [ -n "${2}" ] ; then 
	
	# 真の場合は2番目の引数を変数に代入
	arg2="${2}"

else
	
	# 偽の場合は空文字を代入
	arg2=""

fi

# ======変数の設定の終了======

# 引数を出力
echo "${arg1}" "${arg2}" |

awk '{
	
	# "status"があれば真,無ければ偽
	if($1 == "status"){
		
		# 真の場合は受け取った文字列と"close"を出力
		print $0
	
		print "close"
	
	}

	else{

		# 偽の場合は"lsplaylists"若しくは"lsplaylists"を"listplaylists"に置換
		sub("lsplaylists|lsplaylist" , "listplaylists")

		# 受け取った文字列を出力
		print $0

		# ステータスの表示
		print "status"

		print "close"

	}

}' |

# ncに文字列を渡す
nc "${MPD_HOST}" "${MPD_PORT}" |

# 行頭に"OK","Last-Modified","directory: "を含む行を除外
grep -v -e "^OK" -e "^Last-Modified" -e "^directory: " |

# "command"を実行
${command} |

# "file: "を削除
sed -e "s/^file: //" -e "s/^playlist: //"

