#!/bin/bash

CLIENT="localhost"
TIMEOUT="1"

echo "server de EFTP"

echo "(0) Listen"

DATA=`nc -l -p 3333 -w $TIMEOUT`

echo $DATA

echo "(3) Test & Send"

if  [ "$DATA" != "EFTP 1.0" ]
then
	echo "ERROR 1: BAD HEADER"
	sleep 1
	echo "KO_HEADER" | nc $CLIENT 3333
	exit 1
fi

echo "OK_HEADER"
sleep 1
echo "OK_HEADER" | nc $CLIENT 3333

echo "(4) Listen"

DATA=`nc -l -p 3333 -w $TIMEOUT`

echo $DATA

echo "(7) Test & Send"

if [ "$DATA" != "BOOOM" ]
then 
	echo "ERROR 2: BAD HANDSHAKE"
	sleep 1
	echo "KO_HANDSHAKE"| nc $CLIENT 3333
	exit 2
fi

sleep 1
echo "OK_HANDSHAKE" |nc $CLIENT 3333

echo "(8) Listen"

DATA=`nc -l -p 3333 -w $TIMEOUT`
echo $DATA

echo "(12) Test & Store & Send"
PREFIX=`echo "$DATA" | cut -d " " -f 1`

if [ "$PREFIX" != "FILE_NAME" ]
then 
	echo "ERROR 3: BAD FILE NAME PREFIX"
	sleep 1
	echo "KO_FILE_NAME" | nc $CLIENT 3333
	exit 3
fi

FILE_NAME=`echo $DATA | cut -d " " -f 2`
FILE_MD5=`echo $DATA | cut -d " " -f 3`

FILE_MD5_LOCAL=`echo $FILE_NAME | md5sum | cut -d " " -f 1`

if [ "$FILE_MD5" != "$FILE_MD5_LOCAL" ]
then
	echo "ERROR 3: BAD FILE NAME MD5"
	sleep 1
	echo "KO_FILE_NAME" | nc $CLIENT 3333
	exit 3
fi

FILE_NAME=`echo "$DATA" | cut -d " " -f 2`
echo "OK_FILE_NAME" | nc $CLIENT 3333

echo "(13) Listen"
nc -l -p 3333 -w $TIMEOUT > inbox/$FILE_NAME

DATA=`cat inbox/$FILE_name`

echo "(16) Store & Send"

if [ "$DATA" == "" ]
then
	echo "ERROR 4: BAD FILE NAME PREFIX"
	sleep 1
	echo "KO_DATA" | nc $CLIENT 3333
	exit 4
fi

echo $DATA > inbox/$FILE_NAME

echo "(17) Listen"

DATA=`nc -l -p 3333 -w $TIMEOUT`

echo"(20) Test & Send"

if

echo "FINAL"
exit 0

