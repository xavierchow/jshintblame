#!/bin/bash
xavier="xavier@some.domain.com";
steven="steven@some.domain.com";
all="$steven,$xavier";

function showUsage() {
  echo "mymail.sh toAddress Subject [-c ccAddress] Body"
  echo "or"
  echo "mymail.sh toAddress Subject [-c ccAddress] -f filePath"
  exit 0;
}

getAddress() {
  local fulladdress
  case "$1" in
    xavier)
      fulladdress=$xavier;;
    steven)
      fulladdress=$steven;;
    all)
      fulladdress=$all;;
    --help)
      fulladdress="";;
    *)
      fulladdress=$1;;
  esac
  echo $fulladdress
}


recipients=`getAddress $1`
title="$2"
shift 2
if [ -z "$recipients" ]; then
  showUsage
fi
if [ "$1" == "-c" ]; then
  carbons=`getAddress $2`
  shift 2
fi
if [ "$1" == "-f" ]; then
  body=`cat $2`
elif [ -z "$1" ]; then
  varstdin=`cat`
  body="$varstdin"
else
  body=$1
fi
ssmtp "$xavier" "$recipients" "$carbons" << TEMPLATE 
To: $recipients
Cc: $carbons
From: $xavier
Subject: $title

$body
TEMPLATE

echo "mail is sent to $recipients ."
