#!/bin/bash
mkdir ./ws #A temporary workspace inside opendistro-build/elasticsearch/linux_distributions
ES_VERSION=$(../bin/version-info --es)
OD_VERSION=$(../bin/version-info --od)
PACKAGE=opendistroforelasticsearch
ROOT=$(dirname "$0")/ws
TARGET_DIR="$ROOT/Windowsfiles"

#Download windowss oss for copying batch files
wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-oss-$ES_VERSION-windows-x86_64.zip -P $ROOT/
if [ "$?" -eq "1" ]
then
  echo "OSS not available"
  exit 1
fi

#Unzip the oss
unzip $ROOT/elasticsearch-oss-$ES_VERSION-windows-x86_64.zip -d $ROOT
rm -rf $ROOT/elasticsearch-oss-$ES_VERSION-windows-x86_64.zip

#Install plugins
for plugin_path in  opendistro-sql/opendistro_sql-$OD_PLUGINVERSION.zip opendistro-alerting/opendistro_alerting-$OD_PLUGINVERSION.zip opendistro-job-scheduler/opendistro-job-scheduler-$OD_PLUGINVERSION.zip opendistro-security/opendistro_security-$OD_PLUGINVERSION.zip opendistro-index-management/opendistro_index_management-$OD_PLUGINVERSION.zip
do
  $ROOT/elasticsearch-$ES_VERSION/bin/elasticsearch-plugin install --batch "https://d3g5vo6xdbdb9a.cloudfront.net/downloads/elasticsearch-plugins/$plugin_path"
done

mv $ROOT/elasticsearch-$ES_VERSION $ROOT/$PACKAGE-$OD_VERSION
cd $ROOT
ls -l
#Making zip
#cd $TARGET_DIR
#zip -r ./odfe-$OD_VERSION.zip ./$PACKAGE-$OD_VERSION
#echo inside target
#ls -ltr
#pwd
#cd ../..
#echo inside root
#ls -ltr

