#!/bin/bash
src_storage="src-stor"
dst_storage="dst-stor"
nodelist=`pvesh get /nodes/|grep "id"|sed 's/",//g'|sed 's/"//g'|awk '{print $3}'|sed 's/node/\/nodes/g'`
for i in ${nodelist}
do
echo ${i}/qemu/
for j in `pvesh get ${i}/qemu/|grep vmid|awk '{print $3}'`
do
echo ${i} ${j}.
for k in `pvesh get ${i}/qemu/${j}/config |grep ${src_storage}":"|awk '{print $1}'|sed 's/"//g'`
do
pvesh create  ${i}/qemu/${j}/move_disk -disk ${k} -storage ${dst_storage} -delete 1
done
done
done

