#!/usr/bin/env python
# -*- coding: utf-8 -*-

import sys
reload(sys)
sys.setdefaultencoding('euc-jp')

import codecs
import MeCab

#fin = codecs.open('input_e.txt', 'r', 'euc-jp')
fin = codecs.open('input.txt', 'r', 'utf-8')
text = fin.read()

m = MeCab.Tagger("-Ochasen")
parse = m.parse(text.encode('euc-jp', 'ignore'))

fout = codecs.open('output.txt', 'w', 'euc-jp')
fout.write(parse)
