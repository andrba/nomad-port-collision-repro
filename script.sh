#!/bin/bash
set -e

docker build -t sleepy:1.0.0 sleepy

nomad job run sys.hcl
nomad job run serv.hcl

printf "\n============================\nSYS JOB ALLOCS\n============================\n"
nomad job allocs sys
printf "\n============================\nSERV JOB ALLOCS\n============================\n"
nomad job allocs serv
printf "\n============================\nSERV JOB LATEST DEPLOYMENT\n============================\n"
nomad job deployments -latest serv

sleep 5

sed 's/ITERATION =.*/ITERATION = 1/' sys.hcl | nomad job run -
sed 's/datacenters =.*/datacenters = ["dc1","dc2"]/' serv.hcl | nomad job run -
