#!/bin/bash

#  buildkmz.sh
#
#  Script to create .kmz Google Earth files
#  Incorporates all of the overlay images in Overlays/ into the final kmz file.
#
#  Created by Carl Ulberg on 5/29/19. Modified from code by Bob Crosson
#  

#### read in variables from init_file !!! Need to add default values in case these are empty !!!
init_file=../init_file

homedir=`grep homedir $init_file | awk '{print $2}'`
overlaysdir=`grep overlaysdir $init_file | awk '{print $2}'`    # where to write the overlay images
lat1=`grep lat1 $init_file | awk '{print $2}'`                  # southern latitude boundary
lat2=`grep lat2 $init_file | awk '{print $2}'`                  # northern latitude boundary
lon1=`grep lon1 $init_file | awk '{print $2}'`                  # western longitude boundary
lon2=`grep lon2 $init_file | awk '{print $2}'`                  # eastern longitude boundary
dep1=`grep dep1 $init_file | awk '{print $2}'`                  # shallow depth boundary
dep2=`grep dep2 $init_file | awk '{print $2}'`                  # deep depth boundary
FILE_base_tmp=`grep base_file_name $init_file | awk '{print $2}'` # something to put at the start of the name

#### finish reading init_file parameters

cd $homedir

# remove any preexisting models
/bin/rm -f ./Models/struct_model.kml ./Models/struct_model.kmz

# define overlay description (single string, no spaces)
overlaydesc=ulbergVp_model

# start build sequence for kml file - this constructs the boundary of model
cat ./Auxiliary/top1 >./Models/struct_model.kml
#cat ./Auxiliary/bbox.csv >>struct_model.kml # turned off (not essential)
cat ./Auxiliary/top3 >>./Models/struct_model.kml

# get image names
overlayFiles=`ls Overlays/*`

#echo $overlayFiles
k=0
# add sequence of images
for file in $overlayFiles
do
k=$((k+1))
echo "Adding $file"
python3 ./Codes/conv_map_kml.py $overlaydesc $file $lon1 $lon2 $lat1 $lat2 $k >>./Models/struct_model.kml
done

# add end of kml file
/bin/cat ./Auxiliary/bottom >>./Models/struct_model.kml

# Note that the final zip archive must include the Overlays directory
# in order to be portable. The .kml file only has references to the
# images, not the images themselves. Therefore, the final .kmz
# file must include the Overlays directory for completeness.

# Convert kml file to kmz file.
zip -r ./Models/struct_model ./Models/struct_model.kml ./Overlays
mv ./Models/struct_model.zip ./Models/struct_model.kmz
#/bin/rm struct_model.kml
