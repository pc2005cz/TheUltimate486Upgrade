#!/bin/bash

for URL in `cat 0list`; do
	FILE=`echo $URL | sed "s/https\:\/\/i\.ytimg\.com\/vi\///g" | sed "s/\/maxresdefault\.jpg//g"`
	
	wget "$URL" -O "yt_$FILE.jpg"
		
done
