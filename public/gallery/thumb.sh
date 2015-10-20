#!/bin/bash
FILES=*.jpg
for i in $FILES
do
echo "Prcoessing image $i ..."
convert -define jpeg:size=200x200 $i  -thumbnail 150x150^ -gravity center -extent 150x150  thumb/$i

done
