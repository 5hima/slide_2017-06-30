#!/bin/bash

set -ue

#開始時間を出力
echo "開始日時：`date "+%Y/%m/%d %T"`"　| sudo tee result.log

#処理行数をカウントする変数の宣言
count_line=0

#ファイルから1行ずつ読み込む
while read line; do

  #ファイル内の行数をカウント
  count_line=$(( ${count_line}+1 ))

  #500行ごとに処理時間を出力
  if [ $((${count_line}%500)) -eq 0 ]; then
    echo "${count_line}行目：`date "+%Y/%m/%d %T"`" | sudo tee -a result.log
  fi 

  #行中に重複した文字があればスクリプト停止
  if [ -n "`echo ${line} \
    | tr ' ' '\n' \
    | LC_ALL=C sort \
    | uniq -d \
    | tr -d '\n'`" ]; then
    echo "処理終了：${count_line}行目で文字重複"
    exit 1
  fi

  #3文字目が"a"なら処理しない
  if [ `echo ${line} | cut -d" " -f3` = "a" ]; then
    continue
  fi

  #文字列ソート
  echo ${line} \
    | tr aiueo" " 12345"\n" \
    | LC_ALL=C sort \
    | tr 12345 aiueo \
    | xargs \
    | sudo tee -a result.log >/dev/null

done <$1

#重複している行の行数を出力
cat $1 \
  | sort \
  | uniq -c \
  | awk '{for(i = 2; i <= NF; i++){printf $i" "}print "は"$1"行ありました。"}' \
  | sudo tee -a result.log >/dev/null

#終了時間を出力
echo "終了日時：`date "+%Y/%m/%d %T"`" | sudo tee -a result.log
