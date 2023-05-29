#!/bin/bash
set -x
# Convert preprocessed image text links together to metadata.csv 
#cd /root/img
 cd $1
if [ $# = 1 ]; then
for file in *.png; do
    filename=$(basename "$file")
    filename="${filename%.*}"
    txt_file="$filename.txt"
    if [ -f "$txt_file" ]; then
        content=$(cat "$txt_file")
        echo "$filename.png,$content" >> metadata.csv
    fi
done
else 
  echo "Example: metadata_cvs.sh /path/to/image_txt"
   exit 1
fi