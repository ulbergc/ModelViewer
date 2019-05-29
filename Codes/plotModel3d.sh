#!/bin/bash
#### code to plot IRIS EMC models from: http://ds.iris.edu/ds/products/emc-earthmodels/

#### read in variables from init_file !!! Need to add default values in case these are empty !!!
init_file=../init_file

homedir=`grep homedir $init_file | awk '{print $2}'`
modelfile=`grep modelfile $init_file | awk '{print $2}'`        # name of the netcdf file to read from
dispname=`grep dispname $init_file | awk '{print $2}'`          # the variable within the netcdf file to display
contname=`grep contname $init_file | awk '{print $2}'`          # the variable within the netcdf file to contour
overlaysdir=`grep overlaysdir $init_file | awk '{print $2}'`    # where to write the overlay images
lat1=`grep lat1 $init_file | awk '{print $2}'`                  # southern latitude boundary
lat2=`grep lat2 $init_file | awk '{print $2}'`                  # northern latitude boundary
lon1=`grep lon1 $init_file | awk '{print $2}'`                  # western longitude boundary
lon2=`grep lon2 $init_file | awk '{print $2}'`                  # eastern longitude boundary
dep1=`grep dep1 $init_file | awk '{print $2}'`                  # shallow depth boundary
dep2=`grep dep2 $init_file | awk '{print $2}'`                  # deep depth boundary
FILE_base_tmp=`grep base_file_name $init_file | awk '{print $2}'` # something to put at the start of the name

modelfile=$homedir/$modelfile
overlaysdir=$homedir/$overlaysdir

tmpdir=$homedir/TMP
#tmpmodel=$tmpdir/temp.nc
tmpvar=$tmpdir/temp_var.nc
tmpcont=$tmpdir/temp_cont.nc

# define plotting parameters
AREA=-R$lon1/$lon2/$lat1/$lat2
PROJ=-JM5i
#ANNOT=-Ba1f.25/a1f.25WNes # adds ticks and labels to axes
ANNOT=-B0WNES # plots without any axis ticks or labels

gmt gmtset FORMAT_GEO_MAP DD
#gmtset DIR_GSHHG ../Auxiliary/gshhg-gmt-2.3.7
gmt gmtset MAP_FRAME_TYPE plain

# prints out the values in variable depth, assigns to zz
zz=`ncks -s '%f\n' -C -v depth $modelfile | awk 'NR > 6 && NF'`

# make ZZ an array of depths
ZZ=( $zz )
#ZZ=( `ncks -s '%f\n' -C -v depth $modelfile | awk 'NR > 6 && NF'` )

# make color palette
gmt makecpt -Cjet -T-10/10/.1 -I -D > $tmpdir/colors.cpt

## print out plotting parameters
echo "Maplims: [$lon1 $lon2 $lat1 $lat2]"
echo "Model:   $modelfile"
echo "Depths:  $dep1 - $dep2"

#### begin for loop over every depth
k=-1 # index into the depth variable to read from the netcdf file
for z in "${ZZ[@]}"
do
k=$((k+1))

# check if this is within the depth bounds in the init_file
if (( $(echo "$z < $dep1" |bc -l) )); then continue; fi
if (( $(echo "$z > $dep2" |bc -l) )); then continue; fi

echo `printf "Doing depth %.1f" "$z"`

FILE=`printf "%s/%s_%05.1f.ps" "$tmpdir" "$FILE_base_tmp" "$z"`

echo "printing to $FILE"

echo "Converting $dispname"
gmt grdconvert $modelfile?$dispname[$k] -G$tmpvar

if [[ -n $contname ]]; then
    echo "Converting $contname"
    gmt grdconvert $modelfile?$contname[$k] -G$tmpcont
fi

# start actual plot
gmt psbasemap $AREA $PROJ $ANNOT -K >$FILE

# plot depth slice of model
gmt grdimage $tmpvar -R -J -O -Q -K -Q -C$tmpdir/colors.cpt >>$FILE

# plot  contours (-GD50k does a label every 50 km)
if [[ -n $contname ]]
then
    gmt grdcontour $tmpcont -R -J -O -C.5 -A.5+f12p -GD75k -Wathicker,white -Wcthick,white >>$FILE
fi

# add depth to plot
echo `printf "%.1f" "$z"` | gmt pstext -R -J -O -F+cTL+jTL+f16,0,black -N -Gwhite -Wthin,black -Dj0i/0.10i -Xa0.1i -K >> $FILE

# draw rivers and close file
#gmt pscoast -R -J -O -W2 -Df -Na -Ia --MAP_TICK_PEN_PRIMARY=thickest >>$FILE

gmt psbasemap -R0/200/0/50 -JX1.2i/.12i -B+n -O >> $FILE # Something to close the file

done
#### end for loop over every depth

# convert files to other format and move to overlays directory
echo "Converting files, putting them in $overlaysdir and cleaning up the trash"
# png version
gmt psconvert -A -P -TG $tmpdir/$FILE_base_tmp*.ps
mv $tmpdir/$FILE_base_tmp*.png $overlaysdir/
# jpg version
#gmt psconvert -A -P -Tj $tmpdir/$FILE_base_tmp*.ps
#mv $tmpdir/$FILE_base_tmp*.jpg $overlaysdir/
# remove temporary files
rm $tmpdir/*

