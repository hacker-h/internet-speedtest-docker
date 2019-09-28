#!/bin/sh
FILE="/app/speedtest/test_connection.log"

while true 
do 
	TIMESTAMP=$(date '+%s')

	COMMAND=/app/speedtest/speedtest-cli
	if [ -n "${SERVER}" ]; then
		COMMAND="${COMMAND} --server ${SERVER}"
	fi

	eval "${COMMAND} > ${FILE}"

	DOWNLOAD=$(cat $FILE | grep "Download:" | awk -F " " '{print $2}')
	UPLOAD=$(cat $FILE | grep "Upload:" | awk -F " " '{print $2}')
	echo "Download: $DOWNLOAD Upload: $UPLOAD    $TIMESTAMP"
	curl -i -XPOST 'http://db:8086/write?db=speedtest' --data-binary "download,host=local value=$DOWNLOAD"
	curl -i -XPOST 'http://db:8086/write?db=speedtest' --data-binary "upload,host=local value=$UPLOAD"
	sleep $TEST_INTERVAL

done
