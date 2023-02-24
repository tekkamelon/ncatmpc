#!/bin/sh

# 変数
host=$(echo "${MPD_HOST}" | grep . || echo "localhost")
port=$(echo "${MPD_PORT}" | grep . || echo "6600")
arg1=$(echo "${1}" | grep . || echo "status")
arg2=$(echo "${2}" | grep . || echo "")

# 引数を出力
echo "${arg1}" "${arg2}" | 

# 対応する引数があるかを確認
grep -F -e "playlist" -e "listall" -e "status" -e "play" -e "toggle" |

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

		# "toggle"を"pause"に置換
		sub("toggle" , "pause")

		print $0

		print "status"

		print "close"

	}

}' |

# ncに文字列を渡す
nc "${host}" "${port}" |

# "OK","Last-Modified","directory: "を含む文字列を除外
grep -F -v -e "OK" -e "Last-Modified" -e "directory: " |

# "file: "を削除
sed -e "s/file: //" -e "s/playlist: //"

