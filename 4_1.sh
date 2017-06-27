#one liner
cat $1 | awk '
BEGIN{
  #開始日時
  print"開始日時："strftime("%Y/%m/%d %H:%M:%S",systime())
}

#文字の重複があれば停止
$1==$2||$1==$3||$1==$4||$1==$5||$2==$3||$2==$4||$2==$5||$3==$4||$3==$5||$4==$5{print NR"行目に重複がありました。";exit 1}

#3文字目が"a"か判定し出力
$4!="a"{print"[a i u e o]"}
$4=="a"{print"[         ]"}

#500行ごとに途中日時
NR%500==0{print NR"行："strftime("%Y/%m/%d %H:%M:%S",systime())}

#文字列の種類ごとの行数カウント
{moji[$0]++}

END{
  #文字列の種類ごとの行数表示
  for(i in moji){print "\""i"\" は "moji[i]" 行ありました。"}

  #終了日時
  print"終了日時："strftime("%Y/%m/%d %H:%M:%S",systime())
}' | sudo tee resut.log >/dev/null
