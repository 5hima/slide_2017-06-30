#!/bin/bash

###################################################
#
# 10,000 row processing shell script
# Author 2017.06.16 Rosso kon
#
###################################################

### 変数定義
MOJI=$1
LOG=result.log
DATE="date +%Y%m%d_%H%M%S"

### 開始時間
echo "`${DATE}` Script start." > ${LOG}

### 文字処理
nl -ba ${MOJI} | while read L V W X Y Z
do
    VAL=${V}${W}${X}${Y}${Z}
    NUM=`echo ${L} | rev | cut -c 1-3 | rev`
   if [ ${NUM} = 500 ] || [ ${NUM} = 000 ]; then
    echo "${L}Lines `${DATE}`" >> ${LOG}
    fi

   WORD=("a" "i" "u" "e" "o")
    for NEWWORD in ${WORD[@]}
    do
        WC="`echo ${VAL} | sed "s/${NEWWORD}//g"`"
        if [ ${#WC} -lt 4 ]; then
            exit 99
        fi
    done

   case ${VAL} in
      ??a??)
        echo "`${DATE}` ${LINE}  [         ]" >> ${LOG}
      ;;
      *)
        echo "`${DATE}` ${LINE}  [a i u e o]" >> ${LOG}
      ;;
    esac
done

RC=`echo $?`
if [ ${RC} -ne 0 ]; then
    echo "文字が重複している為、処理を中止します。" >> ${LOG}
    echo "`${DATE}` Script Error End. RC=99" >> ${LOG}
    exit
fi

AIUEO=("a" "i" "u" "e" "o")
for CAL in ${AIUEO[@]}
do
    echo "${CAL}から始まる文字列は`cat ${MOJI} | grep ^${CAL} | wc -l`行でした。" >> ${LOG}
done

### 終了時間
echo "`${DATE}` Script Normal End. RC=0" >> ${LOG}
