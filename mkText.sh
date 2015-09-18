#!/bin/sh

. fileList.sh

for file in ${file_list}
do
    /usr/local/libexec/xpdf/pdftotext ${file}.pdf
    cat ${file}.txt | ./delNewPage.sh > ${file}_fmt.txt
done
