#!/bin/bash
mkdir ./ws #A temporary workspace inside opendistro-build/elasticsearch/linux_distributions
ES_VERSION=$(../bin/version-info --es)
OD_VERSION=$(../bin/version-info --od)
OD_PLUGINVERSION=$OD_VERSION.0
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
#Making zip
zip -r odfe-$OD_VERSION.zip $PACKAGE-$OD_VERSION

##Build Exe
wget https://download-gcdn.ej-technologies.com/install4j/install4j_unix_8_0_4.tar.gz -P $ROOT
tar -xzf $ROOT/install4j_unix_8_0_4.tar.gz --directory $ROOT
rm -rf $ROOT/*tar*
aws s3 cp s3://odfe-windows/ODFE.install4j $ROOT
if [ "$?" -eq "1" ]
then
  echo "Install4j not available"
  exit 1
fi
ls -ltr

#Build the exe
#$ROOT/install4j*/bin/install4jc -d $ROOT/EXE -D sourcedir=$ROOT/$PACKAGE-$OD_VERSION,version=$OD_VERSION --license=L-M8-AMAZON_DEVELOPMENT_CENTER_INDIA_PVT_LTD#50047687020001-3rhvir3mkx479#484b6 $ROOT/ODFE.install4j


