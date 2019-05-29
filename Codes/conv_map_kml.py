import numpy as np
import pandas as pd
import sys

# translated from conv_map_kml.c by Bob Crosson
# CWU 5/4/19

desc=str(sys.argv[1]) # descriptive string
overlay=str(sys.argv[2]) # name of overlay image to add
boxwest=float(sys.argv[3]) # west margin of final fig
boxeast=float(sys.argv[4]) # east margin of final fig
boxsouth=float(sys.argv[5]) # south margin of final fig
boxnorth=float(sys.argv[6]) # north margin of final fig
pos=int(sys.argv[7]) # relative position for this figure

posi=pos # integerized position - for slider
posii=pos+1 # pos of next panel

# print out the ground overlay kml code
print("    <GroundOverlay>")
print("        <name>{:s}</name>".format(desc))
print("        <TimeSpan>")
print("            <begin>{:3d}</begin>".format(posi))
print("            <end>{:3d}</end>".format(posii))
print("        </TimeSpan>")
print("        <Icon>")
print("            <href>{}</href>".format(overlay))
print("        </Icon>")
print("        <LatLonBox>")
print("            <north>{:f}</north>".format(boxnorth))
print("            <south>{:f}</south>".format(boxsouth))
print("            <east>{:f}</east>".format(boxeast))
print("            <west>{:f}</west>".format(boxwest))
print("        </LatLonBox>")
print("    </GroundOverlay>")
print("")
