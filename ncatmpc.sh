#!/bin/sh -eu

# 変数
host=$(echo "${MPD_HOST}" | grep . || echo "localhost")
port=$(echo "${MPD_PORT}" | grep . || echo "6600")

echo "${1}" "${2}" | 

grep -F -e "playlist" -e "listall" -e "status" -e "play" |

awk '{

	if($1 == "status"){

		print $0
	
		print "close"
	
	}

	else{

		print $0

		print "status"

		print "close"

	}

}' |

nc "${host}" "${port}"

