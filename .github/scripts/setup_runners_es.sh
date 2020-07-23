#!/bin/bash

REPO_ROOT=`git rev-parse --show-toplevel`
ROOT=`dirname $(realpath $0)`; cd $ROOT
OD_VERSION=`python $REPO_ROOT/bin/version-info --od`

echo "Setup ES to start with YES security configurations"

echo $JAVA_HOME
sudo yum install python37 -y
sudo yum install git -y
sudo curl https://d3g5vo6xdbdb9a.cloudfront.net/yum/staging-opendistroforelasticsearch-artifacts.repo  -o /etc/yum.repos.d/staging-opendistroforelasticsearch-artifacts.repo
sudo yum install wget -y
export PATH=$PATH:$JAVA_HOME
sudo yum install unzip -y
sudo yum install opendistroforelasticsearch-$OD_VERSION -y
sudo mkdir /home/repo
sudo chmod 777 /home/repo
sudo chmod 777 /etc/elasticsearch/elasticsearch.yml
sudo sed -i '/path.logs/a path.repo: ["/home/repo"]' /etc/elasticsearch/elasticsearch.yml
sudo sed -i /^node.max_local_storage_nodes/d /etc/elasticsearch/elasticsearch.yml
sudo systemctl start elasticsearch.service
sleep 30
