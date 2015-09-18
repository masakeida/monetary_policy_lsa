#!/bin/sh

#LF=$(printf '\\\012_')
#LF=${LF%_}

cat - |
    perl -pe 's/^(０|１|２|３|４|５|６|７|８|９|)+$//g' |
    perl -0pe 's/\n\n\n\f//g' |
    # 日本語の間に入った半角スペースを削除したいが、
    # 英語の半角スペースを消したくない。
    sed -e 's/\([a-zA-Z]\) \([a-zA-Z]\)/\1_S_\2/g' |
    sed -e 's/ //g' |
    sed -e 's/_S_/ /g' |
    # ここまで
    perl -pe 's/（問）/\n（問）/g' |
    perl -pe 's/（答）/\n（答）/g' |
    grep -v ^$ |
    perl -pe 's/\n/__EOL__/g' |
    perl -pe 's/（問）(.*?)（答）/（答）/g' |
    perl -pe 's/__EOL__/\n/g'
    #grep -v ^（問）

