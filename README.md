# ModelViewer

Viewing 3D geophysical models in Google Maps or Google Earth

## Steps
  - Find geophysical model at the [IRIS EMC page](http://ds.iris.edu/ds/products/emc-earthmodels/)
  - Edit init_file to set the map bounds, geophysical parameter, etc. 
  - Make images, store them in Overlays/
  - Create .kmz file to view in Google Earth *or* make Google Maps overlays
  
## Technologies
  - netCDF, bash, Generic Mapping Tools (GMT), python, kml
  
### Geophysical Models
This pipeline hasn't been extensively tested with the other models at the [IRIS EMC](http://ds.iris.edu/ds/products/emc-earthmodels/). The primary purpose is to display the iMUSH seismic velocity models described in this paper:

Ulberg, C. W., Creager, K. C., Moran, S. C., Abers, G. A., Thelen, W. A., Levander, A., Kiser, E., Schmandt, B., Hansen, S., Crosson, R. S., (2019, *submitted, JGR*). Local earthquake Vp and Vs tomography in the Mount St. Helens region with the iMUSH broadband array.
