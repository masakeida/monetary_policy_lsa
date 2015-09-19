#!/bin/sh

. fileList.sh

./mkText.sh
./mkFreq.sh
./mkMat.sh > docWords.txt

#R --slave --args ${file_num} < tfidf.R
#less simResult.txt
