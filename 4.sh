#!/bin/bash

set -eu

#one liner
cat $1 | awk 'BEGIN{print"開始日時："strftime("%Y/%m/%d %H:%M:%S",systime())}$1==$2||$1==$3||$1==$4||$1==$5||$2==$3||$2==$4||$2==$5||$3==$4||$3==$5||$4==$5{print NR"行目に重複がありました。";exit 1}$4!="a"{print"[a i u e o]";}$4=="a"{print"[         ]"}NR%500==0{print NR"行："strftime("%Y/%m/%d %H:%M:%S",systime())}{moji[$0]++};END{for(i in moji){print "\""i"\" は "moji[i]" 行ありました。"}print"終了日時："strftime("%Y/%m/%d %H:%M:%S",systime())}' | sudo tee resut.log >/dev/null
