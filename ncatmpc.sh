#!/bin/sh

# 変数
test -n "${MPD_HOST}" || export MPD_HOST="localhost"
test -n "${MPD_PORT}" || export MPD_PORT="6600"
test -n "${1}" || 1="status"
test -n "${2}" || 2=""

# 引数を出力
echo "${1}" "${2}" |

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

		# 受け取った文字列を出力
		print $0

		# ステータスの表示
		print "status"

		print "close"

	}

}' |

# ncに文字列を渡す
nc "${MPD_HOST}" "${MPD_PORT}" |

# "OK","Last-Modified","directory: "を含む文字列を除外
grep -F -v -e "OK" -e "Last-Modified" -e "directory: " |

# "file: "を削除
sed -e "s/file: //" -e "s/playlist: //"

