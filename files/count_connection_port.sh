#!/bin/sh
# Nagios return codes
STATE_OK=0
STATE_WARNING=1
STATE_CRITICAL=2
STATE_UNKNOWN=3
PORT=20145
IP=''
WARNING_THRESHOLD=1500
CRITICAL_THRESHOLD=2000
# Parse parameters
while [ $# -gt 0 ]; do
    case "$1" in
                -p | --port)
                shift
                PORT=$1
                ;;
				-h | --ip)
                shift
                IP=$1
                ;;
        -w | --warning)
                shift
                WARNING_THRESHOLD=$1
                ;;
        -c | --critical)
               shift
                CRITICAL_THRESHOLD=$1
                ;;
        *)  echo "Unknown argument: $1"
            exit $STATE_UNKNOWN
            ;;
        esac
shift
done


#Check open port
LISTEN=(`netstat -an | grep :$PORT | grep LISTEN | wc -l`)

# Return
if  [ $LISTEN -eq 0 ]; then
	echo "No open port $PORT | 'connection'=0;$WARNING_THRESHOLD;$CRITICAL_THRESHOLD;0;0"
	exit $STATE_CRITICAL
fi

#Get port connection
CONNECTIONS=(`netstat -an | grep $IP:$PORT | grep ESTABLISHED | wc -l`)

if  [ $CONNECTIONS -ge $CRITICAL_THRESHOLD ]; then
        echo "Very many connection, connection=$CONNECTIONS | 'connection'=$CONNECTIONS;$WARNING_THRESHOLD;$CRITICAL_THRESHOLD;0;0"
        exit $STATE_CRITICAL
elif  [ $CONNECTIONS -ge $WARNING_THRESHOLD ]; then
        echo "Many connection, connection=$CONNECTIONS | 'connection'=$CONNECTIONS;$WARNING_THRESHOLD;$CRITICAL_THRESHOLD;0;0"
        exit $STATE_WARNING
elif [ $CONNECTIONS -eq 0 ]; then
	echo "No connection, connection=$CONNECTIONS | 'connection'=$CONNECTIONS;$WARNING_THRESHOLD;$CRITICAL_THRESHOLD;0;0"
        exit $STATE_WARNING
else
        echo "Normal, connection=$CONNECTIONS | 'connection'=$CONNECTIONS;$WARNING_THRESHOLD;$CRITICAL_THRESHOLD;0;0"
        exit $STATE_OK
fi

