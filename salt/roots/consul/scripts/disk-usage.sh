#!/bin/bash
percentage=`df --output=pcent / | grep -P "[[:digit:]]+" -o`
 echo "$percentage% disk used.";
if [ $percentage -gt $1 ]; then
 exit 1;
else
 exit 0
fi