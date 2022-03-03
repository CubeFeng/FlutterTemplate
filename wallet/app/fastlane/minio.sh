#!/bin/bash

# usage: ./minio.sh my-file-20101.zip ../my-file.zip

fileName=$1
filePath=$2

bucket=ios-artifacts
host=192.168.1.39:9000
s3_key='24fFtZa8scPk3ox5qpN17TOB9IlWrDQy'
s3_secret='PZbQsvySAzHhdc8FJxI7T9u1NkKfq6letER5wBn2GMLYC4DW0mVOp3jUrgoiXaqq'

resource="/${bucket}/${fileName}"
content_type="application/octet-stream"
date=`date -R`
_signature="PUT\n\n${content_type}\n${date}\n${resource}"
signature=`echo -en ${_signature} | openssl sha1 -hmac ${s3_secret} -binary | base64`

curl -X PUT -T "${filePath}" \
          -H "Host: $host" \
          -H "Date: ${date}" \
          -H "Content-Type: ${content_type}" \
          -H "Authorization: AWS ${s3_key}:${signature}" \
          http://$host${resource}