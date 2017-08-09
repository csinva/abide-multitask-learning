#!/usr/bin/env bash
folder="full_1"
scp cs3hq@power2.cs.virginia.edu:/if19/cs3hq/qilab/data/$folder/*/connectome* \
/Users/chandansingh/drive/asdf/research/singh_connectome/data/$folder

scp cs3hq@power2.cs.virginia.edu:/if19/cs3hq/qilab/data/$folder/*/*/connectome* \
/Users/chandansingh/drive/asdf/research/singh_connectome/data/$folder