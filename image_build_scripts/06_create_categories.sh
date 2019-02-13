#!/bin/bash
set -ex

echo '##################################################################'
echo '################# configure create categories  ###################'
echo '##################################################################'

echo "INFO: About to create Top-Level Categories"
if [ ! -f /image_build_scripts/top-level-categories.txt ]; then
   echo "No top-level-categories.txt file found so exiting early"
   exit
fi


for name in `cat /image_build_scripts/top-level-categories.txt` ; do

  echo "The name of top level category is ${name}"
  slug=$(echo "$name" | tr '[:upper:]' '[:lower:]')
  wp term create category ${name} --slug=${sleug} --path=/var/www/html/

done

echo "INFO: About to create Sub-Categories"
for line in `cat /image_build_scripts/sub-categories.csv` ; do

  echo "About to process: $line"
  name=`echo $line | cut -d',' -f1`
  slug=$(echo "$name" | tr '[:upper:]' '[:lower:]')
  parent=`echo $line | cut -d',' -f2`
  echo "The name is ${name}"
  echo "The parent is ${parent}"


  echo xxxxxxxxxxxxx
  #wp term list category --fields=name,term_id --path=/var/www/html/ #| grep ${parent}
  # wp term list category --fields=name,term_id --format=csv
  echo "Parent name is: ${parent}"
  echo "parent info is: $(wp term list category --fields=name,term_id --format=csv | grep ${parent})"
  echo xxxxxxxxxxxxx
  parent_id=`wp term list category --fields=name,term_id --format=csv | grep ${parent} | cut -d',' -f2`
  echo "parent_id is $parent_id"

  wp term create category ${name} --slug=${slug} --parent=${parent_id}
done