#!/bin/sh

. fileList.sh

for file in ${file_list}
do
    cp ${file}_fmt.txt input.txt
    ./morphological.py
    nkf -u output.txt > ${file}_mecab.txt
done

rm input.txt output.txt
