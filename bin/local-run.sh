#!/bin/bash

id=$1
date=$2

json=`cat <<EOS
{
  "id": "${id}",
  "date": "${date}"
}
EOS
`

data=$(echo ${json} | base64 |tr -d '\n')

echo $date

curl -XPOST http://localhost:8080/ -H 'Content-Type:application/json; charset=utf-8' -d @- <<EOS
{
  "message": {
    "data": "${data}"
  }
}
EOS

