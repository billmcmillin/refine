#!/bin/bash

file1="international_poets.txt"

while read -r line;
do
	#echo $line
	author1=""
	author1=${line%(*}
	echo $author1
	echo $author1 >> international_authors.txt 
done < $file1
