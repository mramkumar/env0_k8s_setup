#!/usr/bin/env python

import json
import subprocess

cmd = ["terraform","state","pull"]
tf_output = json.loads(subprocess.check_output(cmd))
f= open("hosts","w+")
bastion = []
master = []
worker = []
for item in tf_output['resources']:
   if item['type'] == "aws_instance":
      for ip in item['instances']:
         if item['name'].startswith('bastion'):
            bastion.append(ip['attributes']['public_dns'])
         elif item['name'].startswith('master'):
            master.append(ip['attributes']['private_dns'])
         elif item['name'].startswith('worker'):
            worker.append(ip['attributes']['private_dns'])


# bastion node
f.write("[bastion]\n")
for ip in bastion:
   f.write(ip + "\n")

# master
f.write("[kube-master]\n")
for ip in master:
   f.write(ip + "\n")

# etcd
f.write("[etcd]\n")
for ip in master:
   f.write(ip + "\n")

# worker
f.write("[kube-node]\n")
for ip in worker:
   f.write(ip + "\n")

f.write("[calico-rr]\n")
f.write("[k8s-cluster:children]\n")
f.write("kube-master\n")
f.write("kube-node\n")
f.write("calico-rr\n")

f.write("[all:vars]\n")
f.write("ansible_ssh_common_args='-o StrictHostKeyChecking=no'\n")

f.close()
