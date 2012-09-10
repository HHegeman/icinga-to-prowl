#!/bin/bash
###############################################################################
# 
# ./prowler.sh
# 
# A Bash script for sending a message to ios with prowl
#
#Usage:
#  	cat message.txt | ./prowler.sh -e <event> -n <From name> -u <url> -a <api key>
#	echo "<your text>" | ./prowler.sh -e <event> -n <From name> -u <url> -a <api key>
#	./prowler.sh -e <event> -n <From name> -u <url> -a <api key> -d <description>
#	./prowler.sh -e <event> -n <From name> -u <url> -a <api key> (Next type message and close with a Ctrl + D)
#   
###############################################################################
set -e

help_text() {
  cat << EOF
Usage: $0 -e <event> -n <From name> -u <url> -a <api key> -d <description>

This script will read from stdin and send it to prowl.

OPTIONS:
   -h               Show this message
   -a <api keys>    Prowl api key.
   -p <priority>    Default 0 if not provided, An integer value ranging [-2, 2].
   -u <url>         The URL which should be opened while while tapping on the event.
   -n <from name>   The name of the sender (your application or machine name)     
   -e <event>       The Subject of the notification.
   -d <description> The message your sending.           
   -o <Prowl Host>  The url of the prowl api host.
Usage:
  	cat message.txt | ./prowler.sh -e <event> -n <From name> -u <url> -a <api key>
	echo "<your text>" | ./prowler.sh -e <event> -n <From name> -u <url> -a <api key>
	./prowler.sh -e <event> -n <From name> -u <url> -a <api key> -d <description>
	./prowler.sh -e <event> -n <From name> -u <url> -a <api key> (Next type message and close with a Ctrl + D)
EOF
}
# Defaults:
APIKEY=""
PRIOR="0"
URL=""
FROMN=""
EVENT=""
DESCR=""
PHOST="https://api.prowlapp.com/publicapi/add"

while getopts “h:a:p:u:n:e:d:o” OPTION; do
  case $OPTION in
    h) help_text; exit 1;;
    a) APIKEY="$OPTARG";;
    p) PRIOR="$OPTARG";;
    u) URL="$OPTARG";;
    n) FROMN="$OPTARG";;
    e) EVENT="$OPTARG";;
    d) DESCR="$OPTARG";;
    o) PHOST="$OPTARG";;
    [?]) help_text; exit;;
  esac
done
# check required.
if [[ -z $APIKEY ]] || [[ -z $PHOST ]] || [[ -z $FROMN ]]; then
	help_text
	exit 1
fi
if [ "x$DESCR" = "x" ]; then
	DESCR=$(cat)
fi
curl -sS -o /dev/null -k $PHOST -F "apikey=$APIKEY" -F "application=$FROMN" -F "description=$DESCR" -F "priority=$PRIOR" -F "event=$EVENT" -F "url=$URL"
exit 0
