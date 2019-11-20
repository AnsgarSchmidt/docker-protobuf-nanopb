#!/bin/bash

cd        /host
mkdir -p  /host/out/python
mkdir -p  /host/out/c
mkdir -p  /host/out/objc

for i in *.proto
do
 name=`basename ${i} .proto`
 protoc --python_out=/host/out/python         ${i}
 protoc --objc_out=/host/out/objc             ${i}
 protoc -o ${name}.pb                         ${i}
 python /nanopb/generator/nanopb_generator.py ${name}.pb

 rm ${name}.pb
 mv ${name}.pb.c /host/out/c
 mv ${name}.pb.h /host/out/c
 cp /nanopb/pb.h        /host/out/c
 cp /nanopb/pb_decode.* /host/out/c
 cp /nanopb/pb_encode.* /host/out/c
 cp /nanopb/pb_common.* /host/out/c
 
done
