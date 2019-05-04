import utm # from https://pypi.org/project/utm/
import numpy as np
import pandas as pd
import sys

# translated from conv_map_kml.c by Bob Crosson
# CWU 5/4/19

# utm usage (https://pypi.org/project/utm/):
# utm.from_latlon(LATITUDE, LONGITUDE)
# (EASTING, NORTHING, ZONE NUMBER, ZONE LETTER)
# utm.to_latlon(EASTING, NORTHING, ZONE NUMBER, ZONE LETTER)
# (LATITUDE, LONGITUDE)

Xorig=0
Yorig=0
zoneNum=0
zoneLet=''

def InitLocalUTM(lonorig,latorig):
    (xorig,yorig,ZN,ZL)=utm.from_latlon(latorig,lonorig)
    return (xorig,yorig,ZN,ZL)

def ToLocalUTM(lon,lat):
    (x,y,ZN,ZL)=utm.from_latlon(lat,lon)
    X=(x-Xorig)/1000
    Y=(y-Yorig)/1000
    return (X,Y)

def FromLocalUTM(x,y):
    X=x*1000
    Y=y*1000
    (LAT,LON)=utm.to_latlon(X+Xorig,Y+Yorig,zoneNum,zoneLet)
    return (LON,LAT)

desc=str(sys.argv[1]) # descriptive string
zone=int(sys.argv[2]) # zone for utm (int)
lonorg=float(sys.argv[3]) # longitude origin
latorg=float(sys.argv[4]) # latitude origin
nxnodes=int(sys.argv[5]) # number of model x nodes
nynodes=int(sys.argv[6]) # number of model y nodes
nznodes=int(sys.argv[7]) # number of model z nodes
nodesp=float(sys.argv[8]) # dist (km) between nodes
zinc=float(sys.argv[9]) # vertical spacing between panels to display (km)
pos=float(sys.argv[10]) # position of current panel
boxwestcorr=float(sys.argv[11]) # corr (decimal km) for west margin of final fig
boxeastcorr=float(sys.argv[12]) # corr (decimal km) for east margin of final fig
boxnorthcorr=float(sys.argv[13]) # corr (decimal km) for north margin of final fig
boxsouthcorr=float(sys.argv[14]) # corr (decimal km) for south margin of final fig

posi=int(pos*10) # integerized position - for slider
posii=int((pos+zinc)*10) # pos of next panel

# initialize coord transforms to local structure model
(Xorig,Yorig,zoneNum,zoneLet)=InitLocalUTM(lonorg,latorg)

# get model dimensions in km
modelnorth=nodesp*(nynodes-1) # or just nynodes?
modeleast=nodesp*(nxnodes-1)

# compute bounds of current panel as lat/lon values
(lon,lat)=FromLocalUTM(modeleast/2,modelnorth+boxnorthcorr)
boxnorth=lat

(lon,lat)=FromLocalUTM(modeleast/2,boxsouthcorr)
boxsouth=lat
    
(lon,lat)=FromLocalUTM(boxwestcorr,modelnorth/2)
boxwest=lon
        
(lon,lat)=FromLocalUTM(modeleast+boxeastcorr,modelnorth/2)
boxeast=lon

# print out the ground overlay kml code
print("    <GroundOverlay>")
print("        <name>{:s}</name>".format(desc))
print("        <TimeSpan>")
print("            <begin>{:5d}</begin>".format(posi))
print("            <end>{:5d}</end>".format(posii))
print("        </TimeSpan>")
print("        <Icon>")
print("            <href>Overlays/0{:05.1f}.gif</href>".format(pos))
print("        </Icon>")
print("        <LatLonBox>")
print("            <north>{:f}</north>".format(boxnorth))
print("            <south>{:f}</south>".format(boxsouth))
print("            <east>{:f}</east>".format(boxeast))
print("            <west>{:f}</west>".format(boxwest))
print("        </LatLonBox>")
print("    </GroundOverlay>")
print("")
