#!/bin/bash
set -x
# Convert preprocessed image text links together to metadata.csv 
# Create an image dataset  
# https://huggingface.co/docs/datasets/v2.12.0/en/image_dataset
#cd /root/img
 cd $1
if [ $# = 1 ]; then
 echo "file_name,text" >> metadata.csv
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
