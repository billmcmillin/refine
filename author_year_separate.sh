#!/bin/bash

file1="Elliston_poets.txt"

while read -r line;
do
	#echo $line
	author1=""
	line=${line:7}
	lineArr=(${line//-/ })
	author1=${line% }
	#echo ${lineArr[@]}
	echo $author1 >> Elliston_authors.txt
done < $file1
