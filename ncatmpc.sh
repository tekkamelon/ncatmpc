#!/bin/sh

# 変数
host=$(echo "${MPD_HOST}" | grep . || echo "localhost")
port=$(echo "${MPD_PORT}" | grep . || echo "6600")
arg1=$(echo "${1}" | grep . || echo "status")
arg2=$(echo "${2}" | grep . || echo "")

echo "${arg1}" "${arg2}" | 

grep -F -e "playlist" -e "listall" -e "status" -e "play" -e "lsplaylists" |

awk '{

	if($1 == "status"){

		print $0
	
		print "close"
	
	}

	else{

		sub("lsplaylists" , "listplaylists")

		print $0

		print "status"

		print "close"

	}

}' |

nc "${host}" "${port}" | grep -F -v "OK"

