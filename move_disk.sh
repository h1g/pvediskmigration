#!/bin/bash
set -m
src_storage="src-stor"
dst_storage="dst-stor"
#migration speed in MB (0 - no limits)
migration_speed=0
nodelist=`pvesh get /nodes/|grep "id"|sed 's/",//g'|sed 's/"//g'|awk '{print $3}'|sed 's/node/\/nodes/g'|sort`
for i in ${nodelist}
do
echo ${i}/qemu/
for j in `pvesh get ${i}/qemu/|grep vmid|awk '{print $3}'|sort`
do
echo ${i} ${j}.
for k in `pvesh get ${i}/qemu/${j}/config |grep ${src_storage}":"|awk '{print $1}'|sed 's/"//g'`
do
pvesh create  ${i}/qemu/${j}/move_disk -disk ${k} -storage ${dst_storage} -delete 1 &
if [ ${migration_speed} -ne 0 ] ; then sleep 2 && pvesh create  ${i}/qemu/${j}/monitor -command "block_job_set_speed drive-${k} ${migration_speed}" ; fi
fg %1
done
done
done
