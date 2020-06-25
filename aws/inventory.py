#!/usr/bin/env python
import json
import subprocess

def run_tf_cmd():
    global tf_output
    cmd = ["terraform","state","pull"]
    tf_output = json.loads(subprocess.check_output(cmd))

def check_ec2_state():

    run_tf_cmd()
    list_i = []

    for item in tf_output['resources']:
       if item['type'] == "aws_instance":
          for ip in item['instances']:
             if ip['attributes']['instance_state'] == "running":
                 list_i.append(ip['attributes']['private_dns'])
    while len(list_i) == 0:
       check_ec2_state()


def write_to_file():
    check_ec2_state()

    f= open("hosts","w+")

    bastion = []
    master  = []
    worker  = []

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


if __name__ == "__main__":
   write_to_file()
