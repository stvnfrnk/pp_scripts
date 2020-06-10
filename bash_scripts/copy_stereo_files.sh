#!/bin/bash

data_path=/Volumes/PP_3-2/EGRIP_processed/
target_path=/Users/sfranke/Documents/stereo_files_south

cd $data_path

for dir in EGRIP*
do
	cp $dir/cAxes/stereo.txt ${target_path}/stereo_${dir}.txt
	echo "$dir/cAxes/stereo.txt --> ${target_path}/stereo_${dir}.txt"
done