#!/usr/bin/env python
# -*- coding: utf-8 -*-

import sys
reload(sys)
sys.setdefaultencoding('utf-8')

import codecs
import MeCab

fin = codecs.open('input.txt', 'r', 'utf-8')
text = fin.read()

m = MeCab.Tagger("-Ochasen")
parse = m.parse(text.encode('utf-8', 'ignore'))

fout = codecs.open('output.txt', 'w', 'utf-8')
fout.write(parse)
