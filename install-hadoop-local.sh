#!/bin/bash
#HADOOP_VER=${1:-2.9.2}
#DEST=${2:-/usr/local/hadoop2}
#USER=${3:-$(whoami)}

echo "========== BUILDING DOCKER BASE and DAEMON IMAGES =========="
docker-compose -f ./base/docker-compose.yml build
docker-compose -f ./daemon/docker-compose.yml build

echo "========== CREATING DOCKER NETWORK =========="
docker network create -d bridge hadoop
echo "========== FORMATTING NAMENODE =========="
docker-compose run namenode format.sh


echo "========== DOWNLOADING HADOOP ($HADOOP_VER) =========="
curl -o ~/Downloads/hadoop-$HADOOP_VER.tar.gz https://archive.apache.org/dist/hadoop/common/hadoop-$HADOOP_VER/hadoop-$HADOOP_VER.tar.gz

echo "========== UNPACKING HADOOP ($HADOOP_VER) =========="
sudo mkdir $DEST
sudo chown -R $USER /usr/local/hadoop2
tar -C $DEST -zxvf ~/Downloads/hadoop-$HADOOP_VER.tar.gz
sudo ln -s $DEST/hadoop-$HADOOP_VER $DEST/hadoop

echo "========== ADDING HADOOP and HADOOP USER TO ENVIRONMENT =========="
echo "
export HADOOP_HOME=$DEST/hadoop
export HADOOP_USER_NAME=hadoop
export PATH=\$PATH:\$HADOOP_HOME/bin" >> ~/.bash_profile


echo "========== ADDING DOCKER HOSTNAMES TO ETC/HOSTS =========="
echo "
127.0.0.1       namenode
127.0.0.1       datanode1
127.0.0.1       secondarynamenode
127.0.0.1       historyserver
127.0.0.1       resourcemanager" | sudo tee -a /etc/hosts

echo "========== COPY HADOOP CONFIGS =========="
cp -f ./daemon/site/* $DEST/hadoop/etc/hadoop/

echo "========== DISABLE NATIVE CODE WARNING =========="
echo "
log4j.logger.org.apache.hadoop.util.NativeCodeLoader=ERROR" >> $DEST/hadoop/etc/hadoop/log4j.properties