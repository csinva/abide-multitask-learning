#!/usr/bin/env bash
folder="full_1"

# delete graphs
echo 'deleting...'
ssh cs3hq@power2.cs.virginia.edu rm /if19/cs3hq/qilab/data/$folder/*/autism*.csv
ssh cs3hq@power2.cs.virginia.edu rm /if19/cs3hq/qilab/data/$folder/*/control*.csv
ssh cs3hq@power2.cs.virginia.edu rm /if19/cs3hq/qilab/data/$folder/*/shared*.csv
ssh cs3hq@power2.cs.virginia.edu rm /if19/cs3hq/qilab/data/$folder/*/ll/autism*.csv
ssh cs3hq@power2.cs.virginia.edu rm /if19/cs3hq/qilab/data/$folder/*/ll/control*.csv
ssh cs3hq@power2.cs.virginia.edu rm /if19/cs3hq/qilab/data/$folder/*/ll/shared*.csv

mkdir "/Users/chandansingh/drive/asdf/research/singh_connectome/data/$folder"
scp -r cs3hq@power2.cs.virginia.edu:/if19/cs3hq/qilab/data/$folder/* \
/Users/chandansingh/drive/asdf/research/singh_connectome/data/$folder