#!/bin/bash

ml=( 'steven@some.domain.com' 'xavier@some.domain.com')
tmpFile='/tmp/hintblame.log'

warn=(`jshint routes/ lib/ app.js | awk -F , '{print $1}' | awk '{print $1 $3 }' | grep 'js' | awk -F : '{print $1,$2}'`)
#clear the old content
> $tmpFile
for index in ${!warn[@]} ; do
  rem=$(( $index % 2))
  if [ $rem -eq 0 ]; then
    nextIndex=$(($index+1))
    echo `git blame -e -L ${warn[$nextIndex]},${warn[$nextIndex]} ${warn[$index]} ` "->" ${warn[$index]} >> $tmpFile
  fi
done

template="Your commit introduced the jshint warning as below, check it please."
for receiver in ${ml[@]} ; do
  items=` echo $template | cat - $tmpFile | grep "$receiver\|$template" `
  length=`echo "$items" | wc -l `
  if [ $length -gt 1 ] ; then
    echo "$items" | mymail.sh $receiver jshint-warning
  fi
done
