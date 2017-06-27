#!/bin/perl

use strict;
use warnings;
use utf8;
binmode STDIN, ':encoding(cp932)';
binmode STDOUT, ':encoding(cp932)';
binmode STDERR, ':encoding(cp932)';

#ファイルオープン
open(DATAFILE, "$ARGV[0]");
open(LOG, "> result.log");

#時間表示の定義
my ($sec, $min, $hour, $mday, $mon, $year, $wday, $yday, $isdst) = localtime(time);
$year += 1900;
$mon +=1;

#開始日時
print LOG "start : ", $year, "\/", $mon, "\/", $mday, " ", $hour, ":", $min, ":", $sec, "\n";

#総行数と文字列別行数を数える変数の定義
my $count_line = 0;
my %moji_line_count = ();

#1行ずつ読み込んでループ
foreach (<DATAFILE>) {

  #末尾の改行を削除
  chomp;
  
  #ファイルの行数を数える
  $moji_line_count{$_}++;
  
  #数字へ変換
  $_ =~ tr/aiueo/12345/;
  
  #ソートして一文字ずつ配列へ格納
  my @moji_sort = split(/ /);
  
  #行数カウント
  $count_line++;
  
  #行数を500で割った値を代入
  my $line500 = $count_line % 500;
  
  #文字列の種類ごとにカウントする変数の宣言
  my %moji_count = ();
  
  #重複文字があれば停止
  foreach (@moji_sort) {
    $moji_count{$_}++;
    exit 1 if $moji_count{$_} >= 2;
  };
  
  #3文字目が"a"であれば処理しない
  #500の倍数行目であれば途中日時をログに書き込む
  if ($moji_sort[2] == 1) {
    print LOG $count_line, "lines : ", $year, "\/", $mon, "\/", $mday, " ", $hour, ":", $min, ":", $sec, "\n" if $line500 == 0 && $count_line != 0;
    next
  };

  #元の文字に戻してログへ書き込む
  my $moji = join(" ", sort @moji_sort);
  $moji =~ tr/12345/aiueo/; 
  print LOG $moji, "\n";
  
  #500の倍数行目であれば途中日時をログに書き込む
  print LOG $count_line, " lines : ", $year, "\/", $mon, "\/", $mday, " ", $hour, ":", $min, ":", $sec, "\n" if $line500 == 0 && $count_line != 0;
};

#文字列の種類ごとの行数をログに書き込む
foreach(keys %moji_line_count) {
  print "\"", $_, "\" is ", $moji_line_count{$_}, " lines.\n";
};

#終了日時
print "finish : ", $year, "\/", $mon, "\/", $mday, " ", $hour, ":", $min, ":", $sec, "\n";

#ファイルクローズ
close(LOG);
close(DATAFILE);
