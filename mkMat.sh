#!/bin/sh

. fileList.sh

master="master.txt"
master_mecab="master_mecab.txt"

if [ -e ${master_mecab} ]; then
    rm ${master_mecab}
fi
touch ${master_mecab}

for file in ${file_list}
do
    sort ${file}_mecab.txt | uniq -c > ${file}_freq.txt
    cat ${file}_mecab.txt >> ${master_mecab}
done

cat ${master_mecab} | sort | uniq > ${master}

# mecab output is a Tab separated text. Take care about the IFS.
cat ${master} | grep -v ^EOS | while IFS= read line
do
    # priods are meta words for RE. printf deletes backslash below.
    line=`echo "${line}" | sed -e 's/\./\\\./g'`
    for file in ${file_list}
    do
	freq=`grep "${line}" ${file}_freq.txt | awk '{print $1}'`
	if [ -n "${freq}" ]; then
	    echo -n ${freq}
	else
	    echo -n 0
	fi
	printf "\t"
    done
    # % are meta words for printf. printf %% shows %.
    line=`echo "${line}" | sed -e 's/%/%%/g'`
    printf "${line}\n"
done
