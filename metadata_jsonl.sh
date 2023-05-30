#!/bin/bash
set -x
# Convert preprocessed image text links together to metadata.jsonl 
#cd /root/ppmt
 cd $1
if [ $# = 1 ]; then
for file in *.png; do
    filename=$(basename "$file")
    filename="${filename%.*}"
    txt_file="$filename.txt"
    if [ -f "$txt_file" ]; then
        content=$(cat "$txt_file")
        echo "{\"file_name\":\"$filename.png\",\"text\":\"$content\""} >> metadata.jsonl
    fi
done
else
  echo "Example: es.sh path/to/image_txt"
   exit 1
fi
