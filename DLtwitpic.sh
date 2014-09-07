#!/bin/bash
workdir=/tmp/
dld=/home/usr/twitpic/
usrid=usrname
seed=1

if [ ! -d ${dld} ]
then
  mkdir ${dld}
fi

cd ${workdir}
wget -P ${workdir} http://twitpic.com/photos/${usrid}

#末尾ページ認識
lend=`cat "${workdir}${usrid}" | sed "s/\t\|  //g" | tr -d "\n" | sed -e "s/<div id\=\"user\-pagination\">/\n<div id\=\"user\-pagination\">/g" | grep pagination | sed -e "s/></\n/g" | grep Last | grep -o [0-9] | tr -d "\n"`

#
rm ${workdir}${usrid}


#リスト生成
for (( i = 0; i < ${lend}; i++ ))
{

  sleep "1" && wget -P ${workdir} http://twitpic.com/photos/${usrid}?page=${seed}

#抜き取り
  cat "${workdir}${usrid}?page=${seed}" | sed "s/\t\|  //g" | tr -d "\n" | sed -e "s/<div class\=\"user\-photo\-wrap\">/\n<div class\=\"user\-photo\-wrap\">/g" -e "s/<div id\=\"user\-pagination\">/\n<div id\=\"user\-pagination\">/g" | grep -v javascript | grep -o \"\/.*\"\>\<img | sed -e "s/\"\|><img//g" -e "s/^/http\:\/\/twitpic\.com/g" -e "s/$/\/full/g" >> list

#
  rm /tmp/${usrid}?page=${seed}

  (( seed++ ))

}


#画像取得
wrk=`cat ${workdir}list | wc -l`
seed=1

for (( i = 0; i < ${wrk}; i++ ))
{

  sleep "1" && wget -P ${workdir} `cat ${workdir}list | head -${seed} | tail -1`
  sleep "1" && wget -P "${dld}" `cat ${workdir}full | grep d3j5vwomefv46c | grep -o \"[@-~].*\? | sed "s/\"\|\?//g"`

#
  rm ${workdir}full

  (( seed++ ))

}

#
rm ${workdir}list
